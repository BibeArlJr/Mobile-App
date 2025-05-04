import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/place.dart';
import '../providers/place_provider.dart';
import '../widgets/nav_bar.dart';
import '../widgets/place_card.dart';
import '../widgets/place_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final places = context.watch<PlaceProvider>().places;
    final sorted = List<Place>.from(places)
      ..sort((a, b) => b.rating.compareTo(a.rating));

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Wonderful United Kingdom',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Let's Explore Together",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
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

            // Carousel
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sorted.length,
                itemBuilder: (_, i) => PlaceCard(place: sorted[i]),
              ),
            ),

            // Top Explore
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Explore',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // List
            Expanded(
              child:
                  sorted.isEmpty
                      ? const Center(child: Text('No places available.'))
                      : Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: sorted.length,
                          itemBuilder: (_, i) => PlaceRow(place: sorted[i]),
                        ),
                      ),
            ),

            // Bottom Nav
            const NavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}
