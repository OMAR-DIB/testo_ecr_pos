import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:testooo/main.dart';
import 'package:testooo/models/transaction/transaction.dart'; // Import ObjectBox packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testooo/objectbox.g.dart'; // For date formatting

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final transactionBox = gloablObx.store.box<Transaction>();
  DateTime? startDate;
  DateTime? endDate;
  List<Transaction> filteredTransactions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        filteredTransactions = transactionBox.getAll();
        isLoading = false;
      });
    });
  }

  void _filterTransactionsByDate() {
    if (startDate == null || endDate == null) return;

    final start = DateFormat('yyyy-MM-dd').format(startDate!);
    final end = DateFormat('yyyy-MM-dd').format(endDate!);

    setState(() {
      filteredTransactions = transactionBox.query(
        Transaction_.transactionDate.greaterOrEqual(start).and(
          Transaction_.transactionDate.lessOrEqual(end),
        ),
      ).build().find();
    });
  }

  Future<void> _pickDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (pickedRange != null) {
      setState(() {
        startDate = pickedRange.start;
        endDate = pickedRange.end;
      });
      _filterTransactionsByDate();
    }
  }

  Map<String, List<Transaction>> _groupTransactionsByDate() {
    Map<String, List<Transaction>> groupedTransactions = {};
    for (var transaction in filteredTransactions) {
      final date = transaction.transactionDate.split('T').first;
      groupedTransactions[date] = groupedTransactions[date] ?? [];
      groupedTransactions[date]!.add(transaction);
    }
    return groupedTransactions;
  }

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = _groupTransactionsByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDateRange,
                  icon: const Icon(Icons.date_range, color: Colors.white),
                  label: Text(
                    startDate != null && endDate != null
                        ? 'From: ${DateFormat('MM/dd/yyyy').format(startDate!)} To: ${DateFormat('MM/dd/yyyy').format(endDate!)}'
                        : 'Select Date Range',
                    style: const TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _filterTransactionsByDate,
                  child: const Text('Filter', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTransactions.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                size: 64, color: Colors.orange),
                            SizedBox(height: 16),
                            Text(
                              'No transactions found.',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: groupedTransactions.keys.length,
                        itemBuilder: (context, index) {
                          final date = groupedTransactions.keys.elementAt(index);
                          final transactions = groupedTransactions[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.teal.shade100,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  DateFormat('MMMM dd, yyyy')
                                      .format(DateTime.parse(date)),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal),
                                ),
                              ),
                              ...transactions.map((transaction) =>
                                  _buildTransactionCard(transaction)),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction ID: ${transaction.id}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Date: ${transaction.transactionDate}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const Divider(thickness: 1, color: Colors.teal),
            const Text(
              'Transaction Lines:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.tealAccent),
            ),
            for (var line in transaction.lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '- ${line.itemName}: \$${line.price.toStringAsFixed(2)} (Qty: ${line.quantity})',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

