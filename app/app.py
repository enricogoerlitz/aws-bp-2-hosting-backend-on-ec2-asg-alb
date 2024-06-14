from flask import Flask, jsonify
import socket


app = Flask(__name__)


@app.route('/')
def healthcheck():
    internal_ip = socket.gethostbyname(socket.gethostname())
    return jsonify({
        "healthcheck": "ok",
        "internal_ip": internal_ip
    })


@app.route('/host')
def host_ip():
    internal_ip = socket.gethostbyname(socket.gethostname())
    return jsonify({"internal_ip": internal_ip})


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
