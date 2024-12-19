import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testooo/controller/cart_item_controller.dart';
import 'package:testooo/controller/product_provider.dart';

import 'package:testooo/main.dart';
import 'package:testooo/models/cart_item.dart';
import 'package:testooo/models/transaction/transaction.dart';
import 'package:testooo/models/transaction/transaction_repo.dart';
import 'package:testooo/models/transaction/transaction_service.dart';
import 'package:testooo/view/editable_text_field.dart';
import 'package:testooo/view/payment_screen.dart';

class ShowProduct extends StatelessWidget {
  const ShowProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartItemController = Provider.of<CartItemController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 110, 54), // AppBar background color
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 16.0), // Adjust vertical spacing
          child: Container(
            height: 40, // Make the search bar smaller
            width: 600,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor:
                    Colors.grey[300], // Background color for the search bar
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 8), // Adjust inner padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Remove the default border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black26, // Focused border color
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
                      cartItemController.addProduct(product);
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
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Selected Products',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.clear_all, color: Colors.white),
                          onPressed: () {
                            cartItemController.clearCart();
                          },
                        ),
                      ],
                    ),
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItemController.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItemController.cartItems[index];

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
                                  cartItem.product.name,
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
                                  value: cartItem.discount,
                                  hintText: 'Enter discount',
                                  onChanged: (value) {
                                    final discount = value;
                                    cartItemController.updateDiscount(
                                        cartItem.product, discount);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Quantity
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${cartItem.quantity}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Total Price
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '\$${cartItem.subPrice.toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  cartItemController.openActionDrawer(
                                      context, cartItem, cartItemController);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Discount Field

                  const SizedBox(height: 16),
                  // Updated Total Price
                  Text(
                    'Total: \$${cartItemController.totalPriceafterTva.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                  cartItems: cartItemController
                                      .cartItems, // List of CartItem
                                  transactionService:
                                      TransactionService(TransactionRepo()),
                                ),
                              ),
                            );
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
                            cartItemController.clearCart();
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
