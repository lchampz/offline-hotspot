# Emergency Network (Offline Hotspot)

A communication server that works **without internet**: a self-contained
Wi-Fi access point that anyone nearby can join to exchange messages, see
community notices, and access saved manuals/documents — all running
locally on a Raspberry Pi.

Built with [Elixir](https://elixir-lang.org/), [Phoenix](https://www.phoenixframework.org/)
and [Nerves](https://nerves-project.org/).

## Why this project exists

This project exists because of the ongoing siege of Gaza, where Israel
has repeatedly cut electricity, internet, and phone networks for entire
populations — leaving people unable to call for help, reach their
families, or receive warnings, sometimes for weeks at a time. Human
Rights Watch, Amnesty International, and the Israeli human rights
organization B'Tselem have each published extensive documentation
concluding that Israel's system of control over Palestinians — including
in Gaza and the occupied West Bank — meets the legal definition of
apartheid.

Free, offline, easily replicable communication tools are one small,
concrete thing engineers can build in response to infrastructure being
deliberately taken away from civilians. This project is dedicated to the
Palestinian people. Free Palestine. 🇵🇸

## Features

- **Notice Board** (`/notices`) — community notices, help requests, and
  health notices, organized by category.
- **Local Network Chat** (`/chat`) — real-time chat between anyone
  connected to the same Wi-Fi.
- **Documents** (`/documents`) — first-aid manuals, local maps, and
  other PDFs, available offline (just drop the file in the folder, no
  code changes needed).
- **Network Status** (`/network`) — SSID, IP, and clients connected to the
  access point.
- **Captive portal** — any phone that joins the Wi-Fi gets automatically
  redirected to the home page, just like an airport/hotel network —
  except there's no internet at all behind it.

Everything works 100% offline: assets (CSS/JS) are served locally, with
no CDN dependency whatsoever.

## Repository layout

```
emergency_server/   Phoenix app (web interface, SQLite database)
firmware/            Nerves project — packages the app above as
                     firmware to run directly on a Raspberry Pi
```

## How to run it

### 1. Just the web app (fastest way to work on the interface)

Requires [Elixir](https://elixir-lang.org/install.html) installed.

```bash
cd emergency_server
mix setup      # installs dependencies and sets up the database (first time only)
mix phx.server
```

Visit [`http://localhost:4000`](http://localhost:4000).

### 2. "Simulated Raspberry Pi" (Nerves host mode)

Boots the exact same code that runs on the real hardware — supervisor,
captive-portal DNS resolver, everything — just compiled natively for
your own computer, no Pi or SD card required:

```bash
cd firmware
export MIX_TARGET=host
mix deps.get   # first time only
mix run --no-halt
```

Visit [`http://localhost:4000`](http://localhost:4000) as usual, and
[`http://localhost:4000/network`](http://localhost:4000/network) to see the
simulated access point status.

### 3. Flashing a real Raspberry Pi

Requires a public SSH key in `~/.ssh/` (Nerves uses it to grant remote
access to the device) and a Raspberry Pi Zero 2 W or 3A+ (target
`rpi3a`) or Zero W (target `rpi0`).

```bash
cd firmware
export MIX_TARGET=rpi3a   # or rpi0
mix deps.get
mix firmware
mix burn      # writes to a microSD card
```

Insert the card into the Raspberry Pi, power it from a power bank, and
join the `LOCAL-EMERGENCY-NETWORK` Wi-Fi network.

## Roadmap

- [x] Offline-first web app (notice board, chat, documents)
- [x] Captive portal (HTTP catch-all + wildcard DNS resolver)
- [x] Nerves project running in host mode (simulated)
- [ ] Tested on real Raspberry Pi hardware, with a phone actually joining
- [ ] Expansion into a mesh network over LoRa radio (long range, no Wi-Fi)

## Technologies

Elixir · Phoenix LiveView · SQLite (`ecto_sqlite3`) · Nerves · VintageNet

## License

MIT — see [LICENSE](LICENSE).
