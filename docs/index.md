# API For Use Cases
## These APIs are categorized into domains or use cases
## **Product Management Domain**:
   - **APIs**:
     - `POST /products`: Add a new product
     - `PUT /products/{productId}`: Update an existing product
     - `DELETE /products/{productId}`: Remove a product
     - `GET /products/{productId}`: Get details of a product
     - `GET /categories`: Get list of product categories
     - `POST /categories`: Add a new product category
     - `PUT /categories/{categoryId}`: Update an existing product category
     - `DELETE /categories/{categoryId}`: Remove a product category

## **User Management Domain**:
### Note: Login and Logout endpoints might not be needed if we plan to use Firebase
   - **APIs**:
     - `POST /admin/login`: Admin login
     - `POST /admin/logout`: Admin logout
     - `POST /admin/register`: Register a new admin
     - `POST /customer/login`: Customer login
     - `POST /customer/logout`: Customer logout
     - `POST /customer/register`: Register a new customer
     - `GET /customer/{customerId}`: Get customer profile
     - `PUT /customer/{customerId}`: Update customer profile
     - `PUT /customer/{customerId}/password`: Change customer password

## **Order Management Domain**:
   - **APIs**:
     - `POST /orders`: Create a new order
     - `GET /orders/{orderId}`: Get details of an order
     - `GET /orders/customer/{customerId}`: Get orders of a customer
     - `PUT /orders/{orderId}`: Update order status
     - `DELETE /orders/{orderId}`: Cancel an order
     - `POST /cart/items`: Add item to cart
     - `GET /cart/items`: Get items in cart
     - `DELETE /cart/items/{itemId}`: Remove item from cart

## **Inventory Management Domain**:
   - **APIs**:
     - `PUT /inventory/{productId}`: Update stock levels of a product
     - `GET /inventory/low_stock`: Get products with low stock levels
     - `POST /inventory/notifications`: Receive stock notifications

## **Payment and Checkout Domain**:
   - **APIs**:
     - `POST /checkout`: Process checkout
     - `POST /payment`: Process payment

## **Search and Navigation Domain**:
   - **APIs**:
     - `GET /products`: Search and filter products
     - `GET /products/{productId}`: Get details of a product

## **Customer Support Domain/Smart support**:
   - **APIs**:
     - `POST /tickets`: Submit support ticket
     - `GET /tickets/{ticketId}`: Get details of a support ticket
     - `GET /tickets/customer/{customerId}`: Get support tickets of a customer
     - `PUT /tickets/{ticketId}`: Resolve a support ticket

## **Analytics and Reporting Domain**:
   - **APIs**:
     - `GET /reports/sales`: Generate sales report
    
# Order Flow PUML
### Copy and paste the following in PUML
https://www.plantuml.com/plantuml/uml/SyfFKj2rKt3CoKnELR1Io4ZDoSa70000

@startuml  
start  
:Checkout;  
:Make Payment;  
if (Payment Success?) then (yes)  
  :Update Inventory;  
  :Process Order;  
  :Notify Delivery;  
  :Delivery;  
else (no)  
  stop  
endif  
stop  
@enduml  

# Fashion Fusion APIs in Swagger
### Copy and paste the following in https://editor.swagger.io

