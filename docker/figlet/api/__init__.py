import logging
import os

from aws_xray_sdk.core import patch_all
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.ext.flask.middleware import XRayMiddleware
from flask import Flask
from flask.logging import default_handler

from .render import RenderAPI


app = Flask(__name__)
app.logger.info("Loading...")

root = logging.getLogger()
root.addHandler(default_handler)

if os.getenv("AWS_LAMBDA_FUNCTION_NAME"):
    app.logger.info("Enabling AWS X-Ray...")
    patch_all()
    xray_recorder.configure(
        context_missing="LOG_ERROR",
        service="figlet-lambda",
    )
    XRayMiddleware(app, xray_recorder)
    app.logger.info("Enabled.")

app.add_url_rule("/api/figlet/", view_func=RenderAPI.as_view("render"))

app.logger.info("Loaded.")
