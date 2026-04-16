import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // ✅ Inicializa Firebase
        FirebaseApp.configure()

        // ✅ Habilita debug analytics (apenas em debug)
        #if DEBUG
        // Adicione -FIRAnalyticsDebugEnabled nos scheme arguments
        // ou use o comando abaixo no terminal:
        // xcrun simctl spawn booted defaults write \
        // com.example.EcommerceTaggingApp /google/measurement/debug_mode 1
        print("🔥 Firebase configurado em modo DEBUG")
        #endif

        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
