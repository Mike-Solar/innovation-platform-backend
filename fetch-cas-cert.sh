#!/bin/bash
# ==========================================
# 获取 CAS 服务器 SSL 证书脚本
# 在宿主机运行，将证书保存到 certs 目录供 Docker 使用
# ==========================================

set -e

CAS_HOST=${1:-"ids.wisedu.com.cn"}
CAS_PORT=${2:-"9086"}
CERT_DIR="./certs"

echo "=========================================="
echo "CAS 服务器证书获取工具"
echo "=========================================="
echo "CAS服务器: $CAS_HOST:$CAS_PORT"
echo "证书保存目录: $CERT_DIR"
echo ""

# 创建证书目录
mkdir -p "$CERT_DIR"

# 获取证书
CERT_FILE="$CERT_DIR/cas-server.crt"
echo "正在获取证书..."
echo | openssl s_client -connect $CAS_HOST:$CAS_PORT -servername $CAS_HOST 2>/dev/null | \
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "$CERT_FILE"

if [ ! -s "$CERT_FILE" ]; then
    echo "错误：无法获取证书"
    exit 1
fi

echo "✓ 证书已保存到: $CERT_FILE"
echo ""
echo "证书信息:"
openssl x509 -in "$CERT_FILE" -noout -subject -issuer -dates
echo ""
echo "=========================================="
echo "接下来请执行:"
echo "1. 确保 docker-compose.yml 中挂载了 certs 目录"
echo "2. docker-compose up -d 启动服务"
echo "=========================================="
