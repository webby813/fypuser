
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Components/spinner_widget.dart';
import '../Components/container_widget.dart';
import '../Firebase/retrieve_data.dart';
import '../../Components/title_widget.dart';
import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Components/tabbar_widget.dart';
import 'package:fypuser/Pages/cart.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late List<Tab> _tabs;
  late List<Widget> _tabViews;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await RetrieveData().retrieveCategories();
      setState(() {
        _tabs = categories.map((category) => Tab(text: category)).toList();
        _tabViews = categories.map((category) => _buildTabView(category)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTabView(String selectedCategory) {
    return CategoryWidget(selectedCategory: selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.defaultWhite,
        title: BarTitle.AppBarText('Menu'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: CustomColors.primaryColor),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Cart()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tabs.isNotEmpty && _tabViews.isNotEmpty
          ? DefaultTabController(
        length: _tabs.length,
        child: Column(
          children: [
            TabBar(
              tabs: _tabs.map((tab) => SizedBox(width: 100, child: tab)).toList(),
              labelColor: CustomColors.primaryColor,
              isScrollable: true,
            ),

            Expanded(
              child: TabBarWidget(tabs: _tabs, tabViews: _tabViews).buildTabBarView(),
            )
          ],
        ),
      )
          : const Center(child: Text('Error fetching data')),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String selectedCategory;

  const CategoryWidget({required this.selectedCategory, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .doc(selectedCategory)
            .collection('content')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Spinner.loadingSpinner();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<Widget> itemWidgets = [];
            final items = snapshot.data?.docs;
            if (items != null) {
              for (var item in items) {
                itemWidgets.add(
                  CustomMenuCard(
                    imageName: item['item_picture'], // Assuming 'image' is the field containing the image URL
                    title: item['item_name'],
                    price: double.parse(item['price']),
                    description: item['description'],
                  ),
                );
              }
            }
            return GridView.count(
              primary: false,
              padding: const EdgeInsets.all(10),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              children: itemWidgets,
            );
          }
        },
      ),
    );
  }
}

