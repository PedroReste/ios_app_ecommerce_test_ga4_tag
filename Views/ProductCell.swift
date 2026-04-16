import UIKit

// MARK: - ProductCell
class ProductCell: UICollectionViewCell {

    static let reuseIdentifier = "ProductCell"

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.18, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        iv.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.24, alpha: 1.0)
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let saleBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = UIColor(red: 1.0, green: 0.85, blue: 0.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let addToCartButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Adicionar"
        config.image = UIImage(systemName: "cart.badge.plus")
        config.imagePadding = 6
        config.baseBackgroundColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var updated = attrs
            updated.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            return updated
        }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties
    var product: Product?
    var onAddToCart: ((Product) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(productImageView)
        containerView.addSubview(saleBadge)
        containerView.addSubview(nameLabel)
        containerView.addSubview(brandLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(originalPriceLabel)
        containerView.addSubview(ratingLabel)
        containerView.addSubview(addToCartButton)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            productImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            productImageView.heightAnchor.constraint(equalToConstant: 100),

            saleBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            saleBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            saleBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            saleBadge.heightAnchor.constraint(equalToConstant: 18),

            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            brandLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            brandLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            brandLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            ratingLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),

            priceLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            originalPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            originalPriceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),

            addToCartButton.topAnchor.constraint(equalTo: originalPriceLabel.bottomAnchor, constant: 10),
            addToCartButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            addToCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            addToCartButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            addToCartButton.heightAnchor.constraint(equalToConstant: 36)
        ])

        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
    }

    // MARK: - Configure
    func configure(with product: Product) {
        self.product = product

        // Imagem SF Symbol
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        productImageView.image = UIImage(systemName: product.imageSystemName, withConfiguration: config)
            ?? UIImage(systemName: "photo", withConfiguration: config)

        nameLabel.text = product.name
        brandLabel.text = product.brand
        ratingLabel.text = "⭐ \(product.rating) (\(product.reviewCount))"

        // Preço formatado
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")

        priceLabel.text = formatter.string(from: NSNumber(value: product.price))

        // Preço original com tachado
        if product.isOnSale {
            let originalText = formatter.string(from: NSNumber(value: product.originalPrice)) ?? ""
            let attributed = NSAttributedString(
                string: originalText,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            originalPriceLabel.attributedText = attributed
            originalPriceLabel.isHidden = false

            // Badge de desconto
            saleBadge.text = " -\(Int(product.discount))% "
            saleBadge.isHidden = false
        } else {
            originalPriceLabel.isHidden = true
            saleBadge.isHidden = true
        }
    }

    // MARK: - Actions
    @objc private func addToCartTapped() {
        guard let product = product else { return }
        onAddToCart?(product)

        // Feedback visual
        UIView.animate(withDuration: 0.1, animations: {
            self.addToCartButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.addToCartButton.transform = .identity
            }
        }
    }
}
