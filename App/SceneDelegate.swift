import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        // ✅ Root: NavigationController → HomeViewController
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.navigationBar.prefersLargeTitles = true

        // Estilo visual
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.22, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
