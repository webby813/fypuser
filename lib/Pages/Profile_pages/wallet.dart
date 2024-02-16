import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';
import '../../Components/title_widget.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double balance = 0.0; // Initial balance amount

  void depositAmount(double amount) {
    setState(() {
      balance += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.defaultWhite,
          title: BarTitle.AppBarText('Wallet'),
          iconTheme: const IconThemeData(
            color: CustomColors.primaryColor,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                '\$$balance',
                style: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  depositAmount(10.0); // Deposit amount on button press
                },
                child: const Text('Deposit \$ 10'),
              ),
            ],
          ),
        ),
      );
  }
}