#!/data/data/com.termux/files/usr/bin/bash

clear
echo "=========================================="
echo "🧠 DIAGNÓSTICO ULTRA - TERMUX BUILD ENV"
echo "=========================================="
echo ""

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
section "FASE 1: SISTEMA"

uname -a
echo "Arquitectura: $(uname -m)"
echo "Shell: $SHELL"
echo "Usuario: $(whoami)"
echo "PWD: $(pwd)"

if [[ "$(uname -m)" == "aarch64" ]]; then
  echo "❌ ARM64 (limitación real para SDK Android)"
  sys=40
else
  echo "✔ x86_64"
  sys=100
fi

# =========================
# FASE 2: TERMUX PKG
# =========================
section "FASE 2: PAQUETES TERMUX"

pkg list-installed | head -n 20

if command -v git >/dev/null; then git_ok=100; else git_ok=30; fi
if command -v python >/dev/null; then py_ok=100; else py_ok=30; fi

# =========================
# FASE 3: PYTHON ENV
# =========================
section "FASE 3: PYTHON"

python --version 2>/dev/null
pip --version 2>/dev/null

pip list 2>/dev/null | grep -E "buildozer|cython|kivy"

# =========================
# FASE 4: PROYECTO
# =========================
section "FASE 4: PROYECTO"

ls -lah | head -n 15

[ -f main.py ] && echo "✔ main.py OK" || echo "❌ main.py faltante"
[ -f main.kv ] && echo "✔ UI OK" || echo "❌ UI faltante"
[ -d ia_core ] && echo "✔ IA OK" || echo "❌ IA faltante"

# =========================
# FASE 5: BUILDOZER
# =========================
section "FASE 5: BUILDOZER"

if [ -f buildozer.spec ]; then
  echo "✔ buildozer.spec encontrado"
  grep -E "android.api|android.minapi|android.archs|android.build_tools" buildozer.spec

  if grep -q "None" buildozer.spec; then
    echo "⚠ Valores NONE detectados"
    cfg=60
  else
    cfg=90
  fi
else
  echo "❌ buildozer.spec NO encontrado"
  cfg=0
fi

# =========================
# FASE 6: SDK (SI EXISTE)
# =========================
section "FASE 6: SDK"

SDK="$HOME/.buildozer/android/platform/android-sdk"

if [ -d "$SDK" ]; then
  echo "✔ SDK detectado"
  ls "$SDK"

  if [ -d "$SDK/platforms/android-34" ]; then
    echo "✔ android-34 OK"
    sdk=80
  else
    echo "❌ platform faltante"
    sdk=40
  fi
else
  echo "⚠ SDK no presente en Termux (normal)"
  sdk=20
fi

# =========================
# FASE 7: JAVA
# =========================
section "FASE 7: JAVA"

java -version 2>&1 | head -n 1

# =========================
# FASE 8: GIT
# =========================
section "FASE 8: GIT"

git remote -v

if git remote -v | grep -q origin; then
  echo "✔ Repo conectado"
  git_conn=90
else
  echo "⚠ Sin conexión remota"
  git_conn=40
fi

# =========================
# RESULTADO
# =========================
section "RESULTADO FINAL"

total=$((sys + git_ok + py_ok + cfg + sdk + git_conn))
score=$((total / 6))

echo "🎯 SCORE GLOBAL:"
bar $score

echo ""
echo "📊 DETALLE:"
echo "Sistema: $sys%"
echo "Git local: $git_ok%"
echo "Python: $py_ok%"
echo "Config: $cfg%"
echo "SDK: $sdk%"
echo "Git remoto: $git_conn%"

echo ""
echo "⚠ BLOQUEO REAL:"
echo "→ ARM64 no ejecuta binarios Android SDK x86_64"

echo ""
echo "💡 CONCLUSIÓN:"
echo "→ Termux = entorno de desarrollo"
echo "→ Compilación APK requiere x86_64"

echo ""
echo "=========================================="
echo "FIN"
echo "=========================================="
