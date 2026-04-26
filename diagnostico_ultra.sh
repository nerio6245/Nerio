#!/bin/bash

clear
echo "=========================================="
echo "🧠 DIAGNÓSTICO ULTRA - BUILD ANDROID ENV"
echo "=========================================="
echo ""

# =========================
# FUNCIONES
# =========================
bar() {
  perc=$1
  total=20
  filled=$((perc * total / 100))
  empty=$((total - filled))
  printf "["
  for ((i=0;i<filled;i++)); do printf "█"; done
  for ((i=0;i<empty;i++)); do printf "░"; done
  printf "] %d%%\n" "$perc"
}

section() {
  echo ""
  echo "📍 $1"
  echo "------------------------------------------"
}

# =========================
# FASE 1: SISTEMA
# =========================
section "FASE 1: SISTEMA BASE"

uname -a
echo "Arquitectura: $(arch)"
echo "Usuario: $(whoami)"
echo "PWD: $(pwd)"

if [[ "$(arch)" == "aarch64" ]]; then
  echo "❌ ARM64 detectado (limitación para SDK x86_64)"
  sys_ok=50
else
  echo "✔ x86_64 detectado"
  sys_ok=100
fi

# =========================
# FASE 2: PYTHON
# =========================
section "FASE 2: PYTHON / VENV"

python3 --version 2>/dev/null
pip --version 2>/dev/null

echo ""
echo "Paquetes clave:"
pip list | grep -E "buildozer|cython|kivy|setuptools|wheel|virtualenv"

py_ok=80

# =========================
# FASE 3: BUILD CONFIG
# =========================
section "FASE 3: BUILDOZER.SPEC"

if [ -f buildozer.spec ]; then
  echo "✔ buildozer.spec encontrado"
  grep -E "android.api|android.minapi|android.ndk|android.archs|android.build_tools" buildozer.spec

  # chequeo NONE / vacío
  if grep -q "None" buildozer.spec; then
    echo "⚠ Detectado 'None' en configuración"
    cfg_ok=60
  else
    echo "✔ Configuración sin valores nulos"
    cfg_ok=90
  fi
else
  echo "❌ buildozer.spec NO encontrado"
  cfg_ok=0
fi

# =========================
# FASE 4: SDK
# =========================
section "FASE 4: ANDROID SDK"

SDK="$HOME/.buildozer/android/platform/android-sdk"

if [ -d "$SDK" ]; then
  echo "✔ SDK detectado"
  ls "$SDK"

  if [ -d "$SDK/platforms/android-34" ]; then
    echo "✔ platform android-34 OK"
    sdk_ok=80
  else
    echo "❌ platform faltante"
    sdk_ok=40
  fi
else
  echo "❌ SDK no encontrado"
  sdk_ok=0
fi

# =========================
# FASE 5: BUILD-TOOLS
# =========================
section "FASE 5: BUILD-TOOLS"

BT="$SDK/build-tools/34.0.0/aidl"

if [ -f "$BT" ]; then
  file "$BT"
  if file "$BT" | grep -q "x86-64"; then
    echo "❌ AIDL x86_64 incompatible con ARM"
    bt_ok=30
  else
    echo "✔ AIDL compatible"
    bt_ok=90
  fi
else
  echo "❌ AIDL no encontrado"
  bt_ok=0
fi

# =========================
# FASE 6: NDK
# =========================
section "FASE 6: ANDROID NDK"

NDK="$HOME/.buildozer/android/platform/android-ndk"

if [ -d "$NDK" ]; then
  echo "✔ NDK presente"
  ls "$NDK"
  ndk_ok=80
else
  echo "❌ NDK faltante"
  ndk_ok=0
fi

# =========================
# FASE 7: JAVA / ANT
# =========================
section "FASE 7: JAVA / ANT"

java -version 2>&1 | head -n 1
ant -version 2>/dev/null

java_ok=100

# =========================
# FASE 8: GIT / GITHUB
# =========================
section "FASE 8: GIT / REMOTO"

git remote -v

if git remote -v | grep -q "origin"; then
  echo "✔ Remote detectado"
  git_ok=80
else
  echo "❌ No conectado a GitHub"
  git_ok=20
fi

# =========================
# FASE 9: PROYECTO
# =========================
section "FASE 9: ESTRUCTURA PROYECTO"

ls -lah | head -n 20

if [ -f main.py ]; then
  echo "✔ main.py OK"
  proj_ok=90
else
  echo "❌ main.py faltante"
  proj_ok=20
fi

# =========================
# FASE 10: IA / UI
# =========================
section "FASE 10: IA + UI"

if [ -d ia_core ]; then
  echo "✔ IA Core detectado"
  ls ia_core | head
  ia_ok=85
else
  echo "❌ IA Core faltante"
  ia_ok=20
fi

if [ -f main.kv ]; then
  echo "✔ UI Kivy detectado"
  ui_ok=85
else
  echo "❌ UI faltante"
  ui_ok=20
fi

# =========================
# RESULTADO FINAL
# =========================
section "RESULTADO GLOBAL"

total=$((sys_ok + py_ok + cfg_ok + sdk_ok + bt_ok + ndk_ok + java_ok + git_ok + proj_ok + ia_ok + ui_ok))
score=$((total / 11))

echo "🎯 SCORE GLOBAL:"
bar $score

echo ""
echo "📊 DETALLE:"
echo "Sistema: $sys_ok%"
echo "Python: $py_ok%"
echo "Config: $cfg_ok%"
echo "SDK: $sdk_ok%"
echo "Build-tools: $bt_ok%"
echo "NDK: $ndk_ok%"
echo "Java: $java_ok%"
echo "Git: $git_ok%"
echo "Proyecto: $proj_ok%"
echo "IA: $ia_ok%"
echo "UI: $ui_ok%"

echo ""
echo "⚠ BLOQUEO PRINCIPAL:"
echo "→ Arquitectura ARM vs SDK x86_64"

echo ""
echo "💡 RECOMENDACIÓN:"
echo "→ Migrar compilación a entorno x86_64 (GitHub Codespaces / VPS / PC)"

echo ""
echo "=========================================="
echo "FIN DEL DIAGNÓSTICO"
echo "=========================================="
