import cgi
from http import server
import socketserver

from shared import render


def start():
    with socketserver.TCPServer(("", 8000), Handler) as httpd:
        httpd.serve_forever()


class Handler(server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/":
            self.send_response(404)
            self.end_headers()
            return

        self.send_response(200)
        self.send_header("Content-type", "text/html; charset=utf-8")
        self.end_headers()

        self.wfile.write(b"<html><head><title>Title goes here.</title></head>")
        self.wfile.write(
            b"""<body><form method="post" enctype="multipart/form-data">"""
        )
        self.wfile.write(b"""<textarea name="text" cols="80" rows="5"></textarea>""")
        self.wfile.write(b"""<br /><input type="submit">""")
        self.wfile.write(b"""</form></body>""")
        self.wfile.write(b"</html>")

    def do_POST(self):
        if self.path != "/":
            self.send_response(404)
            self.end_headers()
            return

        ctype, pdict = cgi.parse_header(self.headers.get("Content-Type"))
        if ctype != "multipart/form-data":
            self.send_response(400)
            self.end_headers()
            return

        self.send_response(200)
        self.send_header("Content-type", "text/plain; charset=utf-8")
        self.end_headers()

        pdict["boundary"] = bytes(pdict["boundary"], "utf-8")
        form = cgi.parse_multipart(self.rfile, pdict)
        text = form.get("text", "Figlet")[0]
        if not text:
            text = "Figlet"
        self.wfile.write(render(text).encode("utf-8"))
