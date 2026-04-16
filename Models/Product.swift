import Foundation
import FirebaseAnalytics

// MARK: - Product Model
struct Product {
    let id: String
    let name: String
    let brand: String
    let category: String
    let subcategory: String
    let price: Double
    let originalPrice: Double
    let currency: String
    let imageSystemName: String   // SF Symbol para mock
    let description: String
    let variant: String
    let rating: Double
    let reviewCount: Int
    let isOnSale: Bool

    // Desconto calculado
    var discount: Double {
        guard originalPrice > price else { return 0 }
        return ((originalPrice - price) / originalPrice) * 100
    }

    // MARK: - Converte para dicionário GA4
    func toAnalyticsItem(
        quantity: Int = 1,
        index: Int? = nil,
        listId: String? = nil,
        listName: String? = nil,
        promotionId: String? = nil,
        promotionName: String? = nil,
        creativeName: String? = nil,
        creativeSlot: String? = nil
    ) -> [String: Any] {

        var item: [String: Any] = [
            AnalyticsParameterItemID: id,
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemBrand: brand,
            AnalyticsParameterItemCategory: category,
            AnalyticsParameterItemCategory2: subcategory,
            AnalyticsParameterItemVariant: variant,
            AnalyticsParameterPrice: price,
            AnalyticsParameterCurrency: currency,
            AnalyticsParameterQuantity: quantity,
            AnalyticsParameterDiscount: originalPrice - price > 0 ? originalPrice - price : 0
        ]

        if let index = index {
            item[AnalyticsParameterIndex] = index
        }
        if let listId = listId {
            item[AnalyticsParameterItemListID] = listId
        }
        if let listName = listName {
            item[AnalyticsParameterItemListName] = listName
        }
        if let promotionId = promotionId {
            item[AnalyticsParameterPromotionID] = promotionId
        }
        if let promotionName = promotionName {
            item[AnalyticsParameterPromotionName] = promotionName
        }
        if let creativeName = creativeName {
            item[AnalyticsParameterCreativeName] = creativeName
        }
        if let creativeSlot = creativeSlot {
            item[AnalyticsParameterCreativeSlot] = creativeSlot
        }

        return item
    }
}

// MARK: - Mock Data
extension Product {
    static let mockProducts: [Product] = [
        Product(
            id: "SKU-001",
            name: "iPhone 15 Pro",
            brand: "Apple",
            category: "Eletrônicos",
            subcategory: "Smartphones",
            price: 7999.99,
            originalPrice: 8999.99,
            currency: "BRL",
            imageSystemName: "iphone",
            description: "O iPhone mais avançado com chip A17 Pro, câmera de 48MP e design em titânio. Bateria de longa duração e tela Super Retina XDR de 6.1 polegadas.",
            variant: "256GB / Titânio Natural",
            rating: 4.8,
            reviewCount: 2341,
            isOnSale: true
        ),
        Product(
            id: "SKU-002",
            name: "MacBook Air M3",
            brand: "Apple",
            category: "Eletrônicos",
            subcategory: "Notebooks",
            price: 12499.99,
            originalPrice: 12499.99,
            currency: "BRL",
            imageSystemName: "laptopcomputer",
            description: "O notebook mais fino da Apple com chip M3 de última geração. Performance excepcional com até 18 horas de bateria e tela Liquid Retina de 13.6 polegadas.",
            variant: "8GB RAM / 256GB SSD",
            rating: 4.9,
            reviewCount: 1876,
            isOnSale: false
        ),
        Product(
            id: "SKU-003",
            name: "AirPods Pro 2",
            brand: "Apple",
            category: "Eletrônicos",
            subcategory: "Áudio",
            price: 1799.99,
            originalPrice: 2199.99,
            currency: "BRL",
            imageSystemName: "airpodspro",
            description: "Cancelamento de ruído ativo de nível profissional com áudio adaptativo. Resistente à água e suor com case MagSafe.",
            variant: "Branco / MagSafe",
            rating: 4.7,
            reviewCount: 4521,
            isOnSale: true
        ),
        Product(
            id: "SKU-004",
            name: "Apple Watch Series 9",
            brand: "Apple",
            category: "Eletrônicos",
            subcategory: "Wearables",
            price: 3299.99,
            originalPrice: 3599.99,
            currency: "BRL",
            imageSystemName: "applewatch",
            description: "Smartwatch com chip S9 e gesto Double Tap. Monitor de saúde avançado com ECG, oxímetro e detector de queda.",
            variant: "41mm / Meia-noite",
            rating: 4.6,
            reviewCount: 3102,
            isOnSale: true
        ),
        Product(
            id: "SKU-005",
            name: "iPad Pro M4",
            brand: "Apple",
            category: "Eletrônicos",
            subcategory: "Tablets",
            price: 9999.99,
            originalPrice: 9999.99,
            currency: "BRL",
            imageSystemName: "ipad",
            description: "O iPad mais poderoso com chip M4 e tela OLED Ultra Retina XDR. Compatível com Apple Pencil Pro e Magic Keyboard.",
            variant: "11 polegadas / 256GB / Wi-Fi",
            rating: 4.9,
            reviewCount: 987,
            isOnSale: false
        ),
        Product(
            id: "SKU-006",
            name: "Samsung Galaxy S24 Ultra",
            brand: "Samsung",
            category: "Eletrônicos",
            subcategory: "Smartphones",
            price: 6999.99,
            originalPrice: 7999.99,
            currency: "BRL",
            imageSystemName: "smartphone",
            description: "Flagship Samsung com câmera de 200MP e S Pen integrada. Tela Dynamic AMOLED 2X de 6.8 polegadas com 120Hz.",
            variant: "256GB / Titânio Preto",
            rating: 4.7,
            reviewCount: 2156,
            isOnSale: true
        ),
        Product(
            id: "SKU-007",
            name: "Sony WH-1000XM5",
            brand: "Sony",
            category: "Eletrônicos",
            subcategory: "Áudio",
            price: 1599.99,
            originalPrice: 1999.99,
            currency: "BRL",
            imageSystemName: "headphones",
            description: "Headphone over-ear com melhor cancelamento de ruído do mercado. 30 horas de bateria e qualidade de áudio Hi-Res.",
            variant: "Preto",
            rating: 4.8,
            reviewCount: 6789,
            isOnSale: true
        ),
        Product(
            id: "SKU-008",
            name: "Dell XPS 15",
            brand: "Dell",
            category: "Eletrônicos",
            subcategory: "Notebooks",
            price: 11999.99,
            originalPrice: 11999.99,
            currency: "BRL",
            imageSystemName: "laptopcomputer",
            description: "Notebook premium com tela OLED 3.5K de 15.6 polegadas. Intel Core i7 de 13ª geração com NVIDIA RTX 4060.",
            variant: "32GB RAM / 1TB SSD",
            rating: 4.5,
            reviewCount: 543,
            isOnSale: false
        )
    ]
}
