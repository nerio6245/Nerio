import os
import sys
import importlib


class CompatibilityEngine:

    def __init__(self):
        self.errors = []
        self.warnings = []
        self.status = "OK"

    # -------------------------
    # ESCANEO DE MÓDULOS
    # -------------------------
    def scan_modules(self, modules):

        results = {}

        for mod in modules:
            try:
                importlib.import_module(mod)
                results[mod] = "OK"
            except Exception as e:
                results[mod] = f"ERROR: {str(e)}"
                self.errors.append(mod)

        return results

    # -------------------------
    # VERIFICAR SISTEMA
    # -------------------------
    def check_system(self):

        checks = {
            "python_version": sys.version,
            "platform": sys.platform,
            "env": dict(os.environ)
        }

        return checks

    # -------------------------
    # ANALIZAR BUILD
    # -------------------------
    def analyze_buildozer_spec(self, path="buildozer.spec"):

        if not os.path.exists(path):
            return "buildozer.spec NO encontrado"

        with open(path, "r") as f:
            content = f.read()

        issues = []

        if "kivy" not in content:
            issues.append("Falta dependencia Kivy")

        if "android" not in content:
            issues.append("No se detecta configuración Android")

        if "requirements" not in content:
            issues.append("Faltan requirements")

        return {
            "issues": issues,
            "raw": content[:300]
        }

    # -------------------------
    # ESTADO GENERAL
    # -------------------------
    def status_report(self):

        return {
            "status": self.status,
            "errors": self.errors,
            "warnings": self.warnings
        }
