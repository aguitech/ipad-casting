import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var webView: WKWebView!

    // URL principal del WebView
    static let HOME_URL = "https://tupeliculafinanciera.com/casting/"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Configurar window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black

        // Crear WKWebView con configuración optimizada
        let configuration = WKWebViewConfiguration()

        // Permitir cámara y micrófono en el WebView
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences

        // Habilitar media (cámara, micrófono) sin pedir permiso user gesture
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        // Permitir AirPlay
        configuration.allowsAirPlayForMediaPlayback = true

        // Preferencias para fullscreen
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true

        // User controller (para manejo de permisos)
        let userContentController = WKUserContentController()

        // Inyectar script que pre-aprueba permisos de cámara/mic automáticamente
        // para tupeliculafinanciera.com cuando el WebView lo pida
        let autoApproveScript = """
        (function() {
            const originalGetUserMedia = navigator.mediaDevices.getUserMedia.bind(navigator.mediaDevices);
            navigator.mediaDevices.getUserMedia = function(constraints) {
                console.log('🎥 Solicitando acceso a:', JSON.stringify(Object.keys(constraints)));
                return originalGetUserMedia(constraints).catch(err => {
                    console.warn('⚠️ getUserMedia error:', err.name);
                    throw err;
                });
            };

            // Override de permisos para que pregunte una vez
            if (navigator.permissions && navigator.permissions.query) {
                const origQuery = navigator.permissions.query.bind(navigator.permissions);
                navigator.permissions.query = function(desc) {
                    console.log('🔐 Permiso solicitado:', desc.name);
                    return origQuery(desc);
                };
            }

            // Listener para detectar requests de media
            document.addEventListener('DOMContentLoaded', () => {
                console.log('🌐 WebView DOM ready — tupeliculafinanciera.com');
            });
        })();
        """
        let userScript = WKUserScript(
            source: autoApproveScript,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        userContentController.addUserScript(userScript)

        configuration.userContentController = userContentController

        // Crear WebView
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.scrollView.bounces = true
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.allowsBackForwardNavigationGestures = true

        // Permitir zoom pero no para formularios
        webView.scrollView.minimumZoomScale = 0.5
        webView.scrollView.maximumZoomScale = 3.0

        // Habilitar inspección (debug)
        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif

        // Delegate para manejar eventos
        webView.navigationDelegate = self
        webView.uiDelegate = self

        // Layout
        let viewController = UIViewController()
        viewController.view = webView
        viewController.view.backgroundColor = .black

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        // Cargar URL inicial
        loadHome()

        return true
    }

    // MARK: - Cargar URL
    func loadHome() {
        guard let url = URL(string: AppDelegate.HOME_URL) else {
            print("❌ URL inválida: \(AppDelegate.HOME_URL)")
            return
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 30

        print("🌐 Cargando: \(url.absoluteString)")
        webView.load(request)
    }

    // MARK: - App lifecycle
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Recargar al volver del background (opcional)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Pausar videos cuando va a background
        webView.evaluateJavaScript("document.querySelectorAll('video').forEach(v => v.pause());", completionHandler: nil)
    }
}

// MARK: - WKNavigationDelegate
extension AppDelegate: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("🔄 Cargando...")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("✅ Cargado: \(webView.url?.absoluteString ?? "?")")
        // Setear título del webview al title de la página
        webView.evaluateJavaScript("document.title", completionHandler: { (result, error) in
            if let title = result as? String, !title.isEmpty {
                self.window?.rootViewController?.title = title
            }
        })
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("❌ Error: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        // Permitir todo
        decisionHandler(.allow)
    }
}

// MARK: - WKUIDelegate
extension AppDelegate: WKUIDelegate {

    // Permitir abrir ventanas externas (target="_blank")
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.targetFrame == nil {
            // Abrir en el mismo webview
            webView.load(navigationAction.request)
        }
        return nil
    }

    // Manejar alerts de JS
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        })
        window?.rootViewController?.present(alert, animated: true)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
                initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            completionHandler(false)
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler(true)
        })
        window?.rootViewController?.present(alert, animated: true)
    }
}