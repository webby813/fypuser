import 'package:fypuser/Components/bottomSheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const CustomContainer({super.key, required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

///Custome Card use for Recommend list in homePage.dart
class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.imageName, required this.title, required this.price, required this.description});

  final String imageName;
  final String title;
  final double price;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              showModalBottomSheet(context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context){
                    return ProductBottomSheet(
                      imageName: imageName,
                      title: title,
                      price: price,
                      description: description,
                    );
                  }
              );
            },
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      imageName,
                      width: 180,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18
                      ),
                    ),

                    Text(
                      'RM $price',
                      style: const TextStyle(
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


///CustomMenuCard use to review products in Menu
class CustomMenuCard extends StatelessWidget {
  const CustomMenuCard({super.key, required this.imageName, required this.title, required this.price, required this.description});

  final String imageName;
  final String title;
  final double price;
  final String description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(context: context,
            isScrollControlled: true,
            builder: (BuildContext context){
              return ProductBottomSheet(
                imageName: imageName,
                title: title,
                price: price,
                description: description,
              );
            }
        );
      },
      child: Card(
        shadowColor: CustomColors.defaultWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  imageName,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'RM $price',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key, required this.title, required this.icon, required this.onPress, this.endIcon = true, this.textColor,}) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {


    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: CustomColors.lightGrey.withOpacity(0.1),
        ),
        child: Icon(icon, color: CustomColors.primaryColor),
      ),
      title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)
      ),
      trailing: endIcon?
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: const Icon(Icons.keyboard_double_arrow_right),
      ) : null,
    );
  }
}

class EditDrawer extends StatelessWidget {
  const EditDrawer({Key? key, required this.title, required this.icon, required this.onPress, this.endIcon = true, this.textColor,}) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {


    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: CustomColors.lightGrey.withOpacity(0.1),
        ),
        child: Icon(icon, color: CustomColors.primaryColor),
      ),
      title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)
      ),
      trailing: endIcon?
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: const Icon(Icons.edit),
      ) : null,
    );
  }
}







