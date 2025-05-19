import 'package:hive/hive.dart';
import '../models/item.dart';

class LocalStorageService {
  final Box<Item> _box = Hive.box<Item>('items');

  void addItem(Item item) {
    _box.put(item.id, item);
  }

  List<Item> getAllItems() {
    return _box.values.toList();
  }
}
