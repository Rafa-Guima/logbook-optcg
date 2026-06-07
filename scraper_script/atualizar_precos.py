import firebase_admin
from firebase_admin import credentials, firestore
import random

# Conexão com o Firebase
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

def atualizar_apenas_precos():
    print("Buscando cartas no banco de dados...")
    cartas_ref = db.collection('cards')
    docs = cartas_ref.stream()
    
    contador = 0
    for doc in docs:
        # Gera valores fictícios e lógicos (Min < Mid < Max)
        preco_min = round(random.uniform(1.5, 25.0), 2)
        preco_mid = round(preco_min + random.uniform(5.0, 40.0), 2)
        preco_max = round(preco_mid + random.uniform(15.0, 100.0), 2)
        
        # O comando .update() garante que só os preços serão alterados. 
        # Nomes, imagens e raridades ficam intactos!
        cartas_ref.document(doc.id).update({
            'priceMin': preco_min,
            'priceMid': preco_mid,
            'priceMax': preco_max
        })
        
        contador += 1
        print(f"Atualizado: {doc.id} -> Min: R${preco_min} | Med: R${preco_mid} | Max: R${preco_max}")

    print(f"\nSucesso! {contador} cartas receberam novos preços fictícios.")

if __name__ == "__main__":
    atualizar_apenas_precos()