from flask import jsonify, request, Response
from flask.views import MethodView
from pyfiglet import Figlet


def render(
    text,
    direction="auto",
    flip=False,
    font="standard",
    justify="auto",
    reverse=False,
    width=80,
):
    f = Figlet(font=font, direction=direction, justify=justify, width=width)
    r = f.renderText(text)
    if flip:
        r = r.flip()
    if reverse:
        r = r.reverse()
    return r


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
        text = "\n".join(
            render(
                text,
                direction=data.get("direction"),
                flip=data.get("flip"),
                font=data.get("font"),
                justify=data.get("justify"),
                reverse=data.get("reverse"),
                width=data.get("width"),
            )
            for text in
            data.get("text", "FIGlet").splitlines()
        )
        resp = jsonify({
            "text": text,
        })
        resp.headers["Access-Control-Allow-Origin"] = "*"
        resp.headers["Access-Control-Max-Age"] = "3600"
        return resp
