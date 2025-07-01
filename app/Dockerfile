FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt main.py ./

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

ENV NAME=World
ENV PORT=8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "main:app"]
