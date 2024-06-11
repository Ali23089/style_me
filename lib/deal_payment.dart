import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  final Function(String) onPaymentMethodSelected;

  const PaymentMethodsScreen({Key? key, required this.onPaymentMethodSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Credit Card'),
            onTap: () {
              onPaymentMethodSelected('Credit Card');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('Wallet'),
            onTap: () {
              onPaymentMethodSelected('Wallet');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.paypal),
            title: Text('PayPal'),
            onTap: () {
              onPaymentMethodSelected('PayPal');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
