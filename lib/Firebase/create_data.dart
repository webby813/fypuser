import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/alertDialog_widget.dart';

class Service{
  bool isEmailValid(String email) {
    const pattern =
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  void register(context, String username, String email, String password) async {
    final db = FirebaseFirestore.instance.collection("users");
    final data = {
      "name": username,
      "email": email,
      "password": password,
      "user_picture": "Default.png",
      "wallet_balance": 0
    };

    try {
      QuerySnapshot snapshot = await db.where("email", isEqualTo: email).get();

      if (snapshot.docs.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogWidget(
              title: 'Sorry!',
              content: 'Email has been taken by others.\nPlease try again!',
            );
          },
        );
      } else {
        await db.doc(email).set(data);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogWidget(
              title: 'You did it',
              content: 'You can login now',
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogWidget(
            title: 'An error occur',
            content: 'Try again later$e',
          );
        },
      );
    }
  }
}

class UserDo {
  Future<void> isItemExist(BuildContext context, String selectedCategory, String itemName, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString("email");
    final dbRef = FirebaseFirestore.instance;

    final userCartItemSnapshot = await dbRef
        .collection('users')
        .doc(userEmail.toString())
        .collection('cart')
        .where('item_name', isEqualTo: itemName)
        .get();

    if (userCartItemSnapshot.docs.isNotEmpty) {
      final userCartItemDoc = userCartItemSnapshot.docs.first;
      int currentQuantity = userCartItemDoc['quantity'] ?? 0;
      await userCartItemDoc.reference.update({'quantity': currentQuantity + quantity});
    } else {
      addToCart(context, selectedCategory, itemName, quantity);
    }
  }

  Future<void> addToCart(context, String selectedCategory, String itemName, int quantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString("email");

      final dbRef = FirebaseFirestore.instance;
      DocumentSnapshot itemSnapshot = await dbRef.collection('items').doc(selectedCategory).collection('content').doc(itemName).get();

      Map<String, dynamic> selectedItem = itemSnapshot.data() as Map<String, dynamic>;
      selectedItem['quantity'] = quantity;
      await dbRef.collection('users').doc(userEmail.toString()).collection('cart').doc(itemName).set(selectedItem);

    } catch (e) {
      // print(e);
    }
  }

}

class CreateOrder {
  Future<void> makeOrder(BuildContext context, double grandTotal, String paymentType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString("email");
    final dbRef = FirebaseFirestore.instance;

    // Log the user email
    print("User email: $userEmail");

    final userDocSnapshot = await dbRef.collection('users').doc(userEmail).get();

    double currentBalance = 0.0;
    String orderId = '${userEmail}#${DateTime.now().millisecondsSinceEpoch.toString()}';

    // Checking if user has available balance
    if (userDocSnapshot.exists && paymentType == "E-wallet") {
      currentBalance = double.parse(userDocSnapshot['wallet_balance'].toString());
    }

    // Get where to copy data
    final cartSnapshot = await dbRef.collection('users').doc(userEmail).collection('cart').get();
    final orderRecordDb = dbRef.collection('users').doc(userEmail).collection('order_record').doc(orderId);

    // Log cart details
    print("Cart has ${cartSnapshot.docs.length} items.");

    if (cartSnapshot.docs.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialogWidget(
            title: 'Sorry !',
            content: 'Your cart is empty, please add some items first!',
          );
        },
      );
    } else if (paymentType == 'Cash' || currentBalance > grandTotal) {
      final orderDb = dbRef.collection('Orders').doc(orderId);
      // Doc field's content
      Map<String, dynamic> orderData = {
        'order_id': orderId,
        'user_email': userEmail,
        'payment_method': paymentType,
        'paid_Amount': grandTotal,
        'paid_Time': DateTime.now(),
        'paid': paymentType == 'E-wallet' ? true : false,
        'order_Status': 'Incoming',
      };
      WriteBatch batch = dbRef.batch();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const SuccessDialog(text: "Order successful",);
        },
      );

      // Deduct wallet balance
      if (paymentType == 'E-wallet') {
        double newBalance = currentBalance - grandTotal;
        await dbRef.collection('users').doc(userEmail).update({'wallet_balance': newBalance});
      }

      // Set items
      for (var doc in cartSnapshot.docs) {
        print("Processing item: ${doc.id} with data: ${doc.data()}");
        batch.set(orderDb.collection('items').doc(doc.id), doc.data());
        batch.set(orderRecordDb.collection('items').doc(doc.id), doc.data()); // Ensure we are adding to the correct sub-collection
      }

      // Set doc fields
      batch.set(orderDb, orderData);
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }

      try {
        await batch.commit();
        print("Batch commit successful.");
      } catch (e) {
        print("Batch commit failed: $e");
      }
    } else if (currentBalance < grandTotal) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialogWidget(
            title: 'Sorry !',
            content: 'Please top-up your wallet or choose cash payment method!',
          );
        },
      );
    }
  }
}