import 'package:flutter/material.dart';
import 'package:fypuser/Components/container_widget.dart';

class NonCoffee extends StatefulWidget {
  const NonCoffee({Key? key}) : super(key: key);

  @override
  State<NonCoffee> createState() => _NonCoffeeState();
}

class _NonCoffeeState extends State<NonCoffee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        children: <Widget>[
          CustomMenuCard(
              imageName: 'assets/Others/CaremelHotChocolate.png',
              title: 'Caremel Coco',
              price: 4.90,
              description: 'Indulge in our irresistible hot chocolate—rich chocolate, pure milk, and aromatic caramel. The blend of steamed milk, vanilla, and mocha syrups, topped with sweet whipped cream, surpasses your fondest memories.',
          ),

          CustomMenuCard(
              imageName: 'assets/Others/HazelnutHotChocolate.png',
              title: 'Hazelnut Coco',
              price: 4.90,
              description: 'The hot chocolate is made with fresh milk, sweet hazelnut-syrup and rich-flavored chocolate powder in perfect portion. Rich aroma and tasty flavor make you sparkle with zest.',
          ),

          CustomMenuCard(
              imageName: 'assets/Others/GreenTeaLatte.png',
              title: 'Green Tea Latte',
              price: 4.90,
              description: 'Sweetened matcha green tea with steamed milk. The Japanese tea ceremony emphasizes the virtues of humility, restraint and simplicity, its practice governed by a set of highly ritualized actions. But this smooth and creamy matcha-based beverage can be enjoyed any way you like. So by all means, slurp away if you want to.',
          ),

          CustomMenuCard(
              imageName: 'assets/Others/MangoPassionFruit.png',
              title: 'Mango Passion',
              price: 4.90,
              description: 'Experience our heavenly Mango Passionfruit Cold Foam Shaken Iced Black Tea—a delightful twist on the classic Iced Shaken Black Tea. Honey, mango, passionfruit, and velvety nonfat milk Cold Foam create a texture-filled delight. Tea lovers, this one''s for you!',
          ),

        ],
      ),
    );
  }
}
