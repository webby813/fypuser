import 'package:fypuser/Components/button_widget.dart';
import 'package:fypuser/Firebase/create_data.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';

class ProductBottomSheet extends StatefulWidget {
  const ProductBottomSheet({
    super.key,
    required this.imageName,
    required this.title,
    required this.price,
    required this.description,
  });

  final String imageName;
  final String title;
  final double price;
  final String description;

  @override
  _ProductBottomSheetState createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(padding: EdgeInsets.all(10)),
                        Tooltip(
                          message: 'This is the description for the image',
                          child: Image.network(
                            widget.imageName,
                            width: 250,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'RM ${widget.price}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        const Align(
                          alignment: FractionalOffset.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Description',
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        Align(
                          alignment: FractionalOffset.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                            child: Text(
                              widget.description,
                              style: const TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 50,
            right: 0,
            bottom: 15,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  iconSize: 30,
                  onPressed: _decrement,
                ),
                Text(
                  _quantity.toString(),
                  style: const TextStyle(
                      fontSize: 30
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  iconSize: 30,
                  onPressed: _increment,
                ),

                const Padding(padding: EdgeInsets.all(16)),
                ButtonWidget.buttonWidget(
                  'Add to cart',
                      () {
                    AddItem().addToCart(context, widget.title, widget.price, _quantity);
                    // Perform the action when the button is pressed
                    // For example, add the product to the cart
                    // Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
