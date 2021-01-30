ARG AWSLAMBDARIC_VERSION="1.0.0"
ARG BASE_IMAGE="python:3.9.1-alpine3.12"

FROM ${BASE_IMAGE} AS base-image
RUN apk add --no-cache \
    libstdc++

# =====================================

FROM base-image AS builder
RUN mkdir -p /function \
 && apk add --no-cache \
    autoconf \
    automake \
    build-base \
    cmake \
    libcurl \
    libexecinfo-dev \
    libtool
ARG AWSLAMBDARIC_VERSION
RUN pip install \
    awslambdaric==${AWSLAMBDARIC_VERSION} \
    --target /function/
COPY requirements.txt /tmp/
RUN pip install \
    -r /tmp/requirements.txt \
    --target /function/
COPY .serverless-wsgi \
    wsgi.py \
    wsgi_handler.py \
    /function/
COPY api/ /function/api/

# =====================================

FROM base-image
COPY entrypoint /
COPY --from=builder /function /function
WORKDIR /function
ENTRYPOINT [ "/entrypoint" ]
CMD [ "wsgi_handler.handler" ]
