import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String authToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiI0MTMiLCJDdXJyZW50Q29tSWQiOiIxIiwibmJmIjoxNjk1NDQyMjgxLCJleHAiOjE2OTYwNDcwODEsImlhdCI6MTY5NTQ0MjI4MX0.bYhMEKguSHsthNc_4gORhBmN6lzSvj4rqyM6x011usU"; // Replace with your actual JWT token
  final String apiUrl =
      "https://www.pqstec.com/InvoiceApps/Values/GetProductList?pageNo=1&pageSize=100&search=boys"; // Replace with your API endpoint URL

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
        ),
        body: ProductListScreen(apiUrl: apiUrl, authToken: authToken),
      ),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  final String apiUrl;
  final String authToken;

  ProductListScreen({required this.apiUrl, required this.authToken});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(widget.apiUrl),
      headers: {'Authorization': 'Bearer ${widget.authToken}'},
    );

    if (response.statusCode == 200) {
      setState(() {
        final jsonResponse = json.decode(response.body);
        data = jsonResponse['ProductList'];
      });
    } else {
      // Handle errors, e.g., unauthorized access, server errors, etc.
      print('API Request Failed: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final product = data[index];

        return ListTile(
          title: Text(
            product['Name'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.blue,
            ),
          ),
          subtitle: Text(
            'Price: \$${product['Price']}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          // You can add more widgets here for additional information.
          // For example, an image, description, or category.
        );
      },
    );
  }
}


