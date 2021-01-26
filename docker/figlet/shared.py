from pyfiglet import Figlet


def render(text):
    f = Figlet(font="slant")
    return f.renderText(text)
