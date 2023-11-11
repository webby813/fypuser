import 'package:flutter/material.dart';
import 'package:fypuser/Components/container_widget.dart';


class Patries extends StatefulWidget {
  const Patries({Key? key}) : super(key: key);

  @override
  State<Patries> createState() => _PatriesState();
}

class _PatriesState extends State<Patries> {
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
              imageName: 'assets/Patries/Croissant.png',
              title: 'Croissant',
              price: 4.90,
            description: 'A buttery and flaky baked croissant, best served with sliced cheese.',
          ),

          CustomMenuCard(
              imageName: 'assets/Patries/PandanRibbonCroissant.png',
              title: 'Ribbon Croissant',
              price: 4.90,
            description: 'Buttery croissant featuring a swirl of apple green ribbon and a luscious filling of coconut pandan cream.',
          ),

          CustomMenuCard(
              imageName: 'assets/Patries/CranberryScone.png',
              title: 'Cranberry Scone',
              price: 4.90,
            description: 'A buttery and sweet quick bread biscuit with dried cranberries - The perfect choice for a light bite.',
          ),

          CustomMenuCard(
              imageName: 'assets/Patries/SnowflakesDonut.png',
              title: 'Snowy Donut',
              price: 4.90,
            description: 'We don’t cut corners on your satisfaction! Our Signature fluffy sugar donut is now in square shape.',
          ),

        ],
      ),
    );
  }
}
