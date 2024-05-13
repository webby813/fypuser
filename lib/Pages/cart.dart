import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Components/button_widget.dart';
import 'package:fypuser/Components/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/spinner_widget.dart';
import '../Firebase/delete_data.dart';
import '../Firebase/update_data.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String paymentType = "Cash";
  late String userEmail;

  late Stream<QuerySnapshot> cartStream;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString("email") ?? "";
      cartStream = FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('cart')
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.defaultWhite,
          elevation: 0,
          centerTitle: true,
          title: BarTitle.AppBarText('Cart'),
          iconTheme: const IconThemeData(
            color: CustomColors.primaryColor,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      width: 500,
                      height: 5,
                      child: ColoredBox(
                        color: CustomColors.primaryColor,
                      ),
                    ),

                    StreamBuilder<QuerySnapshot>(
                      stream: cartStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Spinner.loadingSpinner();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          final List<Widget> itemWidgets = [];
                          final List<double> priceList = [];
                          final docs = snapshot.data?.docs ?? [];
                          for (var doc in docs) {
                            var itemName = doc['item_name'];
                            var itemPrice = doc['price'];
                            var itemImage = doc['item_picture'];
                            var quantity = doc['quantity'];

                            itemWidgets.add(
                              CartItem(
                                itemName: itemName,
                                price: itemPrice,
                                itemImage: itemImage,
                                quantity: quantity.toString(),
                              ),
                            );
                          }
                          return ListView(
                            shrinkWrap: true,
                            children: itemWidgets,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),


            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 140,
                child: Container(
                  color: CustomColors.defaultWhite,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: GrandTitle.totalTitle(
                                'Grand Total : RM 800.00', 20, FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              items: ["Cash", "E-wallet"]
                                  .map<DropdownMenuItem<String>>(
                                    (element) => DropdownMenuItem(
                                  value: element,
                                  child: SizedBox(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        if (element == "Cash")
                                          const Icon(Icons.attach_money),
                                        if (element == "E-wallet")
                                          const Icon(Icons.phone_iphone),
                                        const SizedBox(width: 8),
                                        Text(element),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                                  .toList(),
                              value: paymentType,
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
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: SecondButtonWidget.buttonWidget(
                                50, 90, 'Order', CustomColors.defaultBlack, () {}),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}

class CartItem extends StatefulWidget {
  final String? itemImage;
  final String itemName;
  final String? price;
  final String? quantity;

  const CartItem({
    super.key,
    required this.itemImage,
    required this.itemName,
    required this.price,
    required this.quantity,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int _quantity;
  late String downloadUrl = "";

  @override
  void initState() {
    super.initState();
    _quantity = int.parse(widget.quantity!);
    loadItemPicture();
  }

  Future<void> loadItemPicture() async {
    final storeRef = FirebaseStorage.instance.ref().child('Items/${widget.itemImage}');
    try {
      final imageUrl = await storeRef.getDownloadURL();
      setState(() {
        downloadUrl = imageUrl;
      });
    } catch (e) {
      // print('Error retrieving image URL: $e');
    }
  }

  void _increment() {
    setState(() {
      _quantity++;
    });
    UpdateData().updateAmount(widget.itemName, _quantity);
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
      UpdateData().updateAmount(widget.itemName, _quantity);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: CustomColors.lightGrey),
        ),
      ),
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 140,
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: downloadUrl.isNotEmpty
                  ? Image.network(
                downloadUrl,
                fit: BoxFit.cover,
              )
                  : Center(child: Spinner.loadingSpinner()),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: OrderTitle.orderTitle(widget.itemName ?? '', 18, FontWeight.w600),
              ),
              SizedBox(
                width: 200,
                child: OrderTitle.orderTitle('RM ${widget.price}' ?? '', 16, FontWeight.w300),
              ),
              SizedBox(
                width: 200,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      iconSize: 20,
                      onPressed: _decrement,
                    ),
                    Text(
                      _quantity.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 20,
                      onPressed: _increment,
                    ),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    DeleteData().removeCartItem(widget.itemName);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: CustomColors.warningRed,
                  ),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}