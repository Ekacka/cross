import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/app_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> items = [
    'Milk', 'Bread', 'Eggs', 'Tomatoes', 'Cheese',
    'Chicken', 'Coffee', 'Apples', 'Bananas'
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final local = AppLocalizations.of(context)!;

    return AppScaffold(
      currentIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(local.title, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 12),
            Text(local.longPressToRemove),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: local.addItem,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      setState(() {
                        items.add(text);
                        _controller.clear();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isPortrait
                  ? ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    _buildItemCard(context, items[index], index),
              )
                  : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3.5,
                children: List.generate(
                  items.length,
                      (index) => _buildItemCard(context, items[index], index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, String item, int index) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$item tapped!')),
        );
      },
      onLongPress: () {
        setState(() {
          items.removeAt(index);
        });
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: Text(item),
        ),
      ),
    );
  }
}
