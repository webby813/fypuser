import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carous extends StatefulWidget {
  const Carous({super.key});

  @override
  State<Carous> createState() => _CarousState();
}

class _CarousState extends State<Carous> {
  int _currentIndex = 0;

  final List<String> _imageList = [
    'assets/Carousel_1.jpg',
    'assets/Carousel_2.jpg',
    'assets/Carousel_3.jpg',
    // Add more image asset paths here
  ];

  @override
  Widget build(BuildContext context) {

    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        enlargeCenterPage: true,
        onPageChanged: (index, _) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: _imageList.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
