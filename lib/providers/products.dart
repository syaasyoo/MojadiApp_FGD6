import 'dart:convert';

import 'package:fgd_6/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  int get totalItems => _items.length;

  List<Product> searchItem(int id) {
    return items.where((element) => element.id == id).toList();
  }

  Future<bool> addProduct(String title, int price, String description,
      int categoryId, String image) async {
    var url = 'https://api.escuelajs.co/api/v1/products';

    final productData = {
      'title': title,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'images': [image],
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      List<dynamic> imageUrls = jsonDecode(data['images'][0]);
      String imageUrl = imageUrls[0];

      _items.add(Product(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        price: data['price'],
        image: imageUrl,
      ));

      notifyListeners();
      print('Product added successfully');
      print(jsonDecode(response.body));
      return true;
    } else {
      print('Failed to add product. Error: ${response.statusCode}');
      print(jsonDecode(response.body));
      return false;
    }
  }

  Future<void> getProduct() async {
    Uri url =
        Uri.parse('https://api.escuelajs.co/api/v1/products?offset=0&limit=5');

    var response = await http.get(url);
    var data = jsonDecode(response.body) as List<dynamic>;

    _items = data.map((element) {
      List<dynamic> imageUrls = jsonDecode(element['images'][0]);
      String imageUrl = imageUrls[0];

      return Product(
        id: element['id'],
        title: element['title'],
        description: element['description'],
        price: element['price'],
        image: imageUrl,
      );
    }).toList();

    notifyListeners();
    print('Data berhasil ditambahkan');
    print('local item : $_items');
    print('data : ${_items[0].image}');
  }

  //get categories

  Future<bool> getProductById(int id) async {
    var url = 'https://api.escuelajs.co/api/v1/products/$id';

    if (_items.any((element) => element.id == id)) {
      print('Product already exists');
      _items = [
        _items.firstWhere((element) => element.id == id),
      ];
      notifyListeners();
      return true;
    } else {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        List<dynamic> imageUrls = jsonDecode(data['images'][0]);
        String imageUrl = imageUrls[0];

        _items.add(Product(
          id: data['id'],
          title: data['title'],
          description: data['description'],
          price: data['price'],
          image: imageUrl,
        ));
        _items = [
          _items.firstWhere((element) => element.id == data['id']),
        ];

        notifyListeners();
        print('Product added successfully');
        print('local item after: $_items');
        return true;
      } else {
        print('Failed to get product. Error: ${response.statusCode}');
        return false;
      }
    }
  }

  Future<bool> editProduct(String id, String title, int price) async {
    var url = 'https://api.escuelajs.co/api/v1/products/$id';

    final productData = {
      'title': title,
      'price': price,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 200) {
      print('Product edited successfully');
      await getProduct();
      return true;
    } else {
      print('Failed to edit product. Error: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    var url = 'https://api.escuelajs.co/api/v1/products/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Product deleted successfully');
      await getProduct();
      return true;
    } else {
      print('Failed to delete product. Error: ${response.statusCode}');
      return false;
    }
  }
}
