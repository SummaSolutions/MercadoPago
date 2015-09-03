Feature: A customer will see a call to action when the product stock is Low
  In order to be motivated to buy a product
  As a customer
  I need to see a call to action when the stock is low

Scenario: See a low stock call to action
  Given Product Sku "ace002" has an stock level of "3"
  When I am on page "retro-chic-eyeglasses.html"
  Then I should see "Only 3 left"