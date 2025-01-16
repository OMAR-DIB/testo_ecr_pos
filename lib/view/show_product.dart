import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testooo/controller/cart_item_controller.dart';
import 'package:testooo/controller/product_provider.dart';
import 'package:testooo/models/transaction/transaction_repo.dart';
import 'package:testooo/models/transaction/transaction_service.dart';
import 'package:testooo/provider/cart_manager.dart';
import 'package:testooo/provider/cart_provider.dart';
import 'package:testooo/view/editable_text_field.dart';
import 'package:testooo/view/payment_screen.dart';

class ShowProduct extends StatelessWidget {
  const ShowProduct({super.key});

  @override
  Widget build(BuildContext context) {
    // Access ProductProvider (for the product list)
    final productProvider = Provider.of<ProductProvider>(context);
    // Access CartProvider (for cart operations)
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 110, 54),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Container(
            height: 40,
            width: 600,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[300],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black26,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          // Left side: Product list as a grid
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];

                  return GestureDetector(
                    onTap: () {
                      // Add product to cart using CartProvider
                      cartProvider.addOrder(product);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[300],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.description ?? 'No description',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 40),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Right side: Selected product details and total
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 16, left: 16, bottom: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom App-Bar-Like Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 31, 110, 54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cartProvider
                            .orders.length, // Use total number of carts
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              cartProvider.switchCart(
                                  index); // Switch to the selected cart
                              print('Switched to Cart ${index + 1}');
                            },
                            child: Card(
                              color: cartProvider.currentCart?.id ==
                                      cartProvider.orders[index].id
                                  ? Colors.green // Highlight active cart
                                  : Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Cart ${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      cartProvider.createNewOrder();
                    },
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        '%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Qty',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Price',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // the screen of item of cart
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          cartProvider.currentCart!.orderLines.length ?? 0,
                      itemBuilder: (context, index) {
                        final orderLine =
                            cartProvider.currentCart!.orderLines[index];
                        final product = orderLine.product.target!;
                        // final cartItem = cartItemController.cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Product Name
                              Expanded(
                                flex: 3,
                                child: Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Editable Discount Field
                              Expanded(
                                flex: 2,
                                child: EditableTextField(
                                  value: orderLine.discount,
                                  hintText: 'Enter discount',
                                  onChanged: (value) {
                                    final discount = value;
                                    cartProvider.updateDiscount(
                                        product, discount);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Quantity
                              Expanded(
                                flex: 1,
                                child: EditableTextField(
                                  value: orderLine.quantity,
                                  hintText: 'Enter quantity',
                                  onChanged: (value) {
                                    final qty = value;
                                    cartProvider.updateQuantity(
                                        product, qty);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Total Price
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '\$${orderLine.total.toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  // Remove product from cart
                                  cartProvider.removeOrderLine(product);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Total Price
                  Text(
                    'Total: \$${cartProvider.currentCart?.total.toStringAsFixed(2) ?? 0.00}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber, // Background color
                          borderRadius:
                              BorderRadius.circular(6), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Subtle shadow
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3), // Shadow position
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 6), // Inner padding
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, // Text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                          ),
                          onPressed: () {
                            print('payment process');
                          },
                          label: const Column(
                            children: [
                              Icon(
                                Icons.payment,
                                color: Colors.black, // Icon color
                                size: 24, // Icon size
                              ),
                              SizedBox(
                                  height:
                                      4), // Optional spacing between icon and text
                              Text(
                                'Pay',
                                style: TextStyle(
                                  fontSize: 16, // Font size
                                  fontWeight: FontWeight.bold, // Bold text
                                  color: Colors.black, // Text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red, // Background color
                          borderRadius:
                              BorderRadius.circular(6), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Subtle shadow
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3), // Shadow position
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 6), // Inner padding
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, // Text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                          ),
                          onPressed: () {
                            cartProvider.removeAllOrders();
                          },
                          label: const Column(
                            children: [
                              Icon(
                                Icons.payment,
                                color: Colors.black, // Icon color
                                size: 24, // Icon size
                              ),
                              SizedBox(
                                  height:
                                      4), // Optional spacing between icon and text
                              Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 16, // Font size
                                  fontWeight: FontWeight.bold, // Bold text
                                  color: Colors.black, // Text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey, // Background color
                          borderRadius:
                              BorderRadius.circular(6), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Subtle shadow
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3), // Shadow position
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 6), // Inner padding
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, // Text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                          ),
                          onPressed: () {
                            // cartItemController.clearCart();
                            // go to report page
                          },
                          label: const Column(
                            children: [
                              Icon(
                                Icons.print,
                                color: Colors.black, // Icon color
                                size: 24, // Icon size
                              ),
                              SizedBox(
                                  height:
                                      4), // Optional spacing between icon and text
                              Text(
                                'Print',
                                style: TextStyle(
                                  fontSize: 16, // Font size
                                  fontWeight: FontWeight.bold, // Bold text
                                  color: Colors.black, // Text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
