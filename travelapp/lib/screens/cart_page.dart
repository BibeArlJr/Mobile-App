import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/place.dart';
import '../providers/place_provider.dart';
import '../widgets/nav_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = true;
  List<Place> _savedTrips = [];

  @override
  void initState() {
    super.initState();
    loadSavedTrips();
  }

  Future<void> loadSavedTrips() async {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    await placeProvider.loadSavedTrips();
    setState(() {
      _savedTrips = placeProvider.savedTrips;
      _isLoading = false;
    });
  }

  Future<void> _deleteTrip(Place place) async {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    await placeProvider.deleteTrip(place);
    await loadSavedTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  // Header
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Your Saved Trips',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Image.asset('assets/icons/profile_icon.png', width: 40, height: 40),
                      ],
                    ),
                  ),

                  // Saved Trips List
                  Expanded(
                    child: _savedTrips.isEmpty
                        ? Center(child: Text('No trips saved yet.'))
                        : ListView.builder(
                            itemCount: _savedTrips.length,
                            itemBuilder: (context, index) {
                              final trip = _savedTrips[index];
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        trip.images.isNotEmpty ? trip.images[0] : '',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trip.name,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            trip.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "⭐ ${trip.rating}",
                                            style: TextStyle(color: Colors.orange),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteTrip(trip);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  // Bottom nav
                  NavBar(currentIndex: 2),
                ],
              ),
            ),
    );
  }
}
