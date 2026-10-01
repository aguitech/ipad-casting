<p align="center">
  <img src="https://aguitech.com/images/logo.png" alt="AGUITECH" width="120">
</p>

<h1 align="center">ipad-casting</h1>

<p align="center">
  <strong>iPad casting · mirror & remote player UI para tablets.</strong><br>
  Interfaz web que convierte un iPad en un control remoto / espejo para
  un canvas, video o demo en vivo, sin instalar nada.
</p>

<p align="center">
  <a href="#que-es">Qué es</a> ·
  <a href="#stack">Stack</a> ·
  <a href="#estructura">Estructura</a> ·
  <a href="#run">Cómo correrlo</a> ·
  <a href="#deploy">Deploy</a> ·
  <a href="#license">Licencia</a>
</p>

---

## ¿Qué es

`ipad-casting` es una **UI web responsive** pensada para correr en un iPad
(pero funciona en cualquier tablet / teléfono / pantalla touch) que sirve para:

| Modo | Descripción |
|------|-------------|
| 🪞 **Mirror** | Refleja en el iPad lo que está pasando en otro canvas/pantalla (un mapa, una timeline, un demo en vivo). |
| 🎮 **Remote** | El iPad funciona como control remoto (joystick, botones, slider) para manejar la pantalla principal. |
| 🎬 **Player** | Modo reproductor con barra de progreso, play/pause y selector de clips. |
| 📡 **Cast** | Discovery del host vía código corto de 4 caracteres, sin cuentas ni auth.

**Casos de uso reales:**

- Demo de un producto en una pantalla grande → el presentador controla desde el iPad.
- Briefing creativo → cliente revisa videos / mockups desde su tablet sin instalar app.
- Estación de grabación → operador ve el encuadre del director en un iPad secundario.
- Sales en piso de tienda → el vendedor controla la pantalla del cliente con un iPad mini.

## Stack

- **HTML + CSS + JavaScript vanilla** — sin build, sin npm, sin frameworks.
- **CSS Grid + Flexbox** — layout responsive que se adapta del iPad al celular.
- **Touch events + WebSockets / `postMessage`** — comunicación en tiempo real.
- **PWA-ready** — se puede "Agregar a pantalla de inicio" en el iPad.
- **GitHub Pages** — hosting público gratis con HTTPS.

## Estructura

```
ipad-casting/
├── index.html              # landing del repo (preview rápido)
├── docs/                   # documentación extendida
│   ├── PROTOCOL.md        # mensajes entre control ↔ pantalla
│   └── MODES.md           # detalle de cada modo (mirror, remote, player, cast)
├── assets/
│   ├── styles.css         # hoja de estilos compartida
│   └── js/
│       ├── client.js      # lógica del lado del iPad
│       └── host.js        # lógica del lado de la pantalla
├── pages/                 # pantallas individuales (futuro)
└── README.md
```

## Run

Cualquier opción sirve. Sin dependencias.

```bash
# Opción 1 — abrir directo en el navegador
open index.html          # macOS
xdg-open index.html      # Linux

# Opción 2 — servidor local (recomendado para probar en LAN)
python3 -m http.server 8080
# luego visita http://localhost:8080 desde tu iPad en la misma WiFi
```

Para probar en un iPad físico apuntando a esta misma máquina:

```bash
# Encuentra tu IP local
ifconfig | grep "inet " | grep -v 127.0.0.1
# ejemplo: 192.168.1.42

# Comparte el folder y abre en el iPad
python3 -m http.server 8080 --bind 0.0.0.0
# luego en el iPad: http://192.168.1.42:8080
```

## Deploy

El repo se sirve con **GitHub Pages** en la rama `main`.

- **Producción:** https://aguitech.github.io/ipad-casting/

Para actualizar después de un cambio:

```bash
git add -A
git commit -m "feat: <descripción>"
git push origin main
# Pages se actualiza automáticamente en 30-90s
```

## Identidad visual

| Token | valor |
|-------|--------|
| Azul AGUITECH | `#0066ff` |
| Cyan acento | `#00d4ff` |
| Fondo oscuro | `#0a0e1a` |
| Tipografía | Inter (Google Fonts) |
| Layout | responsive iPad-first (768px → 1024px → 1366px) |

## License

MIT — úsalo, modifícalo, repártelo. Si te late, menciónanos.

---

<p align="center">
  Hecho con 🇨 por <a href="https://aguitech.com"><strong>AGUITECH</strong></a> ·
  Ingeniería + Diseño + Sistemas
</p>