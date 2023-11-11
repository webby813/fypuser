import 'package:fypuser/Components/alertDialog_widget.dart';
import 'package:fypuser/Firebase/retrieve_data.dart';
import 'package:fypuser/Firebase/update_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Components/barTitle_widget.dart';
import 'package:fypuser/Components/title_widget.dart';
import 'package:fypuser/Components/divider_widget.dart';
import 'package:fypuser/Components/button_widget.dart';
import 'package:fypuser/Components/cart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import your custom CartItem widget here

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late DatabaseReference? query;
  String? userShared = '';

  String paymentType = "Cash";
  double sumTotal = 0.0 ;

  double grandTotal = 0.0;
  double? finalTotal = 0.0;

  String username = '';
  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userShared = prefs.getString('username') ?? '';
      username = prefs.getString('username') ?? '';
      query = FirebaseDatabase.instance.ref().child('User/$userShared/Cart');
    });
  }


  @override
  Future<void> listenTotal() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? value = sharedPref.getString('username');
    final dbRef = FirebaseDatabase.instance.reference().child('User/$value/Cart');

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

        print("Grand Total: $grandTotal");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    listenTotal();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.defaultWhite,
        elevation: 0,
        title: BarTitle.AppBarText('Cart'),
        iconTheme: const IconThemeData(
          color: CustomColors.primaryColor,
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: OrderTitle.orderTitle('Your order', 17.0, FontWeight.w500),
          ),
          const DivideWidget(),
          // Use your custom CartItem widget here
          CartItem(paymentType: paymentType,),

          Expanded(
            child: Row(
              children: [
                Container(
                  child: OrderTitle.orderTitle('Payment method', 17, FontWeight.w500),
                ),

                Expanded(
                  child: Container(
                    // Wrap the DropdownButtonFormField in a Container
                    child: DropdownButtonFormField(
                      items: ["Cash", "E-wallet",].map<DropdownMenuItem<String>>((element) {
                        Widget displayWidget = Container();
                        switch (element) {
                          case "Cash":
                            displayWidget = Row(
                              children: const [
                                Expanded(
                                  flex: 2,
                                  child: Icon(Icons.attach_money),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: Text("Cash"),
                                ),
                              ],
                            );
                            break;
                          case "E-wallet":
                            displayWidget = Row(
                              children: const [
                                Expanded(
                                  flex: 2,
                                  child: Icon(Icons.phone_iphone),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: Text("E-wallet"),
                                ),
                              ],
                            );
                            break;
                        }
                        return DropdownMenuItem(
                          value: element,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 222,
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: CustomColors.lightGreen), // Customize focused border color as needed
                          borderRadius: BorderRadius.circular(19),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),


          Row(
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
                        print(sumTotal);
                      }
                      finalTotal = sumTotal; // Update the finalTotal with the calculated grandTotal
                      return SizedBox.shrink(); // Return an empty widget (SizedBox.shrink()) to not display anything
                    },
                  ),
                ),
            ],
          ),

          const DivideWidget(),
          Container(
            child: OrderTitle.orderTitle('Grand Total: ${grandTotal.toStringAsFixed(2)}', 18, FontWeight.w800),
          ),

          const DivideWidget(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 30),
            child: ButtonWidget.buttonWidget('Order', () {
              makeOrder().readCartData(username);
            }
            ),
          ),
        ],
      ),
    );
  }
}