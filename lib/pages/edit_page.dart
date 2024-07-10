import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class EditPage extends StatefulWidget {
  final String? title;
  final int? price;

  EditPage({this.title, this.price});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _priceController = TextEditingController(text: widget.price.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productData = ModalRoute.of(context)!.settings.arguments as Map;
    final product = Provider.of<ProductProvider>(context, listen: false);

    _titleController.text = productData['title'];
    _priceController.text = productData['price'].toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter the product title',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save the edited title and price
                String editedTitle = _titleController.text;
                int editedPrice = int.parse(_priceController.text);
                // Perform any necessary operations with the edited data
                product
                    .editProduct(
                        productData['id'].toString(), editedTitle, editedPrice)
                    .then(
                  (value) {
                    if (value) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product Edited'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to edit product'),
                        ),
                      );
                    }
                  },
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
