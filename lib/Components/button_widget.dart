import 'package:fypuser/Color/color.dart';
import 'package:flutter/material.dart';

class ButtonWidget{
  static Widget buttonWidget(String title, onPressed) {
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: const StadiumBorder(),
          primary: const Color(0xFF2192FF),
          elevation: 5,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SecondButtonWidget{
  static Widget buttonWidget(String title, onPressed) {
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: const StadiumBorder(),
          primary: CustomColors.secondaryColor,
          elevation: 5,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class QuantityButton extends StatefulWidget {
  const QuantityButton({super.key});

  @override
  _QuantityButtonState createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: _decrement,
        ),
        Text(
          _quantity.toString(),
          style: const TextStyle(fontSize: 20),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _increment,
        ),
      ],
    );
  }
}

