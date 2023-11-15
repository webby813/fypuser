import 'package:fypuser/Color/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

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
    return Column(
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
                      strokeWidth: 4.0,
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
    );
  }
}
