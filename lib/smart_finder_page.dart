import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main_scaffold.dart';

class SmartFinderPage extends StatefulWidget {
  const SmartFinderPage({Key? key}) : super(key: key);

  @override
  _SmartFinderPageState createState() => _SmartFinderPageState();
}

class _SmartFinderPageState extends State<SmartFinderPage> {
  final TextEditingController _searchController = TextEditingController();
  Position? _currentPosition;
  bool _isLoading = true;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Recycle Centers', 'Eco-Friendly Shops', 'E-Waste Collection'];
  
  // Sample data for recycling centers and eco-friendly shops
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Green Earth Recycling',
      'address': '123 Eco Street, Green City',
      'type': 'Recycle Centers',
      'rating': 4.5,
      'distance': 1.2,
      'lat': 37.7749,
      'lng': -122.4194,
      'description': 'Accepts all types of e-waste including phones, computers, and appliances.',
      'hours': 'Mon-Fri: 9AM-6PM, Sat: 10AM-4PM',
      'phone': '+1 (555) 123-4567',
      'website': 'https://example.com/greenearth',
    },
    {
      'name': 'EcoTech Solutions',
      'address': '456 Sustainable Ave, Eco Town',
      'type': 'Eco-Friendly Shops',
      'rating': 4.2,
      'distance': 2.5,
      'lat': 37.7850,
      'lng': -122.4300,
      'description': 'Sells refurbished electronics and eco-friendly tech accessories.',
      'hours': 'Mon-Sat: 10AM-7PM, Sun: 11AM-5PM',
      'phone': '+1 (555) 987-6543',
      'website': 'https://example.com/ecotech',
    },
    {
      'name': 'E-Cycle Depot',
      'address': '789 Recycle Road, Green Valley',
      'type': 'E-Waste Collection',
      'rating': 4.8,
      'distance': 3.1,
      'lat': 37.7650,
      'lng': -122.4100,
      'description': 'Specialized in proper disposal of electronic waste with free pickup services.',
      'hours': 'Mon-Fri: 8AM-5PM',
      'phone': '+1 (555) 456-7890',
      'website': 'https://example.com/ecycle',
    },
    {
      'name': 'Sustainable Tech Store',
      'address': '321 Green Blvd, Eco City',
      'type': 'Eco-Friendly Shops',
      'rating': 4.0,
      'distance': 1.8,
      'lat': 37.7700,
      'lng': -122.4250,
      'description': 'Offers eco-friendly tech products and repair services.',
      'hours': 'Mon-Sun: 9AM-8PM',
      'phone': '+1 (555) 789-0123',
      'website': 'https://example.com/sustainabletech',
    },
    {
      'name': 'Community Recycling Center',
      'address': '555 Community Way, Green Heights',
      'type': 'Recycle Centers',
      'rating': 4.3,
      'distance': 2.0,
      'lat': 37.7800,
      'lng': -122.4150,
      'description': 'Community-run recycling center accepting all types of recyclables including e-waste.',
      'hours': 'Tue-Sat: 10AM-5PM',
      'phone': '+1 (555) 234-5678',
      'website': 'https://example.com/communityrecycle',
    },
  ];

  List<Map<String, dynamic>> get filteredLocations {
    if (_selectedFilter == 'All') {
      return _locations;
    } else {
      return _locations.where((location) => location['type'] == _selectedFilter).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, handle accordingly
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
      
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _launchMaps(double lat, double lng, String name) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch maps')),
      );
    }
  }

  void _launchPhone(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone')),
      );
    }
  }

  void _launchWebsite(String website) async {
    if (await canLaunch(website)) {
      await launch(website);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch website')),
      );
    }
  }

  void _showLocationDetails(Map<String, dynamic> location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      location['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      location['type'],
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        location['rating'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${location['distance']} km away',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(location['address']),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(location['description']),
              const SizedBox(height: 16),
              const Text(
                'Hours',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(location['hours']),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _launchMaps(
                      location['lat'],
                      location['lng'],
                      location['name'],
                    ),
                    icon: const Icon(Icons.directions),
                    label: const Text('Directions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _launchPhone(location['phone']),
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _launchWebsite(location['website']),
                    icon: const Icon(Icons.language),
                    label: const Text('Website'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Smart Finder',
      currentIndex: 2,
      body: Column(
        children: [
          // Search and filter bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for recycling centers, eco shops...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.green[100],
                          checkmarkColor: Colors.green[800],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.green[800] : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Map view
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          center: _currentPosition != null
                              ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                              : const LatLng(37.7749, -122.4194), // Default to San Francisco
                          zoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              if (_currentPosition != null)
                                Marker(
                                  width: 40.0,
                                  height: 40.0,
                                  point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                  child: const Icon(
                                    Icons.my_location,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                              ...filteredLocations.map(
                                (location) => Marker(
                                  width: 40.0,
                                  height: 40.0,
                                  point: LatLng(location['lat'], location['lng']),
                                  child: GestureDetector(
                                    onTap: () => _showLocationDetails(location),
                                    child: Icon(
                                      location['type'] == 'Recycle Centers'
                                          ? Icons.recycling
                                          : location['type'] == 'Eco-Friendly Shops'
                                              ? Icons.shopping_bag
                                              : Icons.delete,
                                      color: location['type'] == 'Recycle Centers'
                                          ? Colors.green
                                          : location['type'] == 'Eco-Friendly Shops'
                                              ? Colors.purple
                                              : Colors.orange,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Location list
                      DraggableScrollableSheet(
                        initialChildSize: 0.3,
                        minChildSize: 0.1,
                        maxChildSize: 0.7,
                        builder: (context, scrollController) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: filteredLocations.length + 1, // +1 for the header
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${filteredLocations.length} Locations Found',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Icon(Icons.drag_handle),
                                      ],
                                    ),
                                  );
                                }
                                
                                final location = filteredLocations[index - 1];
                                return ListTile(
                                  onTap: () => _showLocationDetails(location),
                                  leading: CircleAvatar(
                                    backgroundColor: location['type'] == 'Recycle Centers'
                                        ? Colors.green[100]
                                        : location['type'] == 'Eco-Friendly Shops'
                                            ? Colors.purple[100]
                                            : Colors.orange[100],
                                    child: Icon(
                                      location['type'] == 'Recycle Centers'
                                          ? Icons.recycling
                                          : location['type'] == 'Eco-Friendly Shops'
                                              ? Icons.shopping_bag
                                              : Icons.delete,
                                      color: location['type'] == 'Recycle Centers'
                                          ? Colors.green[800]
                                          : location['type'] == 'Eco-Friendly Shops'
                                              ? Colors.purple[800]
                                              : Colors.orange[800],
                                    ),
                                  ),
                                  title: Text(
                                    location['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${location['distance']} km • ${location['type']}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        location['rating'].toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.star, color: Colors.amber, size: 18),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}