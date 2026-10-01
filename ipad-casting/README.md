# iPad Casting — App iOS WebView

App nativa de iOS para iPad que abre el casting de **Tu Película Financiera** dentro de un `WKWebView` optimizado para experiencia mobile/desktop.

## 🌐 URL

```
https://tupeliculafinanciera.com/casting/
```

## 📱 Características

- ✅ **WKWebView nativo** (no UIWebView deprecated)
- ✅ Soporte para **iPad portrait + landscape**
- ✅ Soporte para **iPhone** también
- ✅ Cámara y micrófono habilitados (para que el casting grabe video)
- ✅ ATS configurado para `tupeliculafinanciera.com`
- ✅ Inspección Safari habilitada en DEBUG (`WKWebView.isInspectable`)
- ✅ Pausa videos al ir a background
- ✅ JavaScript habilitado
- ✅ Permite fullscreen para `<video>`
- ✅ AirPlay habilitado

## 🏗️ Estructura

```
ipad-casting/
├── Sources/
│   └── AppDelegate.swift          # Entry point + WKWebView
├── Resources/
│   ├── Info.plist                  # Permisos (cámara, mic, fotos)
│   └── LaunchScreen.storyboard    # Splash screen
├── Assets.xcassets/
│   ├── AppIcon.appiconset/
│   └── AccentColor.colorset/
├── project.pbxproj                # Xcode project
└── README.md
```

## 🚀 Cómo abrir en Xcode

```bash
open ipad-casting.xcodeproj
```

O directamente:

```bash
xed ipad-casting.xcodeproj
```

## ▶️ Compilar y correr

Desde Xcode: **Product → Run** (⌘R)

O con CLI:

```bash
xcodebuild -project ipad-casting.xcodeproj \
           -scheme ipad-casting \
           -destination 'platform=iOS Simulator,name=iPad Pro' \
           build
```

## 🔧 Personalización

Para cambiar la URL, edita `Sources/AppDelegate.swift`:

```swift
static let HOME_URL = "https://tupeliculafinanciera.com/casting/"
```

## 📦 Bundle ID

Por defecto: `com.aguitech.ipad-casting`

Para cambiarlo, editar en el target del proyecto en Xcode.

## 🎯 Privacidad (Info.plist)

La app declara los siguientes permisos:

| Permiso | Uso |
|---|---|
| `NSCameraUsageDescription` | Grabar videos del casting |
| `NSMicrophoneUsageDescription` | Audio del casting |
| `NSPhotoLibraryUsageDescription` | Seleccionar fotos |
| `NSPhotoLibraryAddUsageDescription` | Guardar fotos |

## 🔐 ATS (App Transport Security)

Permite HTTP/HTTPS para `tupeliculafinanciera.com` y subdominios.

## 🐛 Debug

En Safari Development → iPad/iPhone → aparece la app para inspeccionar el WebView. Requiere Xcode 16.4+ y iOS 16.4+.

## 📋 Requisitos

- iOS 15.0+ (deploy target)
- Xcode 26.5+
- Swift 6.3+

---

**Autor:** Héctor Aguilar ([@aguitech](https://github.com/aguitech))
**Repo:** https://github.com/aguitech/ipad-casting