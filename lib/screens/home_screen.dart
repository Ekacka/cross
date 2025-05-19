import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../provider/connectivity_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> items = [];
  List<bool> isItemDone = [];
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final local = AppLocalizations.of(context)!;
      items = [
        local.item_milk,
        local.item_bread,
        local.item_eggs,
        local.item_tomatoes,
        local.item_cheese,
        local.item_chicken,
        local.item_coffee,
        local.item_apples,
        local.item_bananas,
        local.item_rice,
        local.item_yogurt,
        local.item_pasta,
      ];
      isItemDone = List.filled(items.length, false, growable: true);
      _initialized = true;
    }
  }

  void _addNewItem(String item) {
    setState(() {
      items.add(item);
      isItemDone.add(false);
    });
  }

  void _removeItem(int index) {
    setState(() {
      if (index >= 0 && index < items.length) {
        items.removeAt(index);
        isItemDone.removeAt(index);
      }
    });
  }

  void _toggleItemDone(int index) {
    setState(() {
      if (index >= 0 && index < isItemDone.length) {
        isItemDone[index] = !isItemDone[index];
      }
    });
  }

  void _showAddItemDialog() {
    String newItem = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.addItem ?? 'Add Item',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        content: TextField(
          autofocus: true,
          onChanged: (value) => newItem = value,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.enterItemName ?? 'Enter item name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newItem.trim().isNotEmpty) {
                _addNewItem(newItem.trim());
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)?.add ?? 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.title ?? 'Shopping List'),
        bottom: !isOnline
            ? PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            color: Colors.red,
            height: 30,
            alignment: Alignment.center,
            child: const Text(
              "You are offline",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isPortrait
            ? ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => _buildItemCard(context, items[index], index),
        )
            : GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3.5,
          children: items
              .asMap()
              .entries
              .map((entry) => _buildItemCard(context, entry.value, entry.key))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isOnline
            ? _showAddItemDialog
            : () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Can't add item while offline")),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Item',
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, String item, int index) {
    return GestureDetector(
      onLongPress: () => _removeItem(index),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          _toggleItemDone(index);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          leading: const Icon(Icons.shopping_cart_outlined),
          title: Text(
            item,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              decoration: isItemDone[index]
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: isItemDone[index]
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank),
        ),
      ),
    );
  }
}
