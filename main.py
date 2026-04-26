#!/usr/bin/env python3

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button
from kivy.uix.label import Label

from ia_core.core import CoreIA


class RootWidget(BoxLayout):

    def __init__(self, **kwargs):
        super().__init__(orientation="vertical", **kwargs)

        self.ia = CoreIA()

        self.chat = Label(text="IA lista...\n", size_hint_y=0.8)
        self.add_widget(self.chat)

        self.input = TextInput(size_hint_y=0.1, multiline=False)
        self.add_widget(self.input)

        self.btn = Button(text="Enviar", size_hint_y=0.1)
        self.btn.bind(on_press=self.enviar)
        self.add_widget(self.btn)

    def enviar(self, instance):
        texto = self.input.text

        if not texto:
            return

        respuesta = self.ia.procesar(texto)

        self.chat.text += f"\nTú: {texto}\nIA: {respuesta}\n"
        self.input.text = ""


class IAApp(App):
    def build(self):
        return RootWidget()


if __name__ == "__main__":
    IAApp().run()
