# Rede de Emergência (Offline Hotspot)

Servidor de comunicação que funciona **sem internet**: um ponto de acesso
Wi-Fi próprio que qualquer pessoa por perto pode entrar e usar para trocar
mensagens, ver avisos da comunidade e acessar manuais/documentos salvos —
tudo rodando localmente num Raspberry Pi.

Feito em [Elixir](https://elixir-lang.org/), [Phoenix](https://www.phoenixframework.org/)
e [Nerves](https://nerves-project.org/).

Este projeto nasce da urgência de comunidades que enfrentam blackouts de
internet e infraestrutura de telecomunicação destruída — como o povo
palestino tem enfrentado em Gaza. A ideia é ter uma ferramenta simples,
livre e replicável para manter uma comunicação mínima (avisos, pedidos de
ajuda, chat local) quando a rede cai. #Palestine 🇵🇸

## Funcionalidades

- **Quadro de Avisos** (`/avisos`) — recados, pedidos de ajuda e avisos
  sanitários da comunidade, com categorias.
- **Chat da Rede Local** (`/chat`) — sala de bate-papo em tempo real entre
  quem estiver conectado no mesmo Wi-Fi.
- **Documentos** (`/documentos`) — manuais de primeiros socorros, mapas
  locais e outros PDFs, disponíveis offline (basta colocar o arquivo na
  pasta, sem precisar mexer em código).
- **Status da Rede** (`/rede`) — SSID, IP e clientes conectados ao ponto
  de acesso.
- **Captive portal** — qualquer celular que conectar no Wi-Fi é
  redirecionado automaticamente para a página inicial, como em redes de
  aeroporto/hotel — só que sem internet nenhuma por trás.

Tudo funciona 100% offline: os assets (CSS/JS) são servidos localmente,
sem nenhuma dependência de CDN.

## Estrutura do repositório

```
servidor_emergencia/   App Phoenix (interface web, banco SQLite)
firmware/              Projeto Nerves — empacota o app acima como
                       firmware para rodar direto no Raspberry Pi
```

## Como rodar

### 1. Só o app web (mais rápido para desenvolver a interface)

Requer [Elixir](https://elixir-lang.org/install.html) instalado.

```bash
cd servidor_emergencia
mix setup      # instala dependências e prepara o banco (só na 1ª vez)
mix phx.server
```

Acesse [`http://localhost:4000`](http://localhost:4000).

### 2. "Raspberry Pi simulado" (modo host do Nerves)

Sobe o mesmo código que roda no hardware de verdade — supervisor,
resolver de DNS do captive portal e tudo mais — só que compilado
nativamente para o seu computador, sem precisar de Pi nem cartão SD:

```bash
cd firmware
export MIX_TARGET=host
mix deps.get   # só na 1ª vez
mix run --no-halt
```

Acesse [`http://localhost:4000`](http://localhost:4000) normalmente, e
[`http://localhost:4000/rede`](http://localhost:4000/rede) para ver o
status simulado do ponto de acesso.

### 3. Gravando no Raspberry Pi de verdade

Requer uma chave SSH pública em `~/.ssh/` (o Nerves usa para liberar
acesso remoto ao dispositivo) e um Raspberry Pi Zero 2 W ou 3A+ (target
`rpi3a`) ou Zero W (target `rpi0`).

```bash
cd firmware
export MIX_TARGET=rpi3a   # ou rpi0
mix deps.get
mix firmware
mix burn      # grava num cartão microSD
```

Insira o cartão no Raspberry Pi, ligue numa powerbank e conecte no Wi-Fi
`REDE-DE-EMERGENCIA-LOCAL`.

## Roadmap

- [x] App web offline-first (avisos, chat, documentos)
- [x] Captive portal (catch-all HTTP + resolver DNS wildcard)
- [x] Projeto Nerves rodando em modo host (simulado)
- [ ] Testado em Raspberry Pi real, com celular conectando de fato
- [ ] Expansão para rede mesh via rádio LoRa (long range, sem Wi-Fi)

## Tecnologias

Elixir · Phoenix LiveView · SQLite (`ecto_sqlite3`) · Nerves · VintageNet
