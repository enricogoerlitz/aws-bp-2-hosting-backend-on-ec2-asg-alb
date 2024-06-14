from flask import Flask, jsonify
import socket


app = Flask(__name__)


@app.route('/')
def healthcheck():
    host_ip = socket.gethostbyname(socket.gethostname())
    return jsonify({
        "healthcheck": "ok",
        "host": host_ip
    })


@app.route('/host')
def host_ip():
    host_ip = socket.gethostbyname(socket.gethostname())
    return jsonify({"host_ip": host_ip})


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
