import 'package:fypuser/Firebase/update_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Components/title_widget.dart';
import 'package:fypuser/Components/divider_widget.dart';
import 'package:fypuser/Components/button_widget.dart';
import 'package:fypuser/Components/cart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  DatabaseReference? query; // Removed 'late'
  String? userShared = '';

  String paymentType = "Cash";
  double sumTotal = 0.0 ;

  double grandTotal = 0.0;
  double? finalTotal = 0.0;

  String username = '';

  @override
  void initState() {
    super.initState();
    getUserData();
    listenTotal();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userShared = prefs.getString('username') ?? '';
      username = prefs.getString('username') ?? '';
      query = FirebaseDatabase.instance.ref().child('User/$userShared/Cart');
    });
  }

  Future<void> listenTotal() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? value = sharedPref.getString('username');
    final dbRef = FirebaseDatabase.instance.ref().child('User/$value/Cart');

    dbRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      var cartData = snapshot.value as Map<dynamic, dynamic>?;

      if (cartData != null) {
        double sumTotal = 0.0;

        cartData.forEach((itemName, itemData) {
          if (itemData.containsKey('total')) {
            var total = itemData['total']; // Get the 'total' field for each item
            sumTotal += total;
          }
        });

        setState(() {
          grandTotal = sumTotal;
          finalTotal = grandTotal; // Update the finalTotal with the calculated grandTotal
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.defaultWhite,
        elevation: 0,
        title: BarTitle.AppBarText('Your Cart'),
        iconTheme: const IconThemeData(
          color: CustomColors.primaryColor,
        ),
      ),
      body: Column(
        children: [
          // Container(
          //   child: OrderTitle.orderTitle('Your order', 17.0, FontWeight.w500),
          // ),
          // const DivideWidget(),
          // Use your custom CartItem widget here
          CartItem(paymentType: paymentType,),

          Row(
            children: [
              Container(
                child: OrderTitle.orderTitle('Payment method', 17, FontWeight.w500),
              ),

              Expanded(
                child: DropdownButtonFormField(
                  items: ["Cash", "E-wallet",].map<DropdownMenuItem<String>>((element) {
                    Widget displayWidget = Container();
                    switch (element) {
                      case "Cash":
                        displayWidget = const Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Icon(Icons.attach_money),
                            ),
                            Expanded(
                              flex: 10,
                              child: Text("Cash"),
                            ),
                          ],
                        );
                        break;
                      case "E-wallet":
                        displayWidget = const Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Icon(Icons.phone_iphone),
                            ),
                            Expanded(
                              flex: 10,
                              child: Text("E-wallet"),
                            ),
                          ],
                        );
                        break;
                    }
                    return DropdownMenuItem(
                      value: element,
                      child: SizedBox(
                        // Adjust the width here
                        width: MediaQuery.of(context).size.width - 250, // Adjust the width as needed
                        child: displayWidget,
                      ),
                    );
                  }).toList(),
                  value: paymentType, // default value
                  onChanged: (val) {
                    setState(() {
                      paymentType = val!;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                ),
              )

            ],
          ),

          Expanded(
            child: Row(
              children: <Widget>[
                if (query != null)
                  Expanded(
                    child: FirebaseAnimatedList(
                      shrinkWrap: true,
                      query: query!,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        Map data = snapshot.value as Map;
                        data['key'] = snapshot.key;
                        double totalValue = data['total'] ?? 0.0;
                        if (data['total'] != null) {
                          sumTotal += totalValue;
                        }
                        finalTotal = sumTotal;
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
              ],
            ),
          ),

          const DivideWidget(),
          Container(
            child: OrderTitle.orderTitle('Grand Total: ${grandTotal.toStringAsFixed(2)}', 18, FontWeight.w500),
          ),

          const DivideWidget(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 30),
            child: ButtonWidget.buttonWidget('Order', () {
              MakeOrder().readCartData(username);
            }
            ),
          ),
        ],
      ),
    );
  }
}
