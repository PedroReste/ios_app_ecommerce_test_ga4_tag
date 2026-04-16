import UIKit

// MARK: - SuccessViewController (Tela D)
class SuccessViewController: UIViewController {

    // MARK: - Properties
    private let order: Order
    private var hasLoggedPurchase = false

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

    // Animação de sucesso
    private let successCircle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 0.15)
        view.layer.cornerRadius = 60
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let successImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .medium)
        iv.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        iv.tintColor = UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let successTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Compra Realizada!"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let successSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Seu pedido foi confirmado com sucesso.\nAguarde a entrega! 🚀"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Card do pedido
    private let orderCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.18, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(
            red: 0.25, green: 0.25, blue: 0.35, alpha: 1.0
        ).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let orderIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let orderIdValueLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 18, size: 18)
        label.textColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let itemsTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // Resumo financeiro
    private let financialCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.18, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let subtotalRow = SuccessViewController.makeSummaryRow(title: "Subtotal")
    private let shippingRow = SuccessViewController.makeSummaryRow(title: "Frete")
    private let taxRow = SuccessViewController.makeSummaryRow(title: "Impostos")
    private let totalRow = SuccessViewController.makeSummaryRow(title: "Total Pago", isBold: true)

    // Botões
    private let continueShoppingButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Continuar Comprando"
        config.image = UIImage(systemName: "bag.fill")
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

    private let refundButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Solicitar Reembolso"
        config.image = UIImage(systemName: "arrow.uturn.backward.circle")
        config.imagePadding = 8
        config.baseBackgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 0.15)
        config.baseForegroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        config.cornerStyle = .large
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let shareButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Compartilhar Pedido"
        config.image = UIImage(systemName: "square.and.arrow.up")
        config.imagePadding = 8
        config.baseForegroundColor = UIColor(red: 0.3, green: 0.5, blue: 1.0, alpha: 1.0)
        config.baseBackgroundColor = UIColor(red: 0.3, green: 0.5, blue: 1.0, alpha: 0.15)
        config.cornerStyle = .large
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init
    init(order: Order) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithOrder()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // ✅ screen_view
        AnalyticsManager.shared.logScreenView(
            screenName: "Purchase Success",
            screenClass: "SuccessViewController"
        )

        // ✅ purchase — dispara apenas uma vez
        if !hasLoggedPurchase {
            hasLoggedPurchase = true
            AnalyticsManager.shared.logPurchase(order: order)
            CartService.shared.clearCart()
            animateSuccess()
        }
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "Pedido Confirmado"
        view.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.13, alpha: 1.0)
        navigationItem.hidesBackButton = true

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Financial rows stack
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false

        let financialStack = UIStackView(arrangedSubviews: [
            subtotalRow, shippingRow, taxRow, divider, totalRow
        ])
        financialStack.axis = .vertical
        financialStack.spacing = 10
        financialStack.translatesAutoresizingMaskIntoConstraints = false
        financialCardView.addSubview(financialStack)

        // Buttons stack
        let buttonsStack = UIStackView(arrangedSubviews: [
            continueShoppingButton,
            shareButton,
            refundButton
        ])
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 12
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false

        [
            successCircle, successImageView,
            successTitleLabel, successSubtitleLabel,
            orderCardView, financialCardView, buttonsStack
        ].forEach { contentView.addSubview($0) }

        orderCardView.addSubview(orderIdLabel)
        orderCardView.addSubview(orderIdValueLabel)
        orderCardView.addSubview(itemsTableView)

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Success Circle
            successCircle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            successCircle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            successCircle.widthAnchor.constraint(equalToConstant: 120),
            successCircle.heightAnchor.constraint(equalToConstant: 120),

            successImageView.centerXAnchor.constraint(equalTo: successCircle.centerXAnchor),
            successImageView.centerYAnchor.constraint(equalTo: successCircle.centerYAnchor),
            successImageView.widthAnchor.constraint(equalToConstant: 70),
            successImageView.heightAnchor.constraint(equalToConstant: 70),

            // Labels
            successTitleLabel.topAnchor.constraint(equalTo: successCircle.bottomAnchor, constant: 20),
            successTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            successTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            successSubtitleLabel.topAnchor.constraint(equalTo: successTitleLabel.bottomAnchor, constant: 8),
            successSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            successSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Order Card
            orderCardView.topAnchor.constraint(equalTo: successSubtitleLabel.bottomAnchor, constant: 24),
            orderCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            orderCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            orderIdLabel.topAnchor.constraint(equalTo: orderCardView.topAnchor, constant: 16),
            orderIdLabel.centerXAnchor.constraint(equalTo: orderCardView.centerXAnchor),

            orderIdValueLabel.topAnchor.constraint(equalTo: orderIdLabel.bottomAnchor, constant: 4),
            orderIdValueLabel.centerXAnchor.constraint(equalTo: orderCardView.centerXAnchor),

            itemsTableView.topAnchor.constraint(equalTo: orderIdValueLabel.bottomAnchor, constant: 16),
            itemsTableView.leadingAnchor.constraint(equalTo: orderCardView.leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: orderCardView.trailingAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: orderCardView.bottomAnchor, constant: -8),

            // Financial Card
            financialCardView.topAnchor.constraint(equalTo: orderCardView.bottomAnchor, constant: 16),
            financialCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            financialCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            financialStack.topAnchor.constraint(equalTo: financialCardView.topAnchor, constant: 16),
            financialStack.leadingAnchor.constraint(equalTo: financialCardView.leadingAnchor, constant: 16),
            financialStack.trailingAnchor.constraint(equalTo: financialCardView.trailingAnchor, constant: -16),
            financialStack.bottomAnchor.constraint(equalTo: financialCardView.bottomAnchor, constant: -16),

            divider.heightAnchor.constraint(equalToConstant: 1),

            // Buttons Stack
            buttonsStack.topAnchor.constraint(equalTo: financialCardView.bottomAnchor, constant: 24),
            buttonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            continueShoppingButton.heightAnchor.constraint(equalToConstant: 54),
            shareButton.heightAnchor.constraint(equalToConstant: 48),
            refundButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        // Targets
        continueShoppingButton.addTarget(
            self,
            action: #selector(continueShoppingTapped),
            for: .touchUpInside
        )
        refundButton.addTarget(
            self,
            action: #selector(refundTapped),
            for: .touchUpInside
        )
        shareButton.addTarget(
            self,
            action: #selector(shareOrderTapped),
            for: .touchUpInside
        )
    }

    // MARK: - Configure with Order
    private func configureWithOrder() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")

        orderIdLabel.text = "Código do Pedido"
        orderIdValueLabel.text = order.id

        // Financial rows
        setRowValue(subtotalRow, value: formatter.string(from: NSNumber(value: order.subtotal)) ?? "")
        setRowValue(
            shippingRow,
            value: order.shipping == 0
                ? "Grátis ✅"
                : formatter.string(from: NSNumber(value: order.shipping)) ?? ""
        )
        setRowValue(taxRow, value: formatter.string(from: NSNumber(value: order.tax)) ?? "")
        setRowValue(totalRow, value: formatter.string(from: NSNumber(value: order.total)) ?? "")

        // Highlight total
        if let valueLabel = totalRow.arrangedSubviews.last as? UILabel {
            valueLabel.textColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
            valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        }

        // Frete grátis em verde
        if order.shipping == 0, let valueLabel = shippingRow.arrangedSubviews.last as? UILabel {
            valueLabel.textColor = UIColor(red: 0.1, green: 0.8, blue: 0.4, alpha: 1.0)
        }

        // Coupon badge
        if let coupon = order.coupon, !coupon.isEmpty {
            let couponLabel = UILabel()
            couponLabel.text = "🏷️ Cupom aplicado: \(coupon)"
            couponLabel.font = .systemFont(ofSize: 12, weight: .semibold)
            couponLabel.textColor = UIColor(red: 0.1, green: 0.8, blue: 0.4, alpha: 1.0)
            couponLabel.textAlignment = .center
            couponLabel.translatesAutoresizingMaskIntoConstraints = false
            financialCardView.addSubview(couponLabel)
            // Note: in a production app you'd integrate this into the stack properly
        }
    }

    // MARK: - Table View Setup
    private func setupTableView() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.register(
            OrderItemCell.self,
            forCellReuseIdentifier: OrderItemCell.reuseIdentifier
        )

        // Calcular altura dinâmica da tabela
        let rowHeight: CGFloat = 52
        let tableHeight = CGFloat(order.items.count) * rowHeight
        itemsTableView.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
    }

    // MARK: - Animation
    private func animateSuccess() {
        successCircle.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        successCircle.alpha = 0
        successImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        successImageView.alpha = 0
        successTitleLabel.alpha = 0
        successSubtitleLabel.alpha = 0

        UIView.animate(
            withDuration: 0.5,
            delay: 0.1,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [],
            animations: {
                self.successCircle.transform = .identity
                self.successCircle.alpha = 1
                self.successImageView.transform = .identity
                self.successImageView.alpha = 1
            }
        )

        UIView.animate(withDuration: 0.4, delay: 0.5) {
            self.successTitleLabel.alpha = 1
            self.successSubtitleLabel.alpha = 1
        }
    }

    // MARK: - Helpers
    private static func makeSummaryRow(
        title: String,
        isBold: Bool = false
    ) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = isBold
            ? .systemFont(ofSize: 16, weight: .bold)
            : .systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = isBold
            ? .white
            : UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)

        let valueLabel = UILabel()
        valueLabel.text = "R$ 0,00"
        valueLabel.font = isBold
            ? .systemFont(ofSize: 16, weight: .bold)
            : .systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .right

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }

    private func setRowValue(_ row: UIStackView, value: String) {
        if let valueLabel = row.arrangedSubviews.last as? UILabel {
            valueLabel.text = value
        }
    }

    // MARK: - Actions

    @objc private func continueShoppingTapped() {
        // ✅ select_content — usuário volta para home
        AnalyticsManager.shared.logSelectContent(
            contentType: "navigation",
            itemId: "continue_shopping"
        )

        // Volta para a raiz (HomeViewController)
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func refundTapped() {
        let alert = UIAlertController(
            title: "Solicitar Reembolso",
            message: "Deseja solicitar reembolso do pedido \(order.id)?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .destructive) { [weak self] _ in
            guard let self = self else { return }

            // ✅ refund
            AnalyticsManager.shared.logRefund(order: self.order)

            let successAlert = UIAlertController(
                title: "✅ Reembolso Solicitado",
                message: "Seu reembolso será processado em até 5 dias úteis.",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
        })

        present(alert, animated: true)
    }

    @objc private func shareOrderTapped() {
        // ✅ share
        AnalyticsManager.shared.logShare(
            contentType: "order",
            itemId: order.id,
            method: "ios_share_sheet"
        )

        let text = """ 🛍️ Acabei de comprar na TechStore! Pedido: \(order.id) Total: R$ \(String(format: "%.2f", order.total)) """
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }
}

// MARK: - UITableViewDataSource (Order Items)
extension SuccessViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return order.items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OrderItemCell.reuseIdentifier,
            for: indexPath
        ) as? OrderItemCell else {
            return UITableViewCell()
        }

        cell.configure(with: order.items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate (Order Items)
extension SuccessViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 52
    }
}
