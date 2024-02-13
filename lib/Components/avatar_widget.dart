import 'package:flutter/material.dart';
import 'package:fypuser/Firebase/update_data.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(20)),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container( // Display an empty circle
              width: 180,
              height: 170,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // You can change the color to your preference
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class AvatarWidgetEdit extends StatelessWidget {
  const AvatarWidgetEdit({super.key, required this.userimage,
  required this.username,});

  final String userimage;
  final String username;

  @override

  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(20)),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: GestureDetector(
            onTap: () {
              UpdatePhoto().selectImageFromGallery(username);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:Image.network(
                userimage,
                width: 180,
                height: 170,
                fit: BoxFit.cover,
              )
            ),
          ),
        ),
      ],
    );
  }
}
