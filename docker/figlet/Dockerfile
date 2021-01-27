ARG FUNCTION_DIR="/function"

FROM python:3.9.1-alpine3.12 as builder
ARG FUNCTION_DIR
RUN mkdir -p ${FUNCTION_DIR}
COPY requirements.txt ${FUNCTION_DIR}/
WORKDIR ${FUNCTION_DIR}
RUN pip install -r requirements.txt --target ${FUNCTION_DIR} \
 && rm requirements.txt
COPY entrypoint *.py ${FUNCTION_DIR}/

# =====================================

FROM python:3.9.1-alpine3.12
ARG FUNCTION_DIR
COPY --from=builder ${FUNCTION_DIR} ${FUNCTION_DIR}
WORKDIR ${FUNCTION_DIR}
ENTRYPOINT [ "./entrypoint" ]
CMD [ "app.handler" ]
