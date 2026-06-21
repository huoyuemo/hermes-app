#!/bin/bash
# 编译 Hermes APK
# 依赖: Android SDK, Java 17+, Gradle
# 用法: ./build.sh              -> debug APK
#       ./build.sh release      -> release APK (需要签名)

set -e

MODE="${1:-debug}"

# 检查 Android SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "请设置 ANDROID_HOME 环境变量为你的 Android SDK 路径"
    echo "例如: export ANDROID_HOME=~/Android/Sdk"
    exit 1
fi

echo "=== 编译 Hermes APK ==="
echo "模式: $MODE"

# 确认 gradlew 存在
if [ ! -f "./gradlew" ]; then
    echo "gradlew 未找到，请先安装 Gradle wrapper"
    echo "在 Android Studio 中打开此项目会自动生成"
    exit 1
fi

chmod +x ./gradlew

if [ "$MODE" = "release" ]; then
    ./gradlew assembleRelease
    APK_PATH="app/build/outputs/apk/release/app-release-unsigned.apk"
    echo ""
    echo "=== Release APK 已生成 ==="
    echo "路径: $APK_PATH"
    echo ""
    echo "签名步骤:"
    echo "1. 生成密钥: keytool -genkey -v -keystore hermes.keystore -alias hermes -keyalg RSA -keysize 2048 -validity 10000"
    echo "2. 签名APK: apksigner sign --ks hermes.keystore --out hermes-release.apk $APK_PATH"
else
    ./gradlew assembleDebug
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
    echo ""
    echo "=== Debug APK 已生成 ==="
    echo "路径: $APK_PATH"
    echo "可直接 adb install $APK_PATH"
fi
