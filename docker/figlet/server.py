import cgi
from http import server
import json
import socketserver

from shared import render


def start():
    with socketserver.TCPServer(("", 8000), Handler) as httpd:
        httpd.serve_forever()


# IMPORTANT: not hardened, use only for local development
class Handler(server.BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        if self.path != "/api/figlet/":
            self.send_response(404)
            self.end_headers()
            return

        host = self.headers.get("Host")
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "POST")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.end_headers()

    def do_POST(self):
        if self.path != "/api/figlet/":
            self.send_response(404)
            self.end_headers()
            return

        ctype, pdict = cgi.parse_header(self.headers.get("Content-Type"))
        if ctype != "application/json":
            self.send_response(400)
            self.end_headers()
            return

        raw = self.rfile.read(
            int(self.headers.get("Content-Length")),
        ).decode("utf-8")
        data = json.loads(raw)

        result = json.dumps(
            {
                "text": render(
                    data.get("text", "Figlet"),
                    font=data.get("font", "slant"),
                    justify=data.get("justify", "auto"),
                    width=data.get("width", 80),
                ),
            }
        ).encode("utf-8")

        self.send_response(200)
        self.send_header("Content-type", "text/plain; charset=utf-8")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()

        self.wfile.write(result)
