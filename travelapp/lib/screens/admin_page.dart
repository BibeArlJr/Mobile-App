import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_selector/file_selector.dart';

import '../models/place.dart';
import '../providers/place_provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _detailCtrl = TextEditingController();
  final _ratingCtrl = TextEditingController();
  String _selectedCategory = 'Adventure';
  List<String> _images = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locCtrl.dispose();
    _descCtrl.dispose();
    _detailCtrl.dispose();
    _ratingCtrl.dispose();
    super.dispose();
  }

  Future<void> _addPlace() async {
    if (!_formKey.currentState!.validate()) return;

    final newPlace = Place(
      name: _nameCtrl.text.trim(),
      location: _locCtrl.text.trim(),
      category: _selectedCategory,
      description: _descCtrl.text.trim(),
      detail: _detailCtrl.text.trim(),
      rating: double.tryParse(_ratingCtrl.text.trim()) ?? 0.0,
      images: _images,
    );

    await context.read<PlaceProvider>().addPlace(newPlace);
    _clearForm();
  }

  Future<void> _deletePlace(Place p) async {
    await context.read<PlaceProvider>().deletePlace(p);
  }

  void _clearForm() {
    _nameCtrl.clear();
    _locCtrl.clear();
    _descCtrl.clear();
    _detailCtrl.clear();
    _ratingCtrl.clear();
    setState(() => _images = []);
  }

 
Future<void> _pickImages() async {
  // 1) Define a type group for images
  final imageGroup = XTypeGroup(
    label: 'images',
    extensions: ['jpg', 'jpeg', 'png', 'gif'],
  );

  // 2) Open the native “pick files” dialog, allowing multiple selection
  final List<XFile> files = await openFiles(
    acceptedTypeGroups: [imageGroup],
  );

  // 3) If the user picked any, store their paths in your state
  if (files.isNotEmpty) {
    setState(() {
      _images = files.map((xfile) => xfile.path).toList();
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final places = context.watch<PlaceProvider>().places;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.blue[700],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─ Form ─
            Expanded(
              flex: 3,
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_nameCtrl, 'Place Name'),
                        _buildTextField(_locCtrl, 'Location'),
                        _buildDropdown(),
                        _buildTextField(
                          _descCtrl,
                          'Short Description',
                          maxLines: 2,
                        ),
                        _buildTextField(
                          _detailCtrl,
                          'Full Detail',
                          maxLines: 4,
                        ),
                        _buildTextField(
                          _ratingCtrl,
                          'Rating (e.g. 4.8)',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _pickImages,
                          child: const Text('Pick Images'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _addPlace,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          child: const Text(
                            'Add Place',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const Divider(),

            // ─ Table ─
            Expanded(
              flex: 2,
              child:
                  places.isEmpty
                      ? const Center(child: Text('No places yet.'))
                      : Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: places.length,
                          itemBuilder:
                              (_, i) => ListTile(
                                title: Text(places[i].name),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deletePlace(places[i]),
                                ),
                              ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        items:
            [
              'Adventure',
              'Beach',
              'Lake',
              'Mountain',
            ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (v) => setState(() => _selectedCategory = v!),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
