import Foundation

// MARK: - Order Model
struct Order {
    let id: String
    let items: [CartItem]
    let affiliation: String
    let shipping: Double
    let tax: Double
    let coupon: String?

    var subtotal: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }

    var total: Double {
        subtotal + shipping + tax
    }

    // Factory: cria pedido a partir do carrinho
    static func create(from cartItems: [CartItem], coupon: String? = nil) -> Order {
        let subtotal = cartItems.reduce(0) { $0 + $1.subtotal }
        let shipping = subtotal > 5000 ? 0.0 : 29.90
        let tax = subtotal * 0.05  // 5% de imposto simulado

        return Order(
            id: "ORD-\(Int.random(in: 100000...999999))",
            items: cartItems,
            affiliation: "TechStore iOS App",
            shipping: shipping,
            tax: tax,
            coupon: coupon
        )
    }
}
