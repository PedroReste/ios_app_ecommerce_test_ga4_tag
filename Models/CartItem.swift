import Foundation

// MARK: - CartItem Model
struct CartItem {
    let product: Product
    var quantity: Int

    var subtotal: Double {
        product.price * Double(quantity)
    }
}
