# 🛍️ EcommerceTaggingApp — iOS (Swift)

Protótipo nativo iOS de e-commerce para validação de tagueamento com **Firebase Analytics / GA4**.
Desenvolvido em Swift puro com UIKit (sem Storyboards).

---

## 📱 Telas

| Tela | ViewController          | Descrição                                      |
|------|-------------------------|------------------------------------------------|
| A    | HomeViewController      | Lista de produtos, banner promoção, busca      |
| B    | ProductViewController   | Detalhes do produto, wishlist, share           |
| C    | CartViewController      | Resumo do carrinho, cupom, checkout            |
| D    | SuccessViewController   | Confirmação da compra, reembolso, share        |

---

## 📊 Eventos Firebase Analytics Implementados

### Eventos Gerais

| Evento           | Tela  | Trigger                              |
|------------------|-------|--------------------------------------|
| `screen_view`    | Todas | viewDidAppear de cada ViewController |
| `login`          | —     | AnalyticsManager (disponível)        |
| `sign_up`        | —     | AnalyticsManager (disponível)        |
| `search`         | A     | SearchBar — botão "Buscar"           |
| `share`          | B, D  | Botão compartilhar                   |
| `select_content` | D     | Botão "Continuar Comprando"          |
| `tutorial_begin` | —     | AnalyticsManager (disponível)        |
| `tutorial_complete`| —   | AnalyticsManager (disponível)        |
| `generate_lead`  | —     | AnalyticsManager (disponível)        |

### Eventos de Ecommerce

| Evento               | Tela  | Trigger                                      |
|----------------------|-------|----------------------------------------------|
| `view_item_list`     | A     | viewDidAppear — lista de produtos visível     |
| `select_item`        | A     | Tap no card do produto                       |
| `view_item`          | A, B  | Tap no card (A) + viewDidAppear (B)          |
| `add_to_cart`        | A, B, C | Botão "Adicionar" / aumento de quantidade  |
| `remove_from_cart`   | C     | Swipe delete / botão diminuir / quantidade 0 |
| `view_cart`          | A, C  | Tap no ícone do carrinho / viewDidAppear (C) |
| `add_to_wishlist`    | B     | Botão coração                                |
| `begin_checkout`     | C     | Botão "Finalizar Compra"                     |
| `add_shipping_info`  | C     | Botão "Finalizar Compra"                     |
| `add_payment_info`   | C     | Botão "Finalizar Compra"                     |
| `purchase`           | D     | viewDidAppear — uma única vez                |
| `refund`             | D     | Botão "Solicitar Reembolso" → confirmação    |
| `view_promotion`     | A     | viewDidAppear — banner visível               |
| `select_promotion`   | A     | Tap no botão "Ver Ofertas" do banner         |

---

## 🏗️ Arquitetura
