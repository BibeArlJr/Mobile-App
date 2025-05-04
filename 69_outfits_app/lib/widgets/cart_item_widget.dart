import 'package:flutter/material.dart';
import '../data/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final p = cartItem.product;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(p.imageUrls.first, width: 56, height: 56),
        title: Text(p.name),
        subtitle: Text('Size: ${cartItem.size}, Color: ${cartItem.color}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: onDecrement,
            ),
            Text('$quantity'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onIncrement,
            ),
          ],
        ),
      ),
    );
  }
}
