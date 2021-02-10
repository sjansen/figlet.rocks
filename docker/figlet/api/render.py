from flask import jsonify, request, Response
from flask.views import MethodView
from pyfiglet import Figlet


def render(text, font="standard", direction="auto", justify="auto", width=80):
    f = Figlet(font=font, direction=direction, justify=justify, width=width)
    return f.renderText(text)


class RenderAPI(MethodView):
    def options(self):
        resp = Response()
        resp.headers["Access-Control-Allow-Headers"] = "*"
        resp.headers["Access-Control-Allow-Methods"] = "POST"
        resp.headers["Access-Control-Allow-Origin"] = "*"
        resp.headers["Access-Control-Max-Age"] = "3600"
        resp.headers["Cache-Control"] = "max-age=3600"
        return resp

    def post(self):
        if not request.is_json:
            return "invalid", 400
        data = request.json
        resp = jsonify(
            {
                "text": render(
                    data.get("text", "Figlet"),
                    font=data.get("font"),
                    direction=data.get("direction"),
                    justify=data.get("justify"),
                    width=data.get("width"),
                ),
            }
        )
        resp.headers["Access-Control-Allow-Origin"] = "*"
        resp.headers["Access-Control-Max-Age"] = "3600"
        return resp
