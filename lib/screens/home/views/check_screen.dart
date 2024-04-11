import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizza_app/screens/home/views/home_screen.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({Key? key}) : super(key: key);

  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  TextEditingController addressController = TextEditingController();
  bool isTakeAway = true; // Default to take away option

  double calculateSubtotal(List<DocumentSnapshot> documents) {
    double subtotal = 0;
    for (var document in documents) {
      final pizza = document.data() as Map<String, dynamic>;
      final price = pizza['price'] ?? 0;
      final discount = pizza['discount'] ?? 0;
      final finalPrice = price - (price * (discount / 100));
      subtotal += finalPrice;
    }
    return subtotal;
  }

  void _showThankYouPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank You!'),
          content: const Text('Your order has been placed successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
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
          final subtotal = calculateSubtotal(documents);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Delivery Options:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: isTakeAway,
                      onChanged: (value) {
                        setState(() {
                          isTakeAway = value as bool;
                        });
                      },
                    ),
                    const Text('Take Away'),
                    Radio(
                      value: false,
                      groupValue: isTakeAway,
                      onChanged: (value) {
                        setState(() {
                          isTakeAway = value as bool;
                        });
                      },
                    ),
                    const Text('Delivery'),
                  ],
                ),
                if (!isTakeAway)
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Enter your address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final firestoreInstance = FirebaseFirestore.instance;
                      // Construct order data
                      final orderData = {
                        'subtotal': subtotal,
                        'isTakeAway': isTakeAway,
                        'address': isTakeAway ? null : addressController.text,
                        // Assuming 'done' field is used to indicate order completion
                        'done': false,
                        // Add more fields as needed
                      };
                      await firestoreInstance
                          .collection('orders')
                          .add(orderData);
                      // Clear cart after checkout
                      for (var document in documents) {
                        document.reference.delete();
                      }
                      // Show thank you popup
                      _showThankYouPopup(context);
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
                      'Done',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}
