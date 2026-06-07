from flask import Flask, request, jsonify
import cv2
import numpy as np

app = Flask(__name__)

# Carrega a oficial e o ORB já na inicialização pra ficar rápido
img_oficial = cv2.imread(r'F:\LogBook\backend\functions\src\scanner\oficial.png', cv2.IMREAD_GRAYSCALE)
orb = cv2.ORB_create(nfeatures=2000)
kp1, des1 = orb.detectAndCompute(img_oficial, None)

@app.route('/scan', methods=['POST'])
def scan_card():
    # Recebe a imagem da câmera que vai vir do Flutter
    file = request.files.get('image')
    if not file:
        return jsonify({"erro": "Nenhuma imagem enviada"}), 400

    npimg = np.frombuffer(file.read(), np.uint8)
    img_camera = cv2.imdecode(npimg, cv2.IMREAD_GRAYSCALE)

    kp2, des2 = orb.detectAndCompute(img_camera, None)

    bf = cv2.BFMatcher(cv2.NORM_HAMMING)
    matches = bf.knnMatch(des1, des2, k=2)

    boas_matches = []
    for m, n in matches:
        if m.distance < 0.75 * n.distance:
            boas_matches.append(m)

    # Se achar um número bom de pontos em comum, confirma a carta
    if len(boas_matches) > 15:
        return jsonify({
            "status": "sucesso", 
            "cardId": "OP15-092", 
            "matches": len(boas_matches)
        })
    else:
        return jsonify({
            "status": "falha", 
            "mensagem": "Carta não reconhecida"
        })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)