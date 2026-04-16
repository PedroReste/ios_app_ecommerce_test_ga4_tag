import Foundation

// MARK: - CartService (Singleton)
final class CartService {

    static let shared = CartService()
    private init() {}

    // Notificação para atualizar badge
    static let cartDidChangeNotification = Notification.Name("CartDidChange")

    private(set) var items: [CartItem] = []

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var totalValue: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }

    var isEmpty: Bool {
        items.isEmpty
    }

    // MARK: - Adicionar ao carrinho
    func addProduct(_ product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
        notifyChange()
    }

    // MARK: - Remover do carrinho
    func removeProduct(_ product: Product) {
        items.removeAll { $0.product.id == product.id }
        notifyChange()
    }

    // MARK: - Atualizar quantidade
    func updateQuantity(for product: Product, quantity: Int) {
        if quantity <= 0 {
            removeProduct(product)
        } else if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity = quantity
        }
        notifyChange()
    }

    // MARK: - Limpar carrinho
    func clearCart() {
        items.removeAll()
        notifyChange()
    }

    // MARK: - Privado
    private func notifyChange() {
        NotificationCenter.default.post(name: CartService.cartDidChangeNotification, object: nil)
    }
}
