import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:style_me/dealScript.dart';

class DealDetailsScreen extends StatelessWidget {
  final String barberEmail;
  final String dealTitle;

  DealDetailsScreen({required this.barberEmail, required this.dealTitle});

  Future<Map<String, dynamic>> fetchDeal() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('SalonsDeals')
        .where('barberEmail', isEqualTo: barberEmail)
        .where('title', isEqualTo: dealTitle)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      throw Exception('Deal not found');
    }
  }

  void _bookNow(BuildContext context, Map<String, dynamic> deal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PaymentMethodDialog(deal: deal);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deal Details'),
        backgroundColor: Color.fromARGB(255, 13, 106, 101),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDeal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var deal = snapshot.data!;
            return SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          deal['imageUrl'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        deal['title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 13, 106, 101),
                        ),
                      ),
                      SizedBox(height: 8),
                      Divider(),
                      SizedBox(height: 8),
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        deal['description'],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Original Price: \PKR ${deal['originalPrice']}',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Discounted Price: \PKR ${deal['discountedPrice']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 13, 106, 101),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Valid From:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat.yMMMd()
                                    .format(deal['startDate'].toDate()),
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'To:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat.yMMMd()
                                    .format(deal['endDate'].toDate()),
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _bookNow(context, deal),
                          child: Text(
                            'Book Now',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 13, 106, 101),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: Text('No deal found'));
          }
        },
      ),
    );
  }
}

class PaymentMethodDialog extends StatelessWidget {
  final Map<String, dynamic> deal;

  PaymentMethodDialog({required this.deal});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Payment Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaymentMethodTile(
            assetPath: 'assets/jazzcashlogo.png',
            methodName: 'JazzCash',
            onSelect: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSummaryScreen(
                  userEmail: FirebaseAuth.instance.currentUser?.email ?? '',
                ),
              ),
            ),
          ),
          PaymentMethodTile(
            assetPath: 'assets/easypaisa.png',
            methodName: 'Easypaisa',
            onSelect: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSummaryScreen(
                  userEmail: FirebaseAuth.instance.currentUser?.email ?? '',
                ),
              ),
            ),
          ),
          PaymentMethodTile(
            assetPath: 'assets/card.png',
            methodName: 'Bank',
            onSelect: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSummaryScreen(
                  userEmail: FirebaseAuth.instance.currentUser?.email ?? '',
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Color.fromARGB(255, 13, 106, 101)),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String assetPath;
  final String methodName;
  final VoidCallback onSelect;

  PaymentMethodTile({
    required this.assetPath,
    required this.methodName,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            assetPath,
            width: 50,
            height: 50,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              methodName,
              style: TextStyle(fontSize: 16), // reduced font size
            ),
          ),
          ElevatedButton(
            onPressed: onSelect,
            child: Text(
              'Select',
              style: TextStyle(
                  color: Colors.white, fontSize: 14), // reduced font size
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 13, 106, 101),
            ),
          ),
        ],
      ),
    );
  }
}
