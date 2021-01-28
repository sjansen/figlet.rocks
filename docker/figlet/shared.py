from pyfiglet import Figlet


def render(text, font="slant", justify="auto", width=80):
    f = Figlet(font=font, justify=justify, width=width)
    return f.renderText(text)
