import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/place.dart';
import '../providers/place_provider.dart';
import '../widgets/nav_bar.dart';
import '../widgets/place_row.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String selectedCategory = 'All';
  final categories = ['All', 'Adventure', 'Beach', 'Lake', 'Mountain'];

  List<Place> _filter(List<Place> places) {
    if (selectedCategory == 'All') return places;
    return places.where((p) => p.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allPlaces = context.watch<PlaceProvider>().places;
    final filteredPlaces = _filter(allPlaces);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Filter Places',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/icons/profile_icon.png',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),

            // Dropdown
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                value: selectedCategory,
                items:
                    categories
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text('Filter by Category: $v'),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => selectedCategory = val!),
              ),
            ),

            // List
            Expanded(
              child:
                  filteredPlaces.isEmpty
                      ? const Center(child: Text('No places found.'))
                      : Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: filteredPlaces.length,
                          itemBuilder:
                              (_, i) => PlaceRow(place: filteredPlaces[i]),
                        ),
                      ),
            ),

            // Bottom Nav
            const NavBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}
