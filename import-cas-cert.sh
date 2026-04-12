#!/bin/bash
# ==========================================
# CAS服务器SSL证书导入脚本
# 用于将CAS服务器的证书导入到Java信任库
# ==========================================

set -e

# 配置参数
CAS_HOST=${1:-"ids.wisedu.com.cn"}
CAS_PORT=${2:-"9086"}
KEYSTORE_PASS=${3:-"changeit"}

# Java密钥库路径
JAVA_HOME=${JAVA_HOME:-$(readlink -f /usr/bin/java | sed "s:/bin/java::" | sed "s:/jre/bin/java::")}
KEYSTORE_PATH="$JAVA_HOME/lib/security/cacerts"

# 如果找不到，尝试其他常见路径
if [ ! -f "$KEYSTORE_PATH" ]; then
    KEYSTORE_PATH="$JAVA_HOME/jre/lib/security/cacerts"
fi

if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "错误：找不到Java密钥库文件"
    echo "请手动设置 JAVA_HOME 环境变量"
    exit 1
fi

echo "=========================================="
echo "CAS服务器证书导入工具"
echo "=========================================="
echo "CAS服务器: $CAS_HOST:$CAS_PORT"
echo "Java密钥库: $KEYSTORE_PATH"
echo ""

# 下载证书
echo "步骤1: 从CAS服务器获取证书..."
TEMP_CERT=$(mktemp)

# 使用openssl获取证书
echo | openssl s_client -connect $CAS_HOST:$CAS_PORT -servername $CAS_HOST 2>/dev/null | \
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $TEMP_CERT

if [ ! -s "$TEMP_CERT" ]; then
    echo "错误：无法获取证书，请检查CAS服务器地址和端口"
    rm -f $TEMP_CERT
    exit 1
fi

echo "✓ 证书获取成功"
echo ""

# 查看证书信息
echo "步骤2: 证书信息..."
openssl x509 -in $TEMP_CERT -noout -subject -issuer -dates
echo ""

# 导入证书
ALIAS="cas-server-$CAS_HOST"

echo "步骤3: 导入证书到Java密钥库..."
keytool -import -alias $ALIAS -keystore $KEYSTORE_PATH -file $TEMP_CERT -storepass $KEYSTORE_PASS -noprompt 2>/dev/null || {
    echo "证书已存在，尝试删除旧证书并重新导入..."
    keytool -delete -alias $ALIAS -keystore $KEYSTORE_PATH -storepass $KEYSTORE_PASS -noprompt 2>/dev/null || true
    keytool -import -alias $ALIAS -keystore $KEYSTORE_PATH -file $TEMP_CERT -storepass $KEYSTORE_PASS -noprompt
}

echo "✓ 证书导入成功"
echo ""

# 验证导入
echo "步骤4: 验证证书..."
keytool -list -keystore $KEYSTORE_PATH -storepass $KEYSTORE_PASS | grep $ALIAS
echo ""

# 清理临时文件
rm -f $TEMP_CERT

echo "=========================================="
echo "证书导入完成！"
echo "请重启应用服务使配置生效"
echo "=========================================="
