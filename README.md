<div align="center">

# 📖 LogBook — OPTCG Collection Manager

**[English](#english) | [Português](#português)**

---

A smart collection management tool for **One Piece Trading Card Game** collectors.  
Identify cards instantly via computer vision, manage your inventory, and track your wish list — all in one place.

> ⚠️ **MVP Notice:** This is a Minimum Viable Product. Some features are partially implemented (see [Known Limitations](#known-limitations)).

</div>

---

## 🖼️ Screenshots

> 📸 *Screenshots and demo GIFs coming soon.*

<!-- Suggested: Add a GIF of the scanner in action here -->
<!-- ![Scanner Demo](assets/demo-scanner.gif) -->

---

## ✨ Features

- **🔍 Smart Scanner** — Real-time card identification via camera using computer vision (ORB algorithm)
- **🔎 Manual Search** — Look up cards by their unique code (`OPXX-XXX`) as a fallback
- **📦 Collection Manager** — Add cards to your personal inventory with quantity tracking
- **⭐ Want List** — Monitor desired cards with visual price-drop highlights
- **💰 Market Prices** — Integrated price display (min / mid / max) per card
- **☁️ Cloud Sync** — All data (collection, wish list, recently viewed) synced in real time via Firebase

---

## 🏗️ Architecture

LogBook uses a **hybrid architecture** connecting a Flutter mobile client with a Python image-processing engine and a Firebase backend.

```
logbook-optcg/
├── backend/
│   └── functions/          # Firebase Cloud Functions (Node.js)
├── scraper_script/         # Python scripts for card data ingestion
│   ├── update_cards.py     # Scrapes Bandai's official site & populates Firestore
│   └── atualizar_precos.py # Updates card prices in Firestore
└── flutter_app/            # Mobile app (Flutter)
    └── lib/
        ├── core/           # Constants, router, services, theme, utils
        ├── features/       # Feature-first modules
        │   ├── auth/
        │   ├── card_detail/
        │   ├── collection/
        │   ├── home/
        │   ├── scanner/
        │   ├── search/
        │   ├── settings/
        │   └── want_list/
        ├── models/
        └── widgets/
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Mobile Frontend** | Flutter · Riverpod · go_router |
| **Computer Vision** | Python · OpenCV · ORB Algorithm |
| **API Server** | Python · Flask |
| **Database** | Firebase Cloud Firestore (NoSQL) |
| **Authentication** | Firebase Auth |
| **Cloud Functions** | Node.js (Firebase Functions) |
| **Data Ingestion** | Python · BeautifulSoup4 · Requests |
| **Connectivity** | ADB Reverse (USB tunneling for local dev) |

---

## ⚙️ Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x+)
- [Python](https://www.python.org/) (3.9+)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- A Firebase project with Firestore and Authentication enabled
- Android device or emulator

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/logbook-optcg.git
cd logbook-optcg
```

### 2. Configure Firebase

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Download your `google-services.json` and place it in `flutter_app/android/app/`
3. For the scraper scripts, generate a `serviceAccountKey.json` from **Project Settings → Service Accounts** and place it in `scraper_script/`

> 🔒 **Never commit `serviceAccountKey.json` or `google-services.json` to version control.** Both are listed in `.gitignore`.

### 3. Run the Flutter app

```bash
cd flutter_app
flutter pub get
flutter run
```

### 4. Run the Python scanner API

```bash
cd scanner_api
pip install -r requirements.txt
python app.py
```

### 5. Connect your device (local dev)

Since the Flask API runs locally, use ADB reverse to tunnel the port to your Android device:

```bash
adb reverse tcp:5000 tcp:5000
```

### 6. Populate the card database (optional)

```bash
cd scraper_script
pip install -r requirements.txt
python update_cards.py
```

---

## ⚠️ Known Limitations

This is an MVP. The following features are partially implemented or pending:

- **Scanner accuracy** — The ORB-based scanner was validated with a single card under controlled lighting. Performance may vary with different angles, lighting conditions, or card conditions.
- **Liga One Piece integration** — Integration with [Liga One Piece](https://www.ligaonepiece.com.br) — the leading TCG marketplace ecosystem in Brazil — is not yet implemented. This would bring real market prices, direct purchase links, auction participation, and more.
- **Prices** — Current prices are placeholder values generated for development purposes, since real pricing depends on the Liga One Piece integration.
- **Card database coverage** — The scraper currently targets a single set series from Bandai's official site.

---

## 🗺️ Roadmap

- [ ] Improve scanner accuracy with a larger reference dataset
- [ ] Integrate with [Liga One Piece](https://www.ligaonepiece.com.br) — real market prices, buy/sell links, and auction support
- [ ] Replace placeholder prices with real-time market data from Liga One Piece
- [ ] Add deck builder feature
- [ ] iOS support

---

## 📄 License

This project is for **portfolio and educational purposes**. One Piece TCG card images and data belong to © Bandai.

---
---

<a name="português"></a>

<div align="center">

# 📖 LogBook — Gerenciador de Coleção OPTCG

Uma ferramenta inteligente para colecionadores do **One Piece Card Game**.  
Identifique cartas instantaneamente por visão computacional, gerencie seu inventário e acompanhe sua lista de desejos — tudo em um só lugar.

> ⚠️ **Aviso MVP:** Este é um Produto Mínimo Viável. Algumas funcionalidades estão parcialmente implementadas (veja [Limitações Conhecidas](#limitações-conhecidas)).

</div>

---

## 🖼️ Screenshots

> 📸 *Screenshots e GIFs de demonstração em breve.*

---

## ✨ Funcionalidades

- **🔍 Scanner Inteligente** — Identificação de cartas em tempo real via câmera usando visão computacional (algoritmo ORB)
- **🔎 Busca Manual** — Pesquisa de cartas pelo código único (`OPXX-XXX`) como alternativa ao scanner
- **📦 Gerenciador de Coleção** — Adicione cartas ao seu inventário pessoal com controle de quantidades
- **⭐ Lista de Desejos** — Monitore cartas de interesse com destaque visual para queda de preço
- **💰 Preços de Mercado** — Exibição de preços integrada (mín / médio / máx) por carta
- **☁️ Sincronização em Nuvem** — Todos os dados (coleção, wishlist e recentes) sincronizados em tempo real via Firebase

---

## 🏗️ Arquitetura

O LogBook utiliza uma **arquitetura híbrida** que conecta um cliente mobile Flutter com um motor de processamento de imagem em Python e um backend Firebase.

```
logbook-optcg/
├── backend/
│   └── functions/          # Firebase Cloud Functions (Node.js)
├── scraper_script/         # Scripts Python para ingestão de dados de cartas
│   ├── update_cards.py     # Scraping do site oficial Bandai + população do Firestore
│   └── atualizar_precos.py # Atualização de preços no Firestore
└── flutter_app/            # App mobile (Flutter)
    └── lib/
        ├── core/           # Constants, router, services, theme, utils
        ├── features/       # Módulos por funcionalidade
        │   ├── auth/
        │   ├── card_detail/
        │   ├── collection/
        │   ├── home/
        │   ├── scanner/
        │   ├── search/
        │   ├── settings/
        │   └── want_list/
        ├── models/
        └── widgets/
```

---

## 🛠️ Stack de Tecnologias

| Camada | Tecnologia |
|---|---|
| **Frontend Mobile** | Flutter · Riverpod · go_router |
| **Visão Computacional** | Python · OpenCV · Algoritmo ORB |
| **Servidor de API** | Python · Flask |
| **Banco de Dados** | Firebase Cloud Firestore (NoSQL) |
| **Autenticação** | Firebase Auth |
| **Cloud Functions** | Node.js (Firebase Functions) |
| **Ingestão de Dados** | Python · BeautifulSoup4 · Requests |
| **Conectividade** | ADB Reverse (tunelamento USB para dev local) |

---

## ⚙️ Como Executar

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x+)
- [Python](https://www.python.org/) (3.9+)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- Projeto Firebase com Firestore e Authentication habilitados
- Dispositivo Android ou emulador

### 1. Clone o repositório

```bash
git clone https://github.com/SEU_USUARIO/logbook-optcg.git
cd logbook-optcg
```

### 2. Configure o Firebase

1. Crie um projeto no [console.firebase.google.com](https://console.firebase.google.com)
2. Baixe o `google-services.json` e coloque em `flutter_app/android/app/`
3. Para os scripts Python, gere uma `serviceAccountKey.json` em **Configurações do Projeto → Contas de Serviço** e coloque em `scraper_script/`

> 🔒 **Nunca suba `serviceAccountKey.json` ou `google-services.json` para o controle de versão.** Ambos estão no `.gitignore`.

### 3. Execute o app Flutter

```bash
cd flutter_app
flutter pub get
flutter run
```

### 4. Execute a API Python do scanner

```bash
cd scanner_api
pip install -r requirements.txt
python app.py
```

### 5. Conecte seu dispositivo (dev local)

Como a API Flask roda localmente, use o ADB reverse para tunelar a porta até seu dispositivo Android:

```bash
adb reverse tcp:5000 tcp:5000
```

### 6. Popule o banco de cartas (opcional)

```bash
cd scraper_script
pip install -r requirements.txt
python update_cards.py
```

---

## ⚠️ Limitações Conhecidas

Este é um MVP. As seguintes funcionalidades estão parcialmente implementadas ou pendentes:

- **Precisão do scanner** — O scanner baseado em ORB foi validado com uma única carta em condições controladas de iluminação. A performance pode variar com diferentes ângulos, iluminação ou estado das cartas.
- **Integração com a Liga One Piece** — A integração com a [Liga One Piece](https://www.ligaonepiece.com.br) — principal ecossistema de mercado de TCG no Brasil — ainda não foi implementada. Ela traria preços reais de mercado, links diretos para compra de cartas, participação em leilões e outras funcionalidades do ecossistema (Liga Pokémon, Riftbound, entre outros).
- **Preços** — Os preços atuais são valores fictícios gerados para fins de desenvolvimento, já que a precificação real depende da integração com a Liga One Piece.
- **Cobertura do banco de cartas** — O scraper atualmente cobre apenas uma série de sets do site oficial da Bandai.

---

## 🗺️ Roadmap

- [ ] Melhorar precisão do scanner com base de referência maior
- [ ] Integrar com a [Liga One Piece](https://www.ligaonepiece.com.br) — preços reais de mercado, links de compra/venda e suporte a leilões
- [ ] Substituir preços fictícios por dados reais de mercado via Liga One Piece
- [ ] Adicionar funcionalidade de deck builder
- [ ] Suporte a iOS

---

## 📄 Licença

Este projeto tem fins de **portfólio e aprendizado**. As imagens e dados das cartas de One Piece TCG pertencem à © Bandai.
