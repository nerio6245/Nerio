# main.py - App con IA básica (sin psutil, usa comandos del sistema)
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button
from kivy.uix.label import Label
import subprocess
import re

# Respuestas básicas
respuestas = {
    "hola": "¡Hola! ¿Cómo estás?",
    "como estas": "Bien, gracias por preguntar.",
    "quien eres": "Soy una IA básica creada para Nerio.",
    "ayuda": "Puedes preguntarme cosas simples, 'estado' para ver recursos, o 'salir'.",
    "gracias": "De nada. Estoy para servirte.",
    "estado": "Voy a mostrarte el estado del sistema.",
}

def obtener_estado():
    try:
        # Obtener memoria RAM con el comando 'free'
        resultado = subprocess.run(['free', '-h'], capture_output=True, text=True, timeout=2)
        salida = resultado.stdout
        # Buscar línea de Mem:
        for linea in salida.split('\n'):
            if linea.startswith('Mem:'):
                partes = linea.split()
                # partes: [Mem:, total, used, free, shared, buff/cache, available]
                total = partes[1]
                usada = partes[2]
                return f"📊 RAM:\nTotal: {total}\nUsada: {usada}\n(Usando comando free)"
        return "No se pudo obtener la memoria."
    except Exception as e:
        return f"Error al obtener estado: {e}"

def responder(mensaje):
    mensaje = mensaje.lower().strip()
    if mensaje == "salir":
        return "Hasta luego, Nerio."
    if mensaje == "estado":
        return obtener_estado()
    for palabra, respuesta in respuestas.items():
        if palabra in mensaje:
            return respuesta
    return "No entendí. Escribe 'ayuda' para ver opciones."

class ChatApp(App):
    def build(self):
        layout = BoxLayout(orientation='vertical', spacing=10, padding=10)
        self.historial = Label(size_hint_y=0.7, text="", halign='left', valign='top')
        self.historial.bind(size=self.historial.setter('text_size'))
        self.entrada = TextInput(size_hint_y=0.15, multiline=False)
        enviar = Button(text="Enviar", size_hint_y=0.15)
        enviar.bind(on_press=self.enviar_mensaje)
        layout.add_widget(self.historial)
        layout.add_widget(self.entrada)
        layout.add_widget(enviar)
        return layout

    def enviar_mensaje(self, instance):
        texto = self.entrada.text.strip()
        if texto:
            self.historial.text += f"Tú: {texto}\n"
            respuesta = responder(texto)
            self.historial.text += f"IA: {respuesta}\n\n"
            self.entrada.text = ""
            if respuesta == "Hasta luego, Nerio.":
                self.stop()

if __name__ == "__main__":
    ChatApp().run()
