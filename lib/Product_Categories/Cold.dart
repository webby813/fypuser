import 'package:flutter/material.dart';
import 'package:fypuser/Components/container_widget.dart';

class ColdCoffee extends StatefulWidget {
  const ColdCoffee({Key? key}) : super(key: key);

  @override
  State<ColdCoffee> createState() => _ColdCoffeeState();
}

class _ColdCoffeeState extends State<ColdCoffee> {
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
              title: 'Iced Americano',
              price: 4.90,
              description: 'In the authentic European tradition, savor a rich, full-bodied iced americano—a blend of bold espresso and cold water. While America''s coffee is distinct, the caffe americano caters to their preference for larger servings, achieved by adding water to the espresso. Experience the subtle differences from freshly pulled espresso in this delightful iced beverage—best enjoyed firsthand.',

          ),

          CustomMenuCard(
              imageName: 'assets/Coffee/ColdFoamIcedEspresso.png',
              title: 'Iced Espresso',
              price: 4.90,
              description: 'Introducing our latest product, Iced Espresso, where signature espresso meets velvety cold foam. Experience the innovation as luscious cold foam tops sweetened Espresso, offering coffee enthusiasts a full-bodied taste with deep coffee notes. Savor the evolving flavor and texture as you mix the creamy foam with the chilled espresso in every sip.',
          ),

          CustomMenuCard(
              imageName: 'assets/Coffee/ColdBrew.png',
              title: 'Cold Brew',
              price: 4.90,
              description: 'Unveil our exceptional Cold Brew, created through a unique, small-batch, slow-steeped process for extraordinary smoothness. Without hot water contact, it''s steeped over 10 hours in cool water, resulting from months of experimentation with brew times and coffee varieties. Our special Starbucks® Cold Brew Blend, with African and Latin American coffees, enhances the naturally sweet, rich flavor of this signature recipe.',
          ),

          CustomMenuCard(
              imageName: 'assets/Coffee/MatchaColdFoamIcedAmericano.png',
              title: 'Matcha Americano',
              price: 4.90,
              description: 'We brings a dream for coffee and tea enthusiasts to life, reinventing the Iced Americano with an earthy Matcha Cold Foam. Nonfat milk creates a meringue-like topping, adding a smooth layer of intrigue to the classic Iced Americano, blending contrasting yet complementary flavors. Enjoy it cold!',
          ),

        ],
      ),
    );
  }
}
