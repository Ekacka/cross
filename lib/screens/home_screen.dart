import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart'; // import your reusable scaffold

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> items = const [
    'Milk', 'Bread', 'Eggs', 'Tomatoes', 'Cheese',
    'Chicken', 'Coffee', 'Apples', 'Bananas', 'Rice',
    'Yogurt', 'Pasta'
  ];

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isPortrait = orientation == Orientation.portrait;

    return AppScaffold(
      currentIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isPortrait
            ? ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildItemCard(context, items[index]);
          },
        )
            : GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3.5,
          children: items
              .map((item) => _buildItemCard(context, item))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, String item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.shopping_cart_outlined),
        title: Text(
          item,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: const Icon(Icons.check_box_outline_blank),
      ),
    );
  }
}
