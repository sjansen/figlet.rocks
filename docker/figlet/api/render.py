import re

from flask import jsonify, request, Response
from flask.views import MethodView
from pyfiglet import Figlet


prefix = re.compile("^( *\n)+")
suffix = re.compile("( *\n)+$")


def render(f, text, flip, reverse, vtrim):
    r = f.renderText(text)
    if flip:
        r = r.flip()
    if reverse:
        r = r.reverse()
    if vtrim:
        r = prefix.sub("", r)
        r = suffix.sub("", r)
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
        f = Figlet(
            direction=data.get("direction", "auto"),
            font=data.get("font", "standard"),
            justify=data.get("justify", "auto"),
            width=data.get("width", 80),
        )
        flip = data.get("flip", False)
        reverse = data.get("reverse", False)
        vtrim = data.get("vtrim", True)
        if vtrim:
            sep = "\n\n"
        else:
            sep = "\n"
        text = sep.join(
            render(
                f,
                text,
                flip=flip,
                reverse=reverse,
                vtrim=vtrim,
            )
            for text in data.get("text", "FIGlet").splitlines()
        )
        resp = jsonify(
            {
                "text": text,
            }
        )
        resp.headers["Access-Control-Allow-Origin"] = "*"
        resp.headers["Access-Control-Max-Age"] = "3600"
        return resp
