import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testooo/main.dart';
import 'package:testooo/models/cart_item.dart';
import 'package:testooo/models/payment/payment.dart';
import 'package:testooo/models/transaction/transaction_repo.dart';
import 'package:testooo/models/transaction/transaction.dart';
import 'package:testooo/models/transaction/transaction_service.dart';class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final TransactionService transactionService;

  const PaymentScreen({
    super.key,
    required this.cartItems,
    required this.transactionService,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late double totalAmount;
  String selectedPaymentType = 'Cash';
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.transactionService.initializeTransaction(widget.cartItems);
    totalAmount = widget.transactionService.calculateTotal(widget.cartItems);
  }

  void _addPayment() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    String error = widget.transactionService.addPayment(
      amount,
      selectedPaymentType,
      totalAmount,
    );

    if (error.isNotEmpty) {
      _showError(error);
    } else {
      setState(() => _amountController.clear());
    }
  }

  void _confirmPayment() {
    String error = widget.transactionService.confirmTransaction();

    if (error.isNotEmpty) {
      _showError(error);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment confirmed! Transaction saved.')),
      );
      Navigator.pop(context); // Return to previous screen
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remainingAmount = widget.transactionService
        .calculateRemainingAmount(totalAmount);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Column(
        children: [
          // Cart Item List
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

          // Payment Input Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: selectedPaymentType,
                    onChanged: (value) {
                      setState(() => selectedPaymentType = value!);
                    },
                    items: const [
                      DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'Card', child: Text('Card')),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addPayment,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          const Divider(),

          // Payments List
          Expanded(
            child: ListView.builder(
              itemCount: widget.transactionService.payments.length,
              itemBuilder: (context, index) {
                final payment = widget.transactionService.payments[index];
                return ListTile(
                  leading: Icon(payment.paymentType == 'Cash'
                      ? Icons.money
                      : Icons.credit_card),
                  title: Text(payment.paymentType),
                  trailing: Text('\$${payment.amount.toStringAsFixed(2)}'),
                );
              },
            ),
          ),

          // Remaining and Confirm Button
          ListTile(
            title: const Text('Remaining Amount'),
            trailing: Text(
              '\$${remainingAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _confirmPayment,
              child: const Text('Confirm Payment'),
            ),
          ),
        ],
      ),
    );
  }
}
