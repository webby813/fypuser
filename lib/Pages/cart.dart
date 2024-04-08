import 'package:firebase_storage/firebase_storage.dart';
import 'package:fypuser/Firebase/update_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Components/title_widget.dart';
import 'package:fypuser/Components/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  DatabaseReference? query;
  String? userShared = '';

  String paymentType = "Cash";
  double sumTotal = 0.0;

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              CartItem(paymentType: paymentType),

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

              OrderTitle.orderTitle('Grand Total: ${grandTotal.toStringAsFixed(2)}', 18, FontWeight.w500),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                  child: ButtonWidget.buttonWidget('Order', () {
                    MakeOrder().readCartData(username);
                  }
                ),
              ),
            ],
          ),
        )
    );
  }
}

class CartItem extends StatefulWidget {
  const CartItem({Key? key, required this.paymentType}) : super(key: key);

  final String paymentType;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late DatabaseReference? query;

  String? imageUrl;
  String? userShared;

  String? itemName;
  int? qty;
  double? price;

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userShared = prefs.getString('username') ?? '';
      query = FirebaseDatabase.instance.ref().child('User/$userShared/Cart');
    });
  }

  Future<String?> getImageUrl(String imageName) async{
    String? imageUrl;
    try{
      Reference imageRef = FirebaseStorage.instance.ref().child('Item/$imageName');
      imageUrl = await imageRef.getDownloadURL();
    }catch(e){
      // print("Error retrieve image Url: $e");
    }
    return imageUrl;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          if (query != null) // Add this check to avoid null errors
            FirebaseAnimatedList(
                shrinkWrap: true,
                query: query!,
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  Map data = snapshot.value as Map;
                  data['key'] = snapshot.key;

                  return FutureBuilder<String?>(
                    future: getImageUrl(data['itemImage']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show a placeholder while waiting for the image URL
                        return const CircularProgressIndicator(
                          strokeWidth: 1.0,
                        );
                      }

                      imageUrl = snapshot.data;
                      imageUrl ??= 'https://fastly.picsum.photos/id/237/536/354.jpg?hmac=i0yVXW1ORpyCZpQ-CknuyV-jbtU7_x9EBQVhvT5aRr0';
                      itemName = data['itemName'].toString();
                      price = data['price'];
                      qty = data['qty'];

                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    imageUrl!,
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              SizedBox(
                                width: 130,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 10, 0, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        itemName!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        data['price'].toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: CustomColors.primaryColor,
                                        ),
                                      ),
                                      // Padding of 30 seems excessive, you might want to adjust this value.
                                      const Padding(padding: EdgeInsets.all(10)),
                                      Text(
                                        qty.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: CustomColors.lightGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25, 50, 10, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        query?.child(data['key']).remove();
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: CustomColors.warningRed,
                                        size: 26,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
            ),
        ],
      ),
    );
  }
}
