import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Components/container_widget.dart';
import '../../Components/title_widget.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double balance = 0.0; // Initial balance amount
  double topup = 150.0;
  String selectedPaymentMethod = '';

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
          title: BarTitle.AppBarText('Balance Top Up'),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: CustomColors.primaryColor,
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    ///Show Current balance
                    Card(
                        color: CustomColors.defaultWhite,
                        child: SizedBox(
                          width: 225,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 60),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(width: 1.5, color: CustomColors.primaryColor)
                                    )
                                ),
                                child: const Text(
                                  "Current Balance",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.only(top: 10,left: 80),
                                child: const Text(
                                  "RM 678.00",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ),

                    ///Top up options
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        width: MediaQuery.of(context).size.width,
                        color: CustomColors.defaultWhite,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text("Enter top up amount(RM)"),
                              ),

                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(width: 1.5, color: CustomColors.primaryColor)
                                    )
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "RM",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                        flex: 12,
                                        child: TextField(
                                          style: TextStyle(
                                              fontSize: 24
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "00.00",
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),

                              const Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    Text("Minimum amount is RM 10"),
                                  ],
                                ),
                              ),

                              ButtonTheme(
                                alignedDropdown: true,
                                child: GridView.count(
                                  childAspectRatio: 2.0,
                                  shrinkWrap: true,
                                  crossAxisCount: 3,
                                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle button tap
                                      },
                                      child: const Text('10'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle button tap
                                      },
                                      child: const Text('20'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle button tap
                                      },
                                      child: const Text('30'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle button tap
                                      },
                                      child: const Text('50'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle button tap
                                      },
                                      child: const Text('100'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle button tap
                                      },
                                      child: const Text('200'),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.only(top: 15),
                                width: MediaQuery.of(context).size.width,
                                color: CustomColors.defaultWhite,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Payment method",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                      ),

                                      CustomListTile.walletListtile(
                                        text: 'E-Wallet',
                                        icon: Icons.wallet,
                                        isSelected: selectedPaymentMethod == 'E-Wallet',
                                        onTap: () {
                                          setState(() {
                                            selectedPaymentMethod = 'E-Wallet';
                                          });
                                        },
                                      ),

                                      CustomListTile.walletListtile(
                                        text: 'Credit-card',
                                        icon: Icons.credit_card,
                                        isSelected: selectedPaymentMethod == 'Credit-card',
                                        onTap: () {
                                          setState(() {
                                            selectedPaymentMethod = 'Credit-card';
                                          });
                                        },
                                      ),

                                      CustomListTile.walletListtile(
                                        text: 'Online Banking',
                                        icon: Icons.account_balance,
                                        isSelected: selectedPaymentMethod == 'Online Banking',
                                        onTap: () {
                                          setState(() {
                                            selectedPaymentMethod = 'Online Banking';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),

            ///Summary
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: CustomColors.lightGrey),
                  ),
                ),
                child: Column(
                  children: [

                    const Text(
                      "Total Topup Amount",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      "RM ${topup.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  backgroundColor: CustomColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  )
                              ),
                              child: const Text(
                                "Hello",
                                style: TextStyle(
                                    color: CustomColors.defaultWhite
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
