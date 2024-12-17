import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testooo/main.dart';
import 'package:testooo/models/cart_item.dart';
import 'package:testooo/models/payment/payment.dart';
import 'package:testooo/models/transaction/transaction_repo.dart';
import 'package:testooo/models/transaction/transaction.dart';
class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final TransactionRepo transactionRepo;

  const PaymentScreen({
    super.key,
    required this.cartItems,
    required this.transactionRepo,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentMethod = 'Cash'; // Default payment method
  late Transaction transaction;

  @override
  void initState() {
    super.initState();
    transaction =
        widget.transactionRepo.createTransactionFromCartItems(widget.cartItems);
  }

  double _calculateTotal() {
    return widget.cartItems.fold(
        0.0, (sum, item) => sum + item.subPrice);
  }

  void _onConfirmPayment() {
    // Save the transaction
    final transactionId = widget.transactionRepo.saveTransaction(transaction);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction saved successfully!')),
    );

    Navigator.pop(context); // Go back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Column(
        children: [
          // Display cart items
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Qty: ${item.quantity}'),
                  trailing: Text('\$${item.subPrice.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          const Divider(),
          // Payment method selector
          ListTile(
            title: const Text('Payment Method'),
            trailing: DropdownButton<String>(
              value: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                DropdownMenuItem(value: 'Card', child: Text('Card')),
              ],
            ),
          ),
          // Total price
          ListTile(
            title: const Text('Total'),
            trailing: Text('\$${_calculateTotal().toStringAsFixed(2)}'),
          ),
          // Confirm Payment Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onConfirmPayment,
              child: const Text('Confirm Payment'),
            ),
          ),
        ],
      ),
    );
  }
}
