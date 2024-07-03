import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> cryptoPrices = [];

  @override
  void initState() {
    super.initState();
    fetchCryptoPrices();
  }

  Future<void> fetchCryptoPrices() async {
    final response = await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));

    if (response.statusCode == 200) {
      setState(() {
        cryptoPrices = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load crypto prices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          'HARGA CRYPTO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cryptoPrices.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cryptoPrices.length,
              itemBuilder: (context, index) {
                final crypto = cryptoPrices[index];
                final priceUsd = double.tryParse(crypto['price_usd']) ?? 0.0;

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(crypto['name']),
                      Text('\$${priceUsd.toStringAsFixed(2)}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
