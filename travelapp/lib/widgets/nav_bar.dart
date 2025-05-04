import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, 0, 'assets/icons/home_icon.png', '/home'),
          _navItem(context, 1, 'assets/icons/location_icon.png', '/list'),
          _navItem(context, 2, 'assets/icons/cart_icon.png', '/cart'),
          _navItem(context, 3, 'assets/icons/profile_icon.png', '/profile'),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, String iconPath, String route) {
    return GestureDetector(
      onTap: () {
        if (index != currentIndex) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Image.asset(
          iconPath,
          width: 36,
          height: 36,
          color: index == currentIndex ? Colors.blue : null,
        ),
      ),
    );
  }
}
