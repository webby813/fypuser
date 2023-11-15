import 'package:fypuser/Components/tabbar_widget.dart';
import 'package:fypuser/Product_Categories/Cold.dart';
import 'package:fypuser/Product_Categories/Hot.dart';
import 'package:fypuser/Product_Categories/Non_Coffee.dart';
import 'package:fypuser/Product_Categories/Patries.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Components/barTitle_widget.dart';
import 'package:fypuser/Pages/cart.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = [
      const Tab(
          text: 'Hot Coffee'
      ),
      const Tab(
          text: 'Cold Coffee'
      ),
      const Tab(
          text: 'Non-Coffee'
      ),
      const Tab(
          text: 'Patries'
      ),
      // Add more tabs as needed
    ];

    final List<Widget> tabViews = [
      // Add corresponding tab views for each tab
      const HotCoffee(),
      const ColdCoffee(),
      const NonCoffee(),
      const Patries(),
    ];


    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.defaultWhite,
        title: BarTitle.AppBarText('Menu'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: CustomColors.primaryColor
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Cart()));
              // print('Settings action tapped');
            },
          ),
        ],
      ),
      body: DefaultTabController(

        length:tabs.length,
        child: Column(
          children: [
            TabBar(
              tabs: tabs,
              labelColor: CustomColors.primaryColor,
            ),

            Expanded(
              child: TabBarWidget(
                  tabs:tabs,
                  tabViews: tabViews
              ).buildTabBarView(),
            )
          ],
        ),
      ),
    );
  }
}
