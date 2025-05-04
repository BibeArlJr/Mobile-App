// lib/data/favorites.dart

import '../models/product.dart';

class Favorites {
  // internally hold a list of favorite products
  static final List<Product> _items = [];

  // expose read-only list
  static List<Product> get items => List.unmodifiable(_items);

  // add if not already present
  static void add(Product p) {
    if (!_items.any((e) => e.id == p.id)) {
      _items.add(p);
    }
  }

  // remove by id
  static void remove(Product p) {
    _items.removeWhere((e) => e.id == p.id);
  }

  // toggle favorite state: returns true if added, false if removed
  static bool toggle(Product p) {
    if (contains(p)) {
      remove(p);
      return false;
    } else {
      add(p);
      return true;
    }
  }

  // check membership
  static bool contains(Product p) {
    return _items.any((e) => e.id == p.id);
  }
}
