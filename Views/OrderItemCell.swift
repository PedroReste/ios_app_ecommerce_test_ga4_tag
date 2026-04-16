import UIKit

// MARK: - OrderItemCell
// Célula simples usada na tela de sucesso para listar os itens do pedido

final class OrderItemCell: UITableViewCell {

    static let reuseIdentifier = "OrderItemCell"

    // MARK: - UI Components
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16
            ),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 28),
            productImageView.heightAnchor.constraint(equalToConstant: 28),

            nameLabel.leadingAnchor.constraint(
                equalTo: productImageView.trailingAnchor, constant: 10
            ),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),

            quantityLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            quantityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            quantityLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -8
            ),

            priceLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16
            ),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
    }

    // MARK: - Configure
    func configure(with cartItem: CartItem) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .light)
        productImageView.image = UIImage(
            systemName: cartItem.product.imageSystemName,
            withConfiguration: symbolConfig
        )

        nameLabel.text = cartItem.product.name
        quantityLabel.text = "Qtd: \(cartItem.quantity)"

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        priceLabel.text = formatter.string(from: NSNumber(value: cartItem.subtotal))
    }
}
