import 'package:flutter/material.dart';

class EditableTextField extends StatelessWidget {
  final double value;
  final Function(double) onChanged;
  final String hintText;

  const EditableTextField({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText = 'Enter value',
  });

  void _showEditDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: value.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $hintText'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: hintText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final double? newValue = double.tryParse(controller.text);
                if (newValue != null) {
                  onChanged(newValue);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditDialog(context),
      child: Text(
        value.toString(),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}