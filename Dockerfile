
FROM python:3.10 as requirements-stage

WORKDIR /tmp

RUN pip install poetry

COPY ./pyproject.toml ./poetry.lock* /tmp/


RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.10

WORKDIR /code

COPY --from=requirements-stage /tmp/requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY . /code/

ENV PORT 4444

EXPOSE 4444
CMD ["sh", "-c", "uvicorn server.main:app", "--host", "0.0.0.0", "--port", "4444"]
RUN ps aux | grep uvicorn
RUN ps aux | grep fastapi
