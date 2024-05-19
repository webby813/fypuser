import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Components/alertDialog_widget.dart';
import 'package:fypuser/Components/container_widget.dart';
import '../../Components/title_widget.dart';
import '../../Firebase/update_data.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double topUpAmount = 0.0; // Changed to double
  final TextEditingController _topUpController = TextEditingController();
  final UpdateData _updateData = UpdateData();
  String topUpMethod = '';

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
                children: [
                  /// Show Current Balance
                  StreamBuilder<double>(
                    stream: _updateData.getWalletBalance(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      double balance = snapshot.data ?? 0.0;
                      return Card(
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
                                    bottom: BorderSide(
                                        width: 1.5, color: CustomColors.primaryColor),
                                  ),
                                ),
                                child: const Text(
                                  "Current Balance",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10, left: 80),
                                child: Text(
                                  "RM ${balance.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  /// Top up options
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
                                bottom: BorderSide(
                                    width: 1.5, color: CustomColors.primaryColor),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    "RM",
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Expanded(
                                  flex: 12,
                                  child: TextField(
                                    controller: _topUpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    style: const TextStyle(fontSize: 24),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "00.00",
                                      counterText: '',
                                    ),
                                  ),
                                ),
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
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      topUpAmount = 10.0;
                                      _topUpController.text = topUpAmount.toString();
                                    });
                                  },
                                  child: const Text(
                                    '10',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: CustomColors.defaultBlack),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      topUpAmount = 20.0;
                                      _topUpController.text = topUpAmount.toString();
                                    });
                                  },
                                  child: const Text(
                                    '20',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: CustomColors.defaultBlack),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      topUpAmount = 30.0;
                                      _topUpController.text = topUpAmount.toString();
                                    });
                                  },
                                  child: const Text(
                                    '30',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: CustomColors.defaultBlack),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      topUpAmount = 50.0;
                                      _topUpController.text = topUpAmount.toString();
                                    });
                                  },
                                  child: const Text(
                                    '50',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: CustomColors.defaultBlack),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      topUpAmount = 100.0;
                                      _topUpController.text = topUpAmount.toString();
                                    });
                                  },
                                  child: const Text(
                                    '100',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: CustomColors.defaultBlack),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      topUpAmount = 200.0;
                                      _topUpController.text = topUpAmount.toString();
                                    });
                                  },
                                  child: const Text(
                                    '200',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: CustomColors.defaultBlack),
                                  ),
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
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  CustomListTile.walletListtile(
                                    text: 'E-Wallet',
                                    icon: Icons.wallet,
                                    isSelected:
                                    topUpMethod == 'E-Wallet',
                                    onTap: () {
                                      setState(() {
                                        topUpMethod = 'E-Wallet';
                                      });
                                    },
                                  ),
                                  CustomListTile.walletListtile(
                                    text: 'Credit-card',
                                    icon: Icons.credit_card,
                                    isSelected:
                                    topUpMethod == 'Credit-card',
                                    onTap: () {
                                      setState(() {
                                        topUpMethod = 'Credit-card';
                                      });
                                    },
                                  ),
                                  CustomListTile.walletListtile(
                                    text: 'Online Banking',
                                    icon: Icons.account_balance,
                                    isSelected:
                                    topUpMethod ==
                                        'Online Banking',
                                    onTap: () {
                                      setState(() {
                                        topUpMethod =
                                        'Online Banking';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Summary
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
                    "RM ${topUpAmount.toStringAsFixed(2)}",
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
                            onPressed: () async {
                              if(topUpAmount == null || topUpMethod.isEmpty){
                                showDialog(context: context, builder: (BuildContext context){
                                  return const AlertDialogWidget(
                                    title: 'Null value detected',content: 'You have to enter amount and select your topup method',
                                  );
                                });
                              }else{
                                setState(() {
                                  topUpAmount = double.tryParse(_topUpController.text) ?? 0.0;
                                });

                                await UpdateData().topUpAmount(topUpAmount, topUpMethod);
                                setState(() {
                                  topUpAmount = 0.0;
                                  _topUpController.clear();
                                  topUpMethod = '';
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: CustomColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              "Top-up",
                              style: TextStyle(color: CustomColors.defaultWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
