import requests

class OnlineEngine:
    def buscar(self, query):
        try:
            url = f"https://api.duckduckgo.com/?q={query}&format=json&no_html=1&skip_disambig=1"
            
            r = requests.get(url, timeout=5)
            data = r.json()

            resultado = data.get("AbstractText")

            if resultado:
                return {
                    "modo": "online",
                    "respuesta": resultado
                }

            return {
                "modo": "online",
                "respuesta": "Sin información directa"
            }

        except Exception:
            return {
                "modo": "offline",
                "respuesta": None
            }

