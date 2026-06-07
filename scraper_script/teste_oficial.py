import requests
from bs4 import BeautifulSoup

def testar_site_oficial():
    url = "https://en.onepiece-cardgame.com/cardlist/?series=569116"
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }
    
    print("Acessando o site oficial da Bandai...")
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        print("Sucesso! Passamos sem bloqueio (Status 200).")
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # O site oficial costuma colocar os nomes das cartas na classe 'cardName'
        cartas = soup.find_all('div', class_='cardName')
        
        if cartas:
            print(f"\nEncontramos {len(cartas)} cartas. Primeiras 5:")
            for carta in cartas[:5]:
                print(f"- {carta.text.strip()}")
        else:
            print("\nAcessei a página, mas precisamos inspecionar o HTML para pegar a classe certa do nome.")
    else:
        print(f"Deu erro: Status {response.status_code}")

if __name__ == "__main__":
    testar_site_oficial()