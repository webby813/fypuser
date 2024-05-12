import 'package:fypuser/Components/container_widget.dart';
import 'package:fypuser/Components/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Components/carousel_slider.dart';
import '../Components/divider_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.all(25)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0),
            height: 250,
            child: const Carous(),
          ),

          const Padding(padding: EdgeInsets.all(20)),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6), // Shadow color with transparency
                    blurRadius: 6.0, // Adjust the blur radius to control the shadow's spread
                    offset: const Offset(0, 3), // Adjust the offset to control the shadow's position
                  ),
                ],
              ),
            ),
          ),

          Container(
            child: SubTitle.subTitle('Must-try list'),
          ),

          const DivideWeight(),
          ///Must-try list, 1
          const Padding(padding: EdgeInsets.all(10)),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                CustomCard(
                    imageName: 'assets/Coffee/Americano.png',
                    title: 'Americano',
                    price: 4.90,
                    description: 'Experience the genuine European-style espresso, blending richness with hot water. Europeans likes to make the caffe americano by adding hot water to espresso, creating a taste akin to American-style brewed coffee, with subtle nuances from fresh espresso shots. Try it firsthand!',
                    selectedCategory: 'd'
                ),

                CustomCard(
                  imageName: 'assets/Coffee/Latte.png',
                  title: 'Latte',
                  price: 4.90,
                  description: 'The coffeehouse classic, a caffe latte, features rich espresso in steamed milk, topped with a light layer of foam. Its timeless appeal lies in its simplicity – bold espresso blended with sweet steamed milk, optionally enhanced with syrup or extra shots for those seeking a personalized touch.',
                    selectedCategory: 'd'
                ),

                CustomCard(
                  imageName: 'assets/Coffee/MatchaColdFoamIcedAmericano.png',
                  title: 'Matcha Americano',
                  price: 4.90,
                  description: 'We brings a dream for coffee and tea enthusiasts to life, reinventing the Iced Americano with an earthy Matcha Cold Foam. Nonfat milk creates a meringue-like topping, adding a smooth layer of intrigue to the classic Iced Americano, blending contrasting yet complementary flavors. Enjoy it cold!',
                    selectedCategory: 'd'
                ),

                CustomCard(
                  imageName: 'assets/Others/MangoPassionFruit.png',
                  title: 'Mango Passion',
                  price: 4.90,
                  description: 'Experience our heavenly Mango Passionfruit Cold Foam Shaken Iced Black Tea—a delightful twist on the classic Iced Shaken Black Tea. Honey, mango, passionfruit, and velvety nonfat milk Cold Foam create a texture-filled delight. Tea lovers, this one''s for you!',
                    selectedCategory: 'd'
                ),


              ],
            ),
          ),


          const Padding(padding: EdgeInsets.all(20)),
          Container(
            child: SubTitle.subTitle('Bities'),
          ),
          const DivideWeight(),

          ///Bities, 2
          const Padding(padding: EdgeInsets.all(10)),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                CustomCard(
                  imageName: 'assets/Patries/Croissant.png',
                  title: 'Croissant',
                  price: 4.90,
                  description: 'A buttery and flaky baked croissant, best served with sliced cheese.',
                    selectedCategory: 'd'
                ),

                CustomCard(
                  imageName: 'assets/Patries/PandanRibbonCroissant.png',
                  title: 'Ribbon Croissant',
                  price: 4.90,
                  description: 'Buttery croissant featuring a swirl of apple green ribbon and a luscious filling of coconut pandan cream.',
                    selectedCategory: 'd'
                ),

                CustomCard(
                  imageName: 'assets/Patries/CranberryScone.png',
                  title: 'Cranberry Scone',
                  price: 4.90,
                  description: 'A buttery and sweet quick bread biscuit with dried cranberries - The perfect choice for a light bite.',
                    selectedCategory: 'd'
                ),

                CustomCard(
                  imageName: 'assets/Patries/SnowflakesDonut.png',
                  title: 'Snowy Donut',
                  price: 4.90,
                  description: 'We don’t cut corners on your satisfaction! Our Signature fluffy sugar donut is now in square shape.',
                    selectedCategory: 'd'
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(20)),
        ],
      ),
    );
  }
}
