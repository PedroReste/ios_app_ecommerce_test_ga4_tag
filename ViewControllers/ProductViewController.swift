import UIKit

// MARK: - ProductViewController (Tela B)
class ProductViewController: UIViewController {

    // MARK: - Properties
    private let product: Product
    private let index: Int
    private let listId: String
    private let listName: String
    private var quantity: Int = 1
    private var isWishlisted: Bool = false

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        iv.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.18, alpha: 1.0)
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let saleBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let variantLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.18, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(red: 1.0, green: 0.85, blue: 0.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 1.0)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Descrição"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.8, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Seletor de quantidade
    private let quantityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Quantidade"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let decreaseQtyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let quantityValueLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let increaseQtyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Botões de ação
    private let addToCartButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Adicionar ao Carrinho"
        config.image = UIImage(systemName: "cart.badge.plus")
        config.imagePadding = 8
        config.baseBackgroundColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var updated = attrs
            updated.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return updated
        }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let wishlistButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "heart")
        config.baseBackgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 0.15)
        config.baseForegroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        config.cornerStyle = .large
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let shareButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "square.and.arrow.up")
        config.baseBackgroundColor = UIColor(red: 0.3, green: 0.5, blue: 1.0, alpha: 0.15)
        config.baseForegroundColor = UIColor(red: 0.3, green: 0.5, blue: 1.0, alpha: 1.0)
        config.cornerStyle = .large
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init
    init(product: Product, index: Int, listId: String, listName: String) {
        self.product = product
        self.index = index
        self.listId = listId
        self.listName = listName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithProduct()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // ✅ screen_view
        AnalyticsManager.shared.logScreenView(
            screenName: "Product Detail",
            screenClass: "ProductViewController"
        )

        // ✅ view_item
        AnalyticsManager.shared.logViewItem(product: product)
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "Detalhes"
        view.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.13, alpha: 1.0)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Quantity stack
        let quantityStack = UIStackView(arrangedSubviews: [
            decreaseQtyButton, quantityValueLabel, increaseQtyButton
        ])
        quantityStack.axis = .horizontal
        quantityStack.spacing = 16
        quantityStack.alignment = .center
        quantityStack.translatesAutoresizingMaskIntoConstraints = false

        // Action buttons stack
        let actionStack = UIStackView(arrangedSubviews: [wishlistButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 12
        actionStack.distribution = .fillEqually
        actionStack.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        [
            productImageView, saleBadge, brandLabel, nameLabel,
            variantLabel, ratingContainerView, categoryLabel,
            priceLabel, originalPriceLabel, descriptionTitleLabel,
            descriptionLabel, quantityTitleLabel, quantityStack,
            addToCartButton, actionStack
        ].forEach { contentView.addSubview($0) }

        ratingContainerView.addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Product Image
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalToConstant: 220),

            // Sale Badge
            saleBadge.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 12),
            saleBadge.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -12),
            saleBadge.heightAnchor.constraint(equalToConstant: 24),
            saleBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),

            // Brand
            brandLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // Category badge
            categoryLabel.centerYAnchor.constraint(equalTo: brandLabel.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: brandLabel.trailingAnchor, constant: 10),
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),

            // Name
            nameLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Variant
            variantLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            variantLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // Rating
            ratingContainerView.topAnchor.constraint(equalTo: variantLabel.bottomAnchor, constant: 12),
            ratingContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingContainerView.heightAnchor.constraint(equalToConstant: 32),

            ratingLabel.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor, constant: 10),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor, constant: -10),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingContainerView.centerYAnchor),

            // Price
            priceLabel.topAnchor.constraint(equalTo: ratingContainerView.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // Original Price
            originalPriceLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            originalPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 12),

            // Description Title
            descriptionTitleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // Description
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Quantity Title
            quantityTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            quantityTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // Quantity Stack
            quantityStack.topAnchor.constraint(equalTo: quantityTitleLabel.bottomAnchor, constant: 12),
            quantityStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            decreaseQtyButton.widthAnchor.constraint(equalToConstant: 36),
            decreaseQtyButton.heightAnchor.constraint(equalToConstant: 36),
            increaseQtyButton.widthAnchor.constraint(equalToConstant: 36),
            increaseQtyButton.heightAnchor.constraint(equalToConstant: 36),
            quantityValueLabel.widthAnchor.constraint(equalToConstant: 32),

            // Add to Cart Button
            addToCartButton.topAnchor.constraint(equalTo: quantityStack.bottomAnchor, constant: 24),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 54),

            // Action Stack (Wishlist + Share)
            actionStack.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 12),
            actionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            actionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionStack.heightAnchor.constraint(equalToConstant: 48),
            actionStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])

        // Targets
        decreaseQtyButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        increaseQtyButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        wishlistButton.addTarget(self, action: #selector(wishlistTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }

    // MARK: - Configure with Product
    private func configureWithProduct() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .light)
        productImageView.image = UIImage(
            systemName: product.imageSystemName,
            withConfiguration: symbolConfig
        )

        brandLabel.text = product.brand
        nameLabel.text = product.name
        variantLabel.text = product.variant
        descriptionLabel.text = product.description
        ratingLabel.text = "⭐ \(product.rating) · \(product.reviewCount) avaliações"
        categoryLabel.text = " \(product.category) "

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")

        priceLabel.text = formatter.string(from: NSNumber(value: product.price))

        if product.isOnSale {
            let originalText = formatter.string(from: NSNumber(value: product.originalPrice)) ?? ""
            let attributed = NSAttributedString(
                string: originalText,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            originalPriceLabel.attributedText = attributed
            originalPriceLabel.isHidden = false
            saleBadge.text = " -\(Int(product.discount))% "
            saleBadge.isHidden = false
        } else {
            originalPriceLabel.isHidden = true
            saleBadge.isHidden = true
        }
    }

    // MARK: - Actions

    @objc private func decreaseQuantity() {
        guard quantity > 1 else { return }
        quantity -= 1
        quantityValueLabel.text = "\(quantity)"
    }

    @objc private func increaseQuantity() {
        guard quantity < 10 else { return }
        quantity += 1
        quantityValueLabel.text = "\(quantity)"
    }

    @objc private func addToCartTapped() {
        CartService.shared.addProduct(product, quantity: quantity)

        // ✅ add_to_cart
        AnalyticsManager.shared.logAddToCart(product: product, quantity: quantity)

        // Feedback visual
        var config = addToCartButton.configuration
        config?.title = "✅ Adicionado!"
        config?.baseBackgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0)
        addToCartButton.configuration = config

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            var resetConfig = self.addToCartButton.configuration
            resetConfig?.title = "Adicionar ao Carrinho"
            resetConfig?.baseBackgroundColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
            self.addToCartButton.configuration = resetConfig
        }
    }

    @objc private func wishlistTapped() {
        isWishlisted.toggle()

        // ✅ add_to_wishlist
        if isWishlisted {
            AnalyticsManager.shared.logAddToWishlist(product: product)
        }

        var config = wishlistButton.configuration
        config?.image = UIImage(systemName: isWishlisted ? "heart.fill" : "heart")
        config?.baseForegroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        wishlistButton.configuration = config

        // Feedback
        UIView.animate(withDuration: 0.15, animations: {
            self.wishlistButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.wishlistButton.transform = .identity
            }
        }
    }

    @objc private func shareTapped() {
        // ✅ share
        AnalyticsManager.shared.logShare(
            contentType: "product",
            itemId: product.id,
            method: "ios_share_sheet"
        )

        let text = "Confira: \(product.name) por R$ \(product.price) na TechStore!"
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }
}
