import requests
from bs4 import BeautifulSoup
import firebase_admin
from firebase_admin import credentials, firestore
import random

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

url = "https://en.onepiece-cardgame.com/cardlist/?series=569116"
headers = {'User-Agent': 'Mozilla/5.0'}

response = requests.get(url, headers=headers)
soup = BeautifulSoup(response.text, 'html.parser')

cartas_html = soup.find_all('dl')

for carta in cartas_html:
    nome_elem = carta.find('div', class_='cardName')
    if not nome_elem:
        continue
        
    nome = nome_elem.text.strip()
    
    img_tag = carta.find('img')
    img_src = img_tag['src'] if img_tag else ""
    if img_src and img_src.startswith(".."):
        img_src = img_src.replace('..', 'https://en.onepiece-cardgame.com')
        
    info_col = carta.find('div', class_='infoCol')
    card_number = "Desconhecido"
    rarity = "C"
    
    if info_col:
        spans = info_col.find_all('span')
        if len(spans) >= 2:
            card_number = spans[0].text.strip()
            rarity = spans[1].text.strip()
        elif len(spans) == 1:
            card_number = spans[0].text.strip()
            
    if card_number == "Desconhecido" and "OP" in img_src:
        card_number = img_src.split('/')[-1].split('.')[0].split('?')[0]

    color_elem = carta.find('div', class_='color')
    color_text = color_elem.text.strip() if color_elem else "Red"
    
    set_card = card_number.split('-')[0] if '-' in card_number else "OP"

    preco_min = round(random.uniform(0.5, 20.0), 2)
    preco_mid = round(preco_min + random.uniform(5.0, 30.0), 2)
    preco_max = round(preco_mid + random.uniform(10.0, 80.0), 2)

    db.collection('cards').document(card_number).set({
        'cardId': card_number,
        'name': nome,
        'set': set_card,
        'color': [color_text], 
        'rarity': rarity, 
        'cardNumber': card_number,
        'imageUrl': f"https://en.onepiece-cardgame.com/images/cardlist/card/{card_number}.png",
        'priceMin': preco_min,
        'priceMid': preco_mid,
        'priceMax': preco_max,
        'ligaUrl': "Site Oficial Bandai",
        'lastUpdated': firestore.SERVER_TIMESTAMP
    }, merge=True)
    
    print(f"Atualizado: {card_number} | {nome} | {rarity} | {color_text}")

print("MVP atualizado com sucesso!")