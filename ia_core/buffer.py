import time
import json


class Buffer:

    def __init__(self):
        # flujo base
        self.inputs = []
        self.outputs = []

        # conversación estructurada
        self.conversaciones = []

        # escenarios (contextos)
        self.escenarios = {}

        # contexto activo
        self.contexto_actual = "general"

    # -------------------------
    # INPUT USUARIO
    # -------------------------
    def add_input(self, data):

        registro = {
            "tipo": "input",
            "data": data,
            "time": time.time(),
            "contexto": self.contexto_actual
        }

        self.inputs.append(registro)

        self._registrar_conversacion("usuario", data)

    # -------------------------
    # OUTPUT IA
    # -------------------------
    def add_output(self, data):

        registro = {
            "tipo": "output",
            "data": data,
            "time": time.time(),
            "contexto": self.contexto_actual
        }

        self.outputs.append(registro)

        self._registrar_conversacion("ia", data)

    # -------------------------
    # REGISTRO CENTRAL DE CONVERSACIÓN
    # -------------------------
    def _registrar_conversacion(self, rol, mensaje):

        self.conversaciones.append({
            "rol": rol,
            "mensaje": mensaje,
            "contexto": self.contexto_actual,
            "time": time.time()
        })

    # -------------------------
    # CAMBIAR CONTEXTO / ESCENARIO
    # -------------------------
    def set_contexto(self, nombre):

        if not nombre:
            return

        self.contexto_actual = nombre

        if nombre not in self.escenarios:
            self.escenarios[nombre] = []

    # -------------------------
    # GUARDAR EN ESCENARIO
    # -------------------------
    def guardar_en_escenario(self, data):

        if self.contexto_actual not in self.escenarios:
            self.escenarios[self.contexto_actual] = []

        self.escenarios[self.contexto_actual].append({
            "data": data,
            "time": time.time()
        })

    # -------------------------
    # CONSULTA SIMPLE PARA IA/UI
    # -------------------------
    def get_resumen_usuario(self):

        return {
            "ultimos_mensajes": self.conversaciones[-10:],
            "total_inputs": len(self.inputs),
            "total_outputs": len(self.outputs),
            "contexto_actual": self.contexto_actual
        }

    # -------------------------
    # FORMATO HUMANO (CHAT REAL)
    # -------------------------
    def get_memoria_humana(self):

        return [
            f"{c['rol']}: {c['mensaje']}"
            for c in self.conversaciones[-15:]
        ]

    # -------------------------
    # BÚSQUEDA EN MEMORIA
    # -------------------------
    def buscar(self, palabra):

        return [
            c for c in self.conversaciones
            if palabra.lower() in str(c["mensaje"]).lower()
        ]

    # -------------------------
    # ESTADO GENERAL
    # -------------------------
    def status(self):

        return {
            "inputs": len(self.inputs),
            "outputs": len(self.outputs),
            "conversaciones": len(self.conversaciones),
            "escenarios": list(self.escenarios.keys()),
            "contexto_actual": self.contexto_actual
        }

    # -------------------------
    # EXPORTAR SISTEMA COMPLETO
    # -------------------------
    def exportar(self):

        return {
            "inputs": self.inputs,
            "outputs": self.outputs,
            "conversaciones": self.conversaciones,
            "escenarios": self.escenarios,
            "contexto_actual": self.contexto_actual
        }

    # -------------------------
    # GUARDAR EN ARCHIVO
    # -------------------------
    def guardar_archivo(self, ruta="buffer_data.json"):

        try:
            with open(ruta, "w") as f:
                json.dump(self.exportar(), f)

        except Exception as e:
            return f"Error guardando buffer: {str(e)}"
