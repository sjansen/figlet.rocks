#!/usr/bin/env python3
from shared import render


def handler(event, context):
    return render("Lambda")


def main():
    import server

    server.start()


if __name__ == "__main__":
    main()
