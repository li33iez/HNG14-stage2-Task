from flask import Flask, jsonify

appi = Flask(__name__)

@appi.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "api is running"
    })

@appi.route("/health", methods=["GET"])
def health():
    return jsonify({
        "message": "HEALTH"
    })

@appi.route("/me", methods=["GET"])
def me():
    return jsonify({
        "name": "Abolaji oluwaseyi olakunle",
        "email": "oluwaseyiabolaji111@gmail.com",
        "github": "https://github.com/li33iez" 
    })

if __name__ == "__main__":
    appi.run(host="0.0.0.0", port=5000)
