#!/bin/sh
# ==========================================
# Docker 容器启动脚本
# 1. 导入 CAS 证书（如果存在）
# 2. 启动应用
# ==========================================

set -e

# Java 密钥库路径
KEYSTORE_PATH="$JAVA_HOME/lib/security/cacerts"
if [ ! -f "$KEYSTORE_PATH" ]; then
    KEYSTORE_PATH="/opt/java/openjdk/lib/security/cacerts"
fi

# 导入证书函数
import_certs() {
    local cert_dir="/app/certs"
    
    if [ -d "$cert_dir" ]; then
        echo "正在导入 CAS 证书..."
        for cert in "$cert_dir"/*.crt "$cert_dir"/*.pem; do
            if [ -f "$cert" ]; then
                alias=$(basename "$cert" | sed 's/[^a-zA-Z0-9]/_/g')
                echo "导入证书: $cert (alias: $alias)"
                keytool -import -alias "$alias" -keystore "$KEYSTORE_PATH" -file "$cert" -storepass changeit -noprompt 2>/dev/null || {
                    echo "证书 $alias 已存在或导入失败，跳过"
                }
            fi
        done
        echo "证书导入完成"
    fi
}

# 执行证书导入
import_certs

# 启动应用
echo "启动应用..."
exec java -jar -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=prod app.jar
