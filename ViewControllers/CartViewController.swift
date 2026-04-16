import UIKit

// MARK: - CartViewController (Tela C)
class CartViewController: UIViewController {

    // MARK: - Properties
    private var cartItems: [CartItem] {
        CartService.shared.items
    }

    // MARK: - UI Components
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // Rodapé com resumo
    private let summaryContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.18, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let subtotalTitleLabel = CartViewController.makeSummaryLabel(
        text: "Subtotal", isTitle: true
    )
    private let subtotalValueLabel = CartViewController.makeSummaryLabel(
        text: "R$ 0,00", isTitle: false
    )
    private let shippingTitleLabel = CartViewController.makeSummaryLabel(
        text: "Frete", isTitle: true
    )
    private let shippingValueLabel = CartViewController.makeSummaryLabel(
        text: "R$ 0,00", isTitle: false
    )
    private let taxTitleLabel = CartViewController.makeSummaryLabel(
        text: "Impostos (5%)", isTitle: true
    )
    private let taxValueLabel = CartViewController.makeSummaryLabel(
        text: "R$ 0,00", isTitle: false
    )

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let couponTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Cupom de desconto"
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = .white
        tf.attributedPlaceholder = NSAttributedString(
            string: "Cupom de desconto",
            attributes: [.foregroundColor: UIColor.gray]
        )
        tf.backgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.26, alpha: 1.0)
        tf.layer.cornerRadius = 10
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftViewMode = .always
        tf.autocapitalizationType = .allCharacters
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let checkoutButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Finalizar Compra"
        config.image = UIImage(systemName: "lock.fill")
        config.imagePadding = 8
        config.baseBackgroundColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var updated = attrs
            updated.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            return updated
        }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Empty state
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emptyImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .thin)
        iv.image = UIImage(systemName: "cart", withConfiguration: config)
        iv.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Seu carrinho está vazio"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emptySubLabel: UILabel = {
        let label = UILabel()
        label.text = "Adicione produtos para continuar"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // ✅ screen_view
        AnalyticsManager.shared.logScreenView(
            screenName: "Cart",
            screenClass: "CartViewController"
        )

        // ✅ view_cart
        AnalyticsManager.shared.logViewCart(cartItems: cartItems)

        updateSummary()
        updateEmptyState()
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "Carrinho"
        view.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.13, alpha: 1.0)

        // Empty state setup
        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyLabel)
        emptyStateView.addSubview(emptySubLabel)

        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(summaryContainerView)

        // Summary rows
        let subtotalRow = makeRowStack(
            left: subtotalTitleLabel,
            right: subtotalValueLabel
        )
        let shippingRow = makeRowStack(
            left: shippingTitleLabel,
            right: shippingValueLabel
        )
        let taxRow = makeRowStack(
            left: taxTitleLabel,
            right: taxValueLabel
        )
        let totalRow = makeRowStack(
            left: totalTitleLabel,
            right: totalValueLabel
        )

        let summaryStack = UIStackView(arrangedSubviews: [
            subtotalRow, shippingRow, taxRow, dividerView, totalRow
        ])
        summaryStack.axis = .vertical
        summaryStack.spacing = 10
        summaryStack.translatesAutoresizingMaskIntoConstraints = false

        summaryContainerView.addSubview(summaryStack)
        summaryContainerView.addSubview(couponTextField)
        summaryContainerView.addSubview(checkoutButton)

        NSLayoutConstraint.activate([
            // TableView
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(
                equalTo: summaryContainerView.topAnchor,
                constant: -8
            ),

            // Empty state
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),

            emptyImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),

            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 16),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),

            emptySubLabel.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 8),
            emptySubLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptySubLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),

            // Summary Container
            summaryContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Summary Stack
            summaryStack.topAnchor.constraint(
                equalTo: summaryContainerView.topAnchor, constant: 20
            ),
            summaryStack.leadingAnchor.constraint(
                equalTo: summaryContainerView.leadingAnchor, constant: 20
            ),
            summaryStack.trailingAnchor.constraint(
                equalTo: summaryContainerView.trailingAnchor, constant: -20
            ),

            dividerView.heightAnchor.constraint(equalToConstant: 1),

            // Coupon
            couponTextField.topAnchor.constraint(
                equalTo: summaryStack.bottomAnchor, constant: 14
            ),
            couponTextField.leadingAnchor.constraint(
                equalTo: summaryContainerView.leadingAnchor, constant: 20
            ),
            couponTextField.trailingAnchor.constraint(
                equalTo: summaryContainerView.trailingAnchor, constant: -20
            ),
            couponTextField.heightAnchor.constraint(equalToConstant: 42),

            // Checkout Button
            checkoutButton.topAnchor.constraint(
                equalTo: couponTextField.bottomAnchor, constant: 12
            ),
            checkoutButton.leadingAnchor.constraint(
                equalTo: summaryContainerView.leadingAnchor, constant: 20
            ),
            checkoutButton.trailingAnchor.constraint(
                equalTo: summaryContainerView.trailingAnchor, constant: -20
            ),
            checkoutButton.heightAnchor.constraint(equalToConstant: 54),
            checkoutButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16
            )
        ])

        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)

        // Tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CartItemCell.self,
            forCellReuseIdentifier: CartItemCell.reuseIdentifier
        )
    }

    // MARK: - Helpers
    private static func makeSummaryLabel(text: String, isTitle: Bool) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = isTitle
            ? .systemFont(ofSize: 14, weight: .regular)
            : .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = isTitle
            ? UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)
            : .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeRowStack(left: UILabel, right: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }

    private func updateSummary() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")

        let order = Order.create(from: cartItems, coupon: couponTextField.text)

        subtotalValueLabel.text = formatter.string(from: NSNumber(value: order.subtotal))
        shippingValueLabel.text = order.shipping == 0
            ? "Grátis"
            : formatter.string(from: NSNumber(value: order.shipping))
        taxValueLabel.text = formatter.string(from: NSNumber(value: order.tax))
        totalValueLabel.text = formatter.string(from: NSNumber(value: order.total))

        // Frete grátis em verde
        shippingValueLabel.textColor = order.shipping == 0
            ? UIColor(red: 0.1, green: 0.8, blue: 0.4, alpha: 1.0)
            : .white
    }

    private func updateEmptyState() {
        let isEmpty = cartItems.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        summaryContainerView.isHidden = isEmpty
    }

    // MARK: - Actions
    @objc private func checkoutTapped() {
        guard !cartItems.isEmpty else { return }

        let coupon = couponTextField.text?.isEmpty == false ? couponTextField.text : nil

        // ✅ add_shipping_info
        AnalyticsManager.shared.logAddShippingInfo(
            cartItems: cartItems,
            shippingTier: "standard",
            coupon: coupon
        )

        // ✅ add_payment_info
        AnalyticsManager.shared.logAddPaymentInfo(
            cartItems: cartItems,
            paymentType: "credit_card",
            coupon: coupon
        )

        // ✅ begin_checkout
        AnalyticsManager.shared.logBeginCheckout(
            cartItems: cartItems,
            coupon: coupon
        )

        // Navegar para tela de sucesso
        let order = Order.create(from: cartItems, coupon: coupon)
        let successVC = SuccessViewController(order: order)
        navigationController?.pushViewController(successVC, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
        updateSummary()
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return cartItems.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemCell.reuseIdentifier,
            for: indexPath
        ) as? CartItemCell else {
            return UITableViewCell()
        }

        let item = cartItems[indexPath.row]
        cell.configure(with: item)

        cell.onQuantityChange = { [weak self] newQuantity in
            guard let self = self else { return }

            let product = item.product
            let oldQuantity = item.quantity

            if newQuantity <= 0 {
                // ✅ remove_from_cart
                AnalyticsManager.shared.logRemoveFromCart(
                    product: product,
                    quantity: oldQuantity
                )
                CartService.shared.removeProduct(product)
            } else {
                if newQuantity < oldQuantity {
                    // ✅ remove_from_cart (redução de quantidade)
                    AnalyticsManager.shared.logRemoveFromCart(
                        product: product,
                        quantity: oldQuantity - newQuantity
                    )
                } else {
                    // ✅ add_to_cart (aumento de quantidade)
                    AnalyticsManager.shared.logAddToCart(
                        product: product,
                        quantity: newQuantity - oldQuantity
                    )
                }
                CartService.shared.updateQuantity(for: product, quantity: newQuantity)
            }

            tableView.reloadData()
            self.updateSummary()
            self.updateEmptyState()
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 90
    }

    // Swipe to delete
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Remover"
        ) { [weak self] _, _, completion in
            guard let self = self else { return }

            let item = self.cartItems[indexPath.row]

            // ✅ remove_from_cart
            AnalyticsManager.shared.logRemoveFromCart(
                product: item.product,
                quantity: item.quantity
            )

            CartService.shared.removeProduct(item.product)
            tableView.reloadData()
            self.updateSummary()
            self.updateEmptyState()
            completion(true)
        }

        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
