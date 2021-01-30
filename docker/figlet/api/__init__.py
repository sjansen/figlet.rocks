from flask import Flask

from .render import RenderAPI

app = Flask(__name__)
app.add_url_rule(
    '/api/figlet/',
    view_func=RenderAPI.as_view('render')
)
