import 'package:flutter/material.dart';
import '../data/cart.dart';
import '../widgets/cart_item_widget.dart';
import 'payment_screen.dart'; // ← make sure this import exists

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // Group cart.items (List<CartItem>) by product/size/color, summing quantities
    final Map<CartItem, int> counts = {};
    for (var item in cart.items) {
      counts[item] = (counts[item] ?? 0) + 1;
    }
    final entries = counts.entries.toList();
    final subtotal = cart.totalPrice;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1) Cart items list
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (_, i) {
                  final cartItem = entries[i].key;
                  final qty = entries[i].value;
                  return CartItemWidget(
                    cartItem: cartItem,
                    quantity: qty,
                    onIncrement: () => setState(() {
                      cart.addItem(
                        cartItem.product,
                        size: cartItem.size,
                        color: cartItem.color,
                      );
                    }),
                    onDecrement: () => setState(() {
                      cart.removeItem(cartItem);
                    }),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 2) Subtotal row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (${cart.count} items)',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 3) Pay button wrapped in a SizedBox
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentScreen()),
                  );
                },
                child: const Text('Pay', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
