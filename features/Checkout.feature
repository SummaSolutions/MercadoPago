Feature: A customer should be able to do a checkout with MercadoPago

Scenario: See MercadoPago option as a payment method
  Given Product Sku "ace002" has an stock level of "3"
  When I am on page "retro-chic-eyeglasses.html"
  Then I should see "Only 3 left"