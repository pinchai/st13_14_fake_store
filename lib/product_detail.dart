import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductDetail extends StatelessWidget {
  //const ProductDetail({super.key});
  final int product_id;
  ProductDetail({required this.product_id});

  Future<dynamic> _getProductDetail() async {
    var url = Uri.parse("http://192.168.8.95:8001/api/product_detail?id=${this.product_id}");
    var respone = await http.get(url);
    final data = jsonDecode(respone.body);
    return data;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Product Detail"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<dynamic>(
              // future: fetchData(), // Fetch the data asynchronously
              future: _getProductDetail(), // Fetch the data asynchronously
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 5,
                    ),
                  ); // Loading spinner
                } else if (snapshot.hasError) {
                  return Center(
                      child:
                      Text('Error: ${snapshot.error}')); // Error handling
                } else {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(15), //DecorationImage
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Image.network(
                            "${snapshot.data!['image']}",
                            width: 300,
                          ), //Container
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                            flex: 4,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                    "${snapshot.data!['title']}",
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "${snapshot.data!['description']}",
                                    style: TextStyle(
                                        fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ) //Container
                        ),
                        Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Total: ",
                                  style: TextStyle(fontSize: 25),
                                ),
                                Text(
                                  "\$${snapshot.data!['price']}",
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    print("checkout");
                                  },
                                  child: Text(
                                    "CheckOut",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                )
                              ],
                            ) //Container
                        ),
                      ],
                    ),
                  ); // Display fetched data
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
