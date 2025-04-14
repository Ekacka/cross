import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> items = [];
  List<bool> isItemDone = [];

  @override
  void initState() {
    super.initState();
    // Delay localization access until after build context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final local = AppLocalizations.of(context)!;
      setState(() {
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
        isItemDone = List.filled(items.length, false);
      });
    });
  }

  void _addNewItem(String item) {
    setState(() {
      items.add(item);
      isItemDone.add(false);
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
      isItemDone.removeAt(index);
    });
  }

  void _toggleItemDone(int index) {
    setState(() {
      isItemDone[index] = !isItemDone[index];
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
            hintText:
            AppLocalizations.of(context)?.enterItemName ?? 'Enter item name',
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
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isPortrait = orientation == Orientation.portrait;

    // Show loader while waiting for localization-based initialization
    if (items.isEmpty || isItemDone.length != items.length) {
      return const Center(child: CircularProgressIndicator());
    }

    return AppScaffold(
      currentIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isPortrait
            ? ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildItemCard(context, items[index], index);
          },
        )
            : GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3.5,
          children: items
              .asMap()
              .map((index, item) {
            return MapEntry(
                index, _buildItemCard(context, item, index));
          })
              .values
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, String item, int index) {
    return GestureDetector(
      onLongPress: () {
        _removeItem(index);
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
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
