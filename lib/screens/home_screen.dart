import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../provider/connectivity_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box _userBox;
  List<String> items = [];
  List<bool> isItemDone = [];
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _initUserBox();
    }
  }

  Future<void> _initUserBox() async {
    final user = FirebaseAuth.instance.currentUser;
    final boxName = user != null ? 'shoppingBox_${user.uid}' : 'shoppingBox_guest';
    _userBox = await Hive.openBox(boxName);

    if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline && user != null) {
      await _loadFromFirebaseIfExists();
    }

    _loadItems();
  }

  Future<void> _loadFromFirebaseIfExists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final dbRef = FirebaseDatabase.instance.ref('users/${user.uid}/shoppingList');

    final snapshot = await dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      final firebaseItems = List<String>.from(data['items'] ?? []);
      final firebaseStatus = List<bool>.from(data['status'] ?? []);

      setState(() {
        items = firebaseItems;
        isItemDone = firebaseStatus;
      });
      _saveItemsLocally();
    }
  }

  void _loadItems() {
    final storedItems = _userBox.get('items', defaultValue: []);
    final storedStatus = _userBox.get('status', defaultValue: []);

    if ((storedItems as List).isEmpty) {
      final local = AppLocalizations.of(context)!;
      final defaultItems = [

      ];
      setState(() {
        isItemDone = List<bool>.filled(defaultItems.length, false);
      });
      _saveItemsLocally();
    } else {
      setState(() {
        items = List<String>.from(storedItems);
        isItemDone = List<bool>.from(storedStatus);
      });
    }
  }

  void _saveItemsLocally() {
    _userBox.put('items', items);
    _userBox.put('status', isItemDone);
  }

  Future<void> _syncToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final dbRef = FirebaseDatabase.instance.ref('users/${user.uid}/shoppingList');
    await dbRef.update({
      'items': items,
      'status': isItemDone,
    });
  }

  void _addNewItem(String item) {
    setState(() {
      items.add(item);
      isItemDone.add(false);
    });
    _saveItemsLocally();
    if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
      _syncToFirebase();
    }
  }

  void _removeItem(int index) {
    if (index < 0 || index >= items.length) return;
    setState(() {
      items.removeAt(index);
      isItemDone.removeAt(index);
    });
    _saveItemsLocally();
    if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
      _syncToFirebase();
    }
  }

  void _toggleItemDone(int index) {
    if (index < 0 || index >= isItemDone.length) return;
    setState(() {
      isItemDone[index] = !isItemDone[index];
    });
    _saveItemsLocally();
    if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
      _syncToFirebase();
    }
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
          itemBuilder: (context, index) =>
              _buildItemCard(context, items[index], index),
        )
            : GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3.5,
          children: items
              .asMap()
              .entries
              .map((entry) =>
              _buildItemCard(context, entry.value, entry.key))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
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
