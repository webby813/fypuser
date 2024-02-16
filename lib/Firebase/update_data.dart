import 'package:fypuser/Components/alertDialog_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUser{
  Future<void> updateUserInfo(String userid, String type, String newData) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('User/$userid');
    try{
      ref.update(
          {
            type:newData
          }
      ).then((value) {
        // print("Insert Successfully");

      }).catchError((error){
        // print("Fail to insert");
      });
    }catch(error){
      // print(error);
    }
    }
}

class UpdatePhoto {
  final ImagePicker _picker = ImagePicker();
  String imagePath = "";
  String imageName = "";

  Future<void> selectImageFromGallery(String username) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath = image.path;
      imageName = image.name;
      // print(imagePath);
      // print(imageName);
      uploadToFirebase(username);
    }
  }

  Future<void> uploadToFirebase(String username) async {
    if (imagePath != "" && imageName != "") {
      final storage = FirebaseStorage.instance.ref('User/$imageName');
      final DatabaseReference userImage = FirebaseDatabase.instance.ref().child('User/$username');
      File imageFile = File(imagePath);
      try {
        userImage.update(
          {
            'userImage' : imageName
          }
        );
        await storage.putFile(imageFile);
        // print(imageName);
        // print("Image uploaded successfully");
      } catch (e) {
        // print(e);
      }
    }
  }
}

class MakeOrder{
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String currentTimeKey = DateTime.now().microsecondsSinceEpoch.toString();

  void readCartData(String username) {
    _databaseReference.child("User").child(username).child("Cart").get().then((DataSnapshot snapshot) {
      // Check if the snapshot contains data
      if (snapshot.value != null) {
        // Convert the dynamic value to Map<dynamic, dynamic>
        Map<dynamic, dynamic>? cartData = snapshot.value as Map<dynamic, dynamic>?;
        if (cartData != null) {
          createNewDataset(cartData, username);
        } else {
          // print("Invalid data format for Cart data.");
        }
      } else {
        // print("Cart data is empty.");
      }
    }).catchError((error) {
      // print("Error reading cart data: $error");
    });
  }

  void createNewDataset(Map<dynamic, dynamic> cartData, username) async {
      try {
        // Here, you can create a new dataset in the Firebase Realtime Database
        // For example, if you want to store it under a new node named "NewCart":
        await _databaseReference.child("Order/$username").set(cartData);
        addHistory(cartData, username);
        // print("New dataset created successfully");
        if(cartData.isNotEmpty){
          remove(username);
        }
      } catch (error) {
        // print("Error creating new dataset: $error");
      }
  }
  void addHistory(Map<dynamic, dynamic> cartData, username) async {
    String currentTimeKey = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await _databaseReference.child("User/$username/History/$currentTimeKey").set(cartData);
      // print("New dataset created successfully");
    } catch (error) {
      // print("Error creating new dataset: $error");
    }
  }

  void remove(username) async{
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('User/$username/Cart');
    ref.remove();
  }
}