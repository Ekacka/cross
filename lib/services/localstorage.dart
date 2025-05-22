import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/item.dart';

class LocalStorageService {
  late final Box<Item> _box;

  LocalStorageService._(this._box);

  /// Factory constructor to create per-user storage
  static Future<LocalStorageService> getInstance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    final email = user.email?.replaceAll(RegExp(r'[^\w]+'), '_') ?? user.uid;
    final boxName = 'items_$email';
    final box = await Hive.openBox<Item>(boxName);
    return LocalStorageService._(box);
  }

  void addItem(Item item) {
    _box.put(item.id, item);
  }

  List<Item> getAllItems() {
    return _box.values.toList();
  }

  void removeItem(String id) {
    _box.delete(id);
  }

  void clearAll() {
    _box.clear();
  }
}
