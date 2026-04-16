import Foundation
import FirebaseAnalytics

// MARK: - AnalyticsManager
// Centraliza todos os eventos GA4 recomendados (gerais + ecommerce)

final class AnalyticsManager {

    // Singleton
    static let shared = AnalyticsManager()
    private init() {}

    // MARK: - Debug helper
    private func log(_ eventName: String, params: [String: Any]?) {
        #if DEBUG
        print("📊 [Analytics] Event: \(eventName)")
        if let params = params {
            params.forEach { key, value in
                print(" └─ \(key): \(value)")
            }
        }
        #endif
    }

    // =========================================================
    // MARK: - EVENTOS GERAIS RECOMENDADOS (GA4)
    // =========================================================

    // MARK: screen_view
    /// Dispara quando o usuário visualiza uma tela
    func logScreenView(screenName: String, screenClass: String) {
        let params: [String: Any] = [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass
        ]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: params)
        log(AnalyticsEventScreenView, params: params)
    }

    // MARK: login
    /// Dispara quando o usuário faz login
    func logLogin(method: String) {
        let params: [String: Any] = [
            AnalyticsParameterMethod: method
        ]
        Analytics.logEvent(AnalyticsEventLogin, parameters: params)
        log(AnalyticsEventLogin, params: params)
    }

    // MARK: sign_up
    /// Dispara quando o usuário se cadastra
    func logSignUp(method: String) {
        let params: [String: Any] = [
            AnalyticsParameterMethod: method
        ]
        Analytics.logEvent(AnalyticsEventSignUp, parameters: params)
        log(AnalyticsEventSignUp, params: params)
    }

    // MARK: search
    /// Dispara quando o usuário realiza uma busca
    func logSearch(searchTerm: String) {
        let params: [String: Any] = [
            AnalyticsParameterSearchTerm: searchTerm
        ]
        Analytics.logEvent(AnalyticsEventSearch, parameters: params)
        log(AnalyticsEventSearch, params: params)
    }

    // MARK: share
    /// Dispara quando o usuário compartilha conteúdo
    func logShare(contentType: String, itemId: String, method: String) {
        let params: [String: Any] = [
            AnalyticsParameterContentType: contentType,
            AnalyticsParameterItemID: itemId,
            AnalyticsParameterMethod: method
        ]
        Analytics.logEvent(AnalyticsEventShare, parameters: params)
        log(AnalyticsEventShare, params: params)
    }

    // MARK: select_content
    /// Dispara quando o usuário seleciona um conteúdo
    func logSelectContent(contentType: String, itemId: String) {
        let params: [String: Any] = [
            AnalyticsParameterContentType: contentType,
            AnalyticsParameterItemID: itemId
        ]
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: params)
        log(AnalyticsEventSelectContent, params: params)
    }

    // MARK: tutorial_begin
    func logTutorialBegin() {
        Analytics.logEvent(AnalyticsEventTutorialBegin, parameters: nil)
        log(AnalyticsEventTutorialBegin, params: nil)
    }

    // MARK: tutorial_complete
    func logTutorialComplete() {
        Analytics.logEvent(AnalyticsEventTutorialComplete, parameters: nil)
        log(AnalyticsEventTutorialComplete, params: nil)
    }

    // MARK: generate_lead
    func logGenerateLead(currency: String, value: Double) {
        let params: [String: Any] = [
            AnalyticsParameterCurrency: currency,
            AnalyticsParameterValue: value
        ]
        Analytics.logEvent(AnalyticsEventGenerateLead, parameters: params)
        log(AnalyticsEventGenerateLead, params: params)
    }

    // =========================================================
    // MARK: - EVENTOS DE ECOMMERCE (GA4)
    // =========================================================

    // MARK: view_item_list
    /// Dispara quando uma lista de produtos é exibida
    func logViewItemList(
        items: [Product],
        listId: String,
        listName: String
    ) {
        let itemsArray = items.enumerated().map { index, product in
            product.toAnalyticsItem(
                index: index,
                listId: listId,
                listName: listName
            )
        }

        let params: [String: Any] = [
            AnalyticsParameterItemListID: listId,
            AnalyticsParameterItemListName: listName,
            AnalyticsParameterItems: itemsArray
        ]
        Analytics.logEvent(AnalyticsEventViewItemList, parameters: params)
        log(AnalyticsEventViewItemList, params: params)
    }

    // MARK: select_item
    /// Dispara quando o usuário seleciona um produto da lista
    func logSelectItem(
        product: Product,
        index: Int,
        listId: String,
        listName: String
    ) {
        let params: [String: Any] = [
            AnalyticsParameterItemListID: listId,
            AnalyticsParameterItemListName: listName,
            AnalyticsParameterItems: [
                product.toAnalyticsItem(
                    index: index,
                    listId: listId,
                    listName: listName
                )
            ]
        ]
        Analytics.logEvent(AnalyticsEventSelectItem, parameters: params)
        log(AnalyticsEventSelectItem, params: params)
    }

    // MARK: view_item
    /// Dispara quando o usuário visualiza detalhes de um produto
    func logViewItem(product: Product) {
        let params: [String: Any] = [
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: product.price,
            AnalyticsParameterItems: [product.toAnalyticsItem()]
        ]
        Analytics.logEvent(AnalyticsEventViewItem, parameters: params)
        log(AnalyticsEventViewItem, params: params)
    }

    // MARK: add_to_cart
    /// Dispara quando produto é adicionado ao carrinho
    func logAddToCart(product: Product, quantity: Int) {
        let params: [String: Any] = [
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: product.price * Double(quantity),
            AnalyticsParameterItems: [product.toAnalyticsItem(quantity: quantity)]
        ]
        Analytics.logEvent(AnalyticsEventAddToCart, parameters: params)
        log(AnalyticsEventAddToCart, params: params)
    }

    // MARK: remove_from_cart
    /// Dispara quando produto é removido do carrinho
    func logRemoveFromCart(product: Product, quantity: Int) {
        let params: [String: Any] = [
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: product.price * Double(quantity),
            AnalyticsParameterItems: [product.toAnalyticsItem(quantity: quantity)]
        ]
        Analytics.logEvent(AnalyticsEventRemoveFromCart, parameters: params)
        log(AnalyticsEventRemoveFromCart, params: params)
    }

    // MARK: view_cart
    /// Dispara quando o usuário visualiza o carrinho
    func logViewCart(cartItems: [CartItem]) {
        let total = cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        let itemsArray = cartItems.map {
            $0.product.toAnalyticsItem(quantity: $0.quantity)
        }

        let params: [String: Any] = [
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: total,
            AnalyticsParameterItems: itemsArray
        ]
        Analytics.logEvent(AnalyticsEventViewCart, parameters: params)
        log(AnalyticsEventViewCart, params: params)
    }

    // MARK: add_to_wishlist
    /// Dispara quando produto é adicionado à lista de desejos
    func logAddToWishlist(product: Product) {
        let params: [String: Any] = [
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: product.price,
            AnalyticsParameterItems: [product.toAnalyticsItem()]
        ]
        Analytics.logEvent(AnalyticsEventAddToWishlist, parameters: params)
        log(AnalyticsEventAddToWishlist, params: params)
    }

    // MARK: begin_checkout
    /// Dispara quando o usuário inicia o checkout
    func logBeginCheckout(cartItems: [CartItem], coupon: String? = nil) {
        let total = cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        let itemsArray = cartItems.map {
            $0.product.toAnalyticsItem(quantity: $0.quantity)
        }

        var params: [String: Any] = [
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: total,
            AnalyticsParameterItems: itemsArray
        ]
        if let coupon = coupon {
            params[AnalyticsParameterCoupon] = coupon
        }

        Analytics.logEvent(AnalyticsEventBeginCheckout, parameters: params)
        log(AnalyticsEventBeginCheckout, params: params)
    }

    // MARK: add_payment_info
    /// Dispara quando o usuário adiciona informações de pagamento
    func logAddPaymentInfo(
        cartItems: [CartItem],
        paymentType: String,
        coupon: String? = nil
    ) {
        let total = cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        let itemsArray = cartItems.map {
            $0.product.toAnalyticsItem(quantity: $0.quantity)
        }

        var params: [String: Any] = [
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: total,
            AnalyticsParameterPaymentType: paymentType,
            AnalyticsParameterItems: itemsArray
        ]
        if let coupon = coupon {
            params[AnalyticsParameterCoupon] = coupon
        }

        Analytics.logEvent(AnalyticsEventAddPaymentInfo, parameters: params)
        log(AnalyticsEventAddPaymentInfo, params: params)
    }

    // MARK: add_shipping_info
    /// Dispara quando o usuário adiciona informações de entrega
    func logAddShippingInfo(
        cartItems: [CartItem],
        shippingTier: String,
        coupon: String? = nil
    ) {
        let total = cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        let itemsArray = cartItems.map {
            $0.product.toAnalyticsItem(quantity: $0.quantity)
        }

        var params: [String: Any] = [
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: total,
            AnalyticsParameterShippingTier: shippingTier,
            AnalyticsParameterItems: itemsArray
        ]
        if let coupon = coupon {
            params[AnalyticsParameterCoupon] = coupon
        }

        Analytics.logEvent(AnalyticsEventAddShippingInfo, parameters: params)
        log(AnalyticsEventAddShippingInfo, params: params)
    }

    // MARK: purchase
    /// Dispara quando a compra é finalizada
    func logPurchase(order: Order) {
        let itemsArray = order.items.map {
            $0.product.toAnalyticsItem(quantity: $0.quantity)
        }

        var params: [String: Any] = [
            AnalyticsParameterTransactionID: order.id,
            AnalyticsParameterAffiliation: order.affiliation,
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: order.total,
            AnalyticsParameterTax: order.tax,
            AnalyticsParameterShipping: order.shipping,
            AnalyticsParameterItems: itemsArray
        ]
        if let coupon = order.coupon {
            params[AnalyticsParameterCoupon] = coupon
        }

        Analytics.logEvent(AnalyticsEventPurchase, parameters: params)
        log(AnalyticsEventPurchase, params: params)
    }

    // MARK: refund
    /// Dispara quando uma compra é reembolsada
    func logRefund(order: Order, partialItems: [CartItem]? = nil) {
        let itemsArray = (partialItems ?? order.items).map {
            $0.product.toAnalyticsItem(quantity: $0.quantity)
        }

        let params: [String: Any] = [
            AnalyticsParameterTransactionID: order.id,
            AnalyticsParameterCurrency: "BRL",
            AnalyticsParameterValue: order.total,
            AnalyticsParameterItems: itemsArray
        ]
        Analytics.logEvent(AnalyticsEventRefund, parameters: params)
        log(AnalyticsEventRefund, params: params)
    }

    // MARK: view_promotion
    /// Dispara quando uma promoção é exibida
    func logViewPromotion(
        promotionId: String,
        promotionName: String,
        creativeName: String,
        creativeSlot: String,
        items: [Product]
    ) {
        let itemsArray = items.map {
            $0.toAnalyticsItem(
                promotionId: promotionId,
                promotionName: promotionName,
                creativeName: creativeName,
                creativeSlot: creativeSlot
            )
        }

        let params: [String: Any] = [
            AnalyticsParameterPromotionID: promotionId,
            AnalyticsParameterPromotionName: promotionName,
            AnalyticsParameterCreativeName: creativeName,
            AnalyticsParameterCreativeSlot: creativeSlot,
            AnalyticsParameterItems: itemsArray
        ]
        Analytics.logEvent(AnalyticsEventViewPromotion, parameters: params)
        log(AnalyticsEventViewPromotion, params: params)
    }

    // MARK: select_promotion
    /// Dispara quando o usuário clica em uma promoção
    func logSelectPromotion(
        promotionId: String,
        promotionName: String,
        creativeName: String,
        creativeSlot: String,
        items: [Product]
    ) {
        let itemsArray = items.map {
            $0.toAnalyticsItem(
                promotionId: promotionId,
                promotionName: promotionName,
                creativeName: creativeName,
                creativeSlot: creativeSlot
            )
        }

        let params: [String: Any] = [
            AnalyticsParameterPromotionID: promotionId,
            AnalyticsParameterPromotionName: promotionName,
            AnalyticsParameterCreativeName: creativeName,
            AnalyticsParameterCreativeSlot: creativeSlot,
            AnalyticsParameterItems: itemsArray
        ]
        Analytics.logEvent(AnalyticsEventSelectPromotion, parameters: params)
        log(AnalyticsEventSelectPromotion, params: params)
    }
}
