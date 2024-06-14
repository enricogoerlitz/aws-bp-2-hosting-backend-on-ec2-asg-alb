FROM python:3.12

WORKDIR /app

COPY /app/requirements.txt /app/requirements.txt
COPY /app/app.py /app/app.py
COPY /docker /docker

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

ENV FLASK_APP=app.py

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
