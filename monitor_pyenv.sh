#!/bin/bash

LOG_DIR="/tmp"
BUILD_LOG=$(ls -t $LOG_DIR/python-build*.log 2>/dev/null | head -n 1)

echo "------------------------------------------"
echo "   PYENV BUILD MONITOR INTELIGENTE"
echo "------------------------------------------"

if [ -z "$BUILD_LOG" ]; then
    echo "⚠️ No se encontró log de pyenv build aún"
    exit 1
fi

echo "📄 Log detectado: $BUILD_LOG"
echo ""

watch -n 2 "
echo '=============================='
echo '🔎 ESTADO DEL BUILD PYENV'
echo '=============================='

ps aux | grep -E 'python-build|gcc|make|compileall' | grep -v grep

echo ''
echo '📊 Fases:'

grep -q 'Downloading' $BUILD_LOG && echo '✔ Descarga' || echo '⏳ Descarga'
grep -q 'configure' $BUILD_LOG && echo '✔ Configuración' || echo '⏳ configure'
grep -q 'gcc' $BUILD_LOG && echo '✔ Compilación C' || echo '⏳ gcc'
grep -q 'compileall' $BUILD_LOG && echo '✔ Librerías Python' || echo '⏳ compileall'
grep -q 'make install' $BUILD_LOG && echo '✔ Instalación final' || echo '⏳ install'

echo ''
PROG=0
grep -q 'Downloading' $BUILD_LOG && PROG=20
grep -q 'configure' $BUILD_LOG && PROG=40
grep -q 'gcc' $BUILD_LOG && PROG=65
grep -q 'compileall' $BUILD_LOG && PROG=85
grep -q 'make install' $BUILD_LOG && PROG=95

echo "👉 ${PROG}% estimado"

if grep -q 'Successfully installed' $BUILD_LOG; then
    echo '🎉 COMPLETADO'
elif grep -q 'Error' $BUILD_LOG; then
    echo '❌ ERROR'
fi
"
