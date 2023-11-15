import 'package:fypuser/Components/container_widget.dart';
import 'package:flutter/material.dart';

class HotCoffee extends StatefulWidget {
  const HotCoffee({Key? key}) : super(key: key);

  @override
  State<HotCoffee> createState() => _HotCoffeeState();
}

class _HotCoffeeState extends State<HotCoffee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        children: const <Widget>[
          CustomMenuCard(
              imageName: 'assets/Coffee/Americano.png',
              title: 'Americano',
              price: 4.90,
            description: 'Experience the genuine European-style espresso, blending richness with hot water. Europeans likes to make the caffe americano by adding hot water to espresso, creating a taste akin to American-style brewed coffee, with subtle nuances from fresh espresso shots. Try it firsthand!',
          ),

          CustomMenuCard(
              imageName: 'assets/Coffee/Latte.png',
              title: 'Latte',
              price: 4.90,
            description: 'The coffeehouse classic, a caffe latte, features rich espresso in steamed milk, topped with a light layer of foam. Its timeless appeal lies in its simplicity – bold espresso blended with sweet steamed milk, optionally enhanced with syrup or extra shots for those seeking a personalized touch.',
          ),

          CustomMenuCard(
              imageName: 'assets/Coffee/FrenchPress.png',
              title: 'French Press',
              price: 4.90,
              description: 'Get our baristas to brew it for you in our coffee press. The coffee press is a classic, straightforward brewing method that produces a boldly flavorful cup. To brew, fresh coffee grounds are fully immersed in hot water. The mesh filter encourages an even extraction that releases flavorful oils into the cup and creates rich, full-bodied cup.',
          ),

          CustomMenuCard(
              imageName: 'assets/Coffee/Mocha.png',
              title: 'Mocha',
              price: 4.90,
              description: 'The perfect harmony of flavors emerges in this delightful espresso drink. Bittersweet mocha sauce and steamed milk blend together, complementing the richness of both chocolate and coffee. Topped with sweetened whipped cream, it''s a union that feels like a match made in heaven, leaving you longing for its eternal taste.',
          ),

        ],
      ),
    );
  }
}
