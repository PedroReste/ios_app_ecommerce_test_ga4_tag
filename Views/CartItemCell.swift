import UIKit

// MARK: - CartItemCell
class CartItemCell: UITableViewCell {

    static let reuseIdentifier = "CartItemCell"

    // MARK: - UI Components
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        iv.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.24, alpha: 1.0)
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let variantLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties
    var cartItem: CartItem?
    var onQuantityChange: ((Int) -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.18, alpha: 1.0)
        selectionStyle = .none

        let quantityStack = UIStackView(arrangedSubviews: [decreaseButton, quantityLabel, increaseButton])
        quantityStack.axis = .horizontal
        quantityStack.spacing = 8
        quantityStack.alignment = .center
        quantityStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(variantLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityStack)

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalToConstant: 60),
            productImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            variantLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            variantLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            variantLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            priceLabel.topAnchor.constraint(equalTo: variantLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            quantityStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quantityStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            decreaseButton.widthAnchor.constraint(equalToConstant: 28),
            decreaseButton.heightAnchor.constraint(equalToConstant: 28),
            increaseButton.widthAnchor.constraint(equalToConstant: 28),
            increaseButton.heightAnchor.constraint(equalToConstant: 28),
            quantityLabel.widthAnchor.constraint(equalToConstant: 24)
        ])

        decreaseButton.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
    }

    // MARK: - Configure
    func configure(with cartItem: CartItem) {
        self.cartItem = cartItem

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        productImageView.image = UIImage(
            systemName: cartItem.product.imageSystemName,
            withConfiguration: config
        )

        nameLabel.text = cartItem.product.name
        variantLabel.text = cartItem.product.variant
        quantityLabel.text = "\(cartItem.quantity)"

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        priceLabel.text = formatter.string(from: NSNumber(value: cartItem.subtotal))
    }

    // MARK: - Actions
    @objc private func decreaseTapped() {
        guard let item = cartItem else { return }
        onQuantityChange?(item.quantity - 1)
    }

    @objc private func increaseTapped() {
        guard let item = cartItem else { return }
        onQuantityChange?(item.quantity + 1)
    }
}
