class CoreIA:

    def __init__(self):
        self.estado = "activo"
        self.historial = []
        self.memoria = {}
        self.ciclos = 0

    # -------------------
    # MOTOR PRINCIPAL
    # -------------------
    def procesar(self, texto):
        texto = texto.lower().strip()

        self.ciclos += 1
        self.historial.append(texto)

        # ---- RESPUESTAS BASE ----
        if "hola" in texto:
            return "Hola, sistema IA unificado activo."

        if "como estas" in texto:
            return "Estoy estable y funcionando correctamente."

        if "estado" in texto:
            return self.obtener_estado()

        if "guardar" in texto:
            self.memoria[len(self.memoria)] = texto
            return "Dato guardado en memoria."

        # ---- RESPUESTA GENERAL ----
        return f"IA unificada procesó: {texto}"

    # -------------------
    # ESTADO DEL SISTEMA
    # -------------------
    def obtener_estado(self):
        return {
            "estado": self.estado,
            "ciclos": self.ciclos,
            "historial": len(self.historial),
            "memoria": len(self.memoria)
        }
