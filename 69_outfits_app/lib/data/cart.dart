import '../models/product.dart';

/// A single line-item in the cart, with its chosen size & color.
class CartItem {
  final Product product;
  final String size;
  final String color;

  CartItem({
    required this.product,
    required this.size,
    required this.color,
  });
}

class Cart {
  final List<CartItem> _items = [];

  /// Unmodifiable view of the items.
  List<CartItem> get items => List.unmodifiable(_items);

  int get count => _items.length;

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.product.price);

  /// Now requires both size & color.
  void addItem(
    Product product, {
    required String size,
    required String color,
  }) {
    _items.add(CartItem(
      product: product,
      size: size,
      color: color,
    ));
  }

  void removeItem(CartItem item) => _items.remove(item);
}

final cart = Cart();
