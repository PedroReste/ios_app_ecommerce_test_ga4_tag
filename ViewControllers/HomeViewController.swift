import UIKit

// MARK: - HomeViewController (Tela A)
class HomeViewController: UIViewController {

    // MARK: - Properties
    private let products = Product.mockProducts
    private let listId = "home_product_list"
    private let listName = "Home - Produtos em Destaque"

    // MARK: - UI Components

    // Search Bar
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar produtos..."
        sb.searchBarStyle = .minimal
        sb.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        sb.barTintColor = .clear
        sb.translatesAutoresizingMaskIntoConstraints = false
        if let tf = sb.value(forKey: "searchField") as? UITextField {
            tf.textColor = .white
            tf.attributedPlaceholder = NSAttributedString(
                string: "Buscar produtos...",
                attributes: [.foregroundColor: UIColor.gray]
            )
        }
        return sb
    }()

    // Banner Promoção
    private let promotionBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(
            red: 0.6, green: 0.1, blue: 0.8, alpha: 1.0
        )
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let promotionLabel: UILabel = {
        let label = UILabel()
        label.text = "🔥 SUPER SALE — Até 30% OFF em Eletrônicos!"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let promotionButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Ver Ofertas"
        config.baseBackgroundColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Collection View
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // Cart button
    private lazy var cartBarButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        button.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)

        cartBadgeLabel.isHidden = true
        button.addSubview(cartBadgeLabel)

        NSLayoutConstraint.activate([
            cartBadgeLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: -4),
            cartBadgeLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 4),
            cartBadgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            cartBadgeLabel.heightAnchor.constraint(equalToConstant: 18)
        ])

        button.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    private let cartBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        label.textAlignment = .center
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // ✅ screen_view
        AnalyticsManager.shared.logScreenView(
            screenName: "Home",
            screenClass: "HomeViewController"
        )

        // ✅ view_item_list
        AnalyticsManager.shared.logViewItemList(
            items: products,
            listId: listId,
            listName: listName
        )

        // ✅ view_promotion (banner)
        AnalyticsManager.shared.logViewPromotion(
            promotionId: "PROMO-SALE-30",
            promotionName: "Super Sale 30% OFF",
            creativeName: "banner_home_sale",
            creativeSlot: "home_top_banner",
            items: Array(products.prefix(3))
        )
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "🛍️ TechStore"
        view.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.13, alpha: 1.0)
        navigationItem.rightBarButtonItem = cartBarButton

        view.addSubview(searchBar)
        view.addSubview(promotionBannerView)
        promotionBannerView.addSubview(promotionLabel)
        promotionBannerView.addSubview(promotionButton)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            promotionBannerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            promotionBannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            promotionBannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            promotionLabel.topAnchor.constraint(equalTo: promotionBannerView.topAnchor, constant: 16),
            promotionLabel.leadingAnchor.constraint(equalTo: promotionBannerView.leadingAnchor, constant: 16),
            promotionLabel.trailingAnchor.constraint(equalTo: promotionBannerView.trailingAnchor, constant: -16),

            promotionButton.topAnchor.constraint(equalTo: promotionLabel.bottomAnchor, constant: 10),
            promotionButton.centerXAnchor.constraint(equalTo: promotionBannerView.centerXAnchor),
            promotionButton.bottomAnchor.constraint(equalTo: promotionBannerView.bottomAnchor, constant: -16),
            promotionButton.widthAnchor.constraint(equalToConstant: 120),
            promotionButton.heightAnchor.constraint(equalToConstant: 36),

            collectionView.topAnchor.constraint(equalTo: promotionBannerView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        promotionButton.addTarget(self, action: #selector(promotionTapped), for: .touchUpInside)
        searchBar.delegate = self
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartDidChange),
            name: CartService.cartDidChangeNotification,
            object: nil
        )
    }

    // MARK: - Actions
    @objc private func cartTapped() {
        // ✅ view_cart (ao abrir o carrinho)
        AnalyticsManager.shared.logViewCart(cartItems: CartService.shared.items)

        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }

    @objc private func promotionTapped() {
        // ✅ select_promotion
        AnalyticsManager.shared.logSelectPromotion(
            promotionId: "PROMO-SALE-30",
            promotionName: "Super Sale 30% OFF",
            creativeName: "banner_home_sale",
            creativeSlot: "home_top_banner",
            items: Array(products.prefix(3))
        )
        showAlert(title: "🔥 Super Sale!", message: "Aproveite até 30% OFF em produtos selecionados!")
    }

    @objc private func cartDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.updateCartBadge()
        }
    }

    private func updateCartBadge() {
        let count = CartService.shared.totalItems
        if count > 0 {
            cartBadgeLabel.text = "\(count)"
            cartBadgeLabel.isHidden = false
        } else {
            cartBadgeLabel.isHidden = true
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return products.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.reuseIdentifier,
            for: indexPath
        ) as? ProductCell else {
            return UICollectionViewCell()
        }

        let product = products[indexPath.item]
        cell.configure(with: product)

        // ✅ add_to_cart (via botão da célula)
        cell.onAddToCart = { [weak self] product in
            guard let self = self else { return }
            CartService.shared.addProduct(product)
            AnalyticsManager.shared.logAddToCart(product: product, quantity: 1)
            self.showAddedToCartFeedback(productName: product.name)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let product = products[indexPath.item]

        // ✅ select_item
        AnalyticsManager.shared.logSelectItem(
            product: product,
            index: indexPath.item,
            listId: listId,
            listName: listName
        )

        // ✅ view_item (antecipado ao navegar)
        AnalyticsManager.shared.logViewItem(product: product)

        let productVC = ProductViewController(
            product: product,
            index: indexPath.item,
            listId: listId,
            listName: listName
        )
        navigationController?.pushViewController(productVC, animated: true)
    }

    // ✅ view_item ao célula aparecer na tela
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        // Impressão individual de item (opcional — use com moderação)
        // AnalyticsManager.shared.logViewItem(product: products[indexPath.item])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.bounds.width - 12) / 2
        return CGSize(width: width, height: 320)
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let term = searchBar.text, !term.isEmpty else { return }

        // ✅ search
        AnalyticsManager.shared.logSearch(searchTerm: term)
        searchBar.resignFirstResponder()
        showAlert(title: "🔍 Busca", message: "Buscando por: \"\(term)\"")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
}

// MARK: - Feedback helpers
extension HomeViewController {

    private func showAddedToCartFeedback(productName: String) {
        let banner = UIView()
        banner.backgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0)
        banner.layer.cornerRadius = 12
        banner.alpha = 0
        banner.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "✅ \(productName) adicionado!"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        banner.addSubview(label)
        view.addSubview(banner)

        NSLayoutConstraint.activate([
            banner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            banner.heightAnchor.constraint(equalToConstant: 44),
            label.centerXAnchor.constraint(equalTo: banner.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: banner.centerYAnchor)
        ])

        UIView.animate(withDuration: 0.3, animations: {
            banner.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, animations: {
                banner.alpha = 0
            }) { _ in
                banner.removeFromSuperview()
            }
        }
    }
}
