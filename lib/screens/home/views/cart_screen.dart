import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizza_app/screens/home/views/check_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("An error has occurred..."),
            );
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final pizza = documents[index].data() as Map<String, dynamic>;
              final name = pizza['name'] ?? 'Unknown'; // Check if name is null
              final price = pizza['price'] ?? 0; // Check if price is null
              final discount =
                  pizza['discount'] ?? 0; // Check if discount is null
              final finalPrice =
                  price - (price * (discount / 100)); // Calculate final price
              final imageUrl = pizza['picture']; // Get image URL
              return ListTile(
                leading: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(name.toString()), // Convert name to string
                subtitle: Text(
                    '\$.${finalPrice.toStringAsFixed(2)}.00'), // Convert final price to string
                trailing: IconButton(
                  onPressed: () {
                    documents[index].reference.delete();
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 3.0,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Check Out',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
