import 'package:fgd_6/pages/detail_page.dart';
import 'package:fgd_6/pages/edit_page.dart';
import 'package:fgd_6/pages/home_page.dart';
import 'package:fgd_6/providers/categories.dart';
import 'package:fgd_6/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/add_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Homepage(),
          '/detail': (context) => const DetailPage(),
          '/edit': (context) => EditPage(),
          '/add': (context) => AddPage(),
        },
      ),
    );
  }
}
