def responder(mensaje):
    mensaje = mensaje.lower().strip()

    if "hola" in mensaje:
        return "Hola, estoy activa."

    if "estado" in mensaje:
        return "Sistema funcionando correctamente."

    return "No entendí tu mensaje"
