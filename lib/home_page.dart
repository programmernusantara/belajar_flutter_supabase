import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Supabase client instance
  final SupabaseClient _supabase = Supabase.instance.client;

  // List to store instruments
  List<Map<String, dynamic>> _instruments = [];

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();

  // Loading state
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInstruments();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Fetch all instruments from Supabase
  Future<void> _fetchInstruments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _supabase
          .from('instruments')
          .select()
          .order('name', ascending: true);

      setState(() {
        _instruments = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load instruments: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // Add a new instrument
  Future<void> _addInstrument() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    try {
      await _supabase.from('instruments').insert({'name': name});
      _nameController.clear();
      await _fetchInstruments(); // Refresh the list
    } catch (e) {
      _showErrorSnackbar('Failed to add instrument: ${e.toString()}');
    }
  }

  // Update an existing instrument
  Future<void> _updateInstrument(int id, String newName) async {
    if (newName.isEmpty) return;

    try {
      await _supabase
          .from('instruments')
          .update({'name': newName})
          .eq('id', id);
      await _fetchInstruments(); // Refresh the list
    } catch (e) {
      _showErrorSnackbar('Failed to update instrument: ${e.toString()}');
    }
  }

  // Delete an instrument
  Future<void> _deleteInstrument(int id) async {
    try {
      await _supabase.from('instruments').delete().eq('id', id);
      await _fetchInstruments(); // Refresh the list
    } catch (e) {
      _showErrorSnackbar('Failed to delete instrument: ${e.toString()}');
    }
  }

  // Show error message as a snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Show dialog for adding a new instrument
  void _showAddDialog() {
    _nameController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Instrument'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Instrument Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addInstrument();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Show dialog for editing an instrument
  void _showEditDialog(Map<String, dynamic> instrument) {
    _nameController.text = instrument['name'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Instrument'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'New Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateInstrument(instrument['id'], _nameController.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Build the list item widget
  Widget _buildInstrumentItem(Map<String, dynamic> instrument) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(instrument['name'], style: const TextStyle(fontSize: 16)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(instrument),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteInstrument(instrument['id']),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrument Manager'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _instruments.isEmpty
          ? const Center(child: Text('No instruments found'))
          : RefreshIndicator(
              onRefresh: _fetchInstruments,
              child: ListView.builder(
                itemCount: _instruments.length,
                itemBuilder: (context, index) =>
                    _buildInstrumentItem(_instruments[index]),
              ),
            ),
    );
  }
}
