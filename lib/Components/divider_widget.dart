import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';

class DivideWidget extends StatelessWidget {
  const DivideWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
      child: Divider(
        color: CustomColors.lightGrey,
        thickness: 1,
        indent: 20,
        endIndent: 20,
      ),
    );
  }
}

class DivideWeight extends StatelessWidget {
  const DivideWeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 1,
      child: Divider(
        color: CustomColors.lightGrey,
        thickness: 2,
        indent: 50,
        endIndent: 220,
      ),
    );
  }
}

