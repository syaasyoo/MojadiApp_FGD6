import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int count = 1;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    if (count > 1) {
      setState(() {
        count--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)!.settings.arguments as int;
    final product = Provider.of<ProductProvider>(context, listen: false);
    var productData = product.searchItem(productID);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/edit', arguments: {
                'id': productData[0].id,
                'title': productData[0].title,
                'price': productData[0].price,
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            productData = product.searchItem(productID);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Image.network(productData[0].image),
              const SizedBox(height: 16),
              Text(
                productData[0].title,
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                productData[0].description,
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '\$ ${productData[0].price}',
                        style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                        onPressed: decrement,
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$count'),
                      IconButton(
                        onPressed: increment,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.deepPurple,
          ),
          onPressed: () {},
          child: Text(
            'Add to Cart',
            style: GoogleFonts.josefinSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
