import os

from flask import Flask, jsonify


app = Flask(__name__)


@app.route("/")
def healthcheck():
    hostname = os.uname()[1]
    return jsonify({
        "healthcheck": "ok",
        "hostname": hostname,
        "version": "v2"
    })


@app.route("/host")
def host_ip():
    hostname = os.uname()[1]
    return jsonify({"hostname": hostname})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
