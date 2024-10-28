import 'package:flutter/material.dart';
import 'package:pushadmin/models/offer.dart';

import '../services/admin_notification_service.dart';
import '../services/authservice.dart';
import '../services/database_service.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final AdminNotificationService _notificationService =
      AdminNotificationService();
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _initializedServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (!_authService.isSignedIn()) {
        await _authService.signInAnonymously();
      }

      await _notificationService.initialize();
    } catch (e) {
      _showError("$e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.notification_important))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddOfferDialog(context),
          child: Icon(Icons.add),
        ),
        body: _isLoading
            ? CircularProgressIndicator()
            : StreamBuilder<List<Offer>>(
                stream: _databaseService.getActiveOffers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          SizedBox(height: 16),
                          Text('Error loading offers: ${snapshot.error}'),
                          ElevatedButton(
                            onPressed: () => setState(() {}),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No offers available'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final offer = snapshot.data![index];

                        return ListTile(
                          title: Text("${offer.title}"),
                          subtitle: Text("${offer.description}"),
                        );
                      });
                }));
  }

  Future<void> _showAddOfferDialog(BuildContext context) async {
    if (!_authService.isSignedIn()) {
      await _authService.signInAnonymously();
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await showDialog<Map<String, dynamic>>(
          context: context, builder: (context) => AddOfferDialog());

      if (result != null) {
        final offer = Offer(
          id: '',
          title: result['title'],
          description: result['description'],
          price: result['price'],
          createdAt: DateTime.now(),
          isActive: true,
          category: result['category'],
          imageUrl: result['imageUrl'],
        );

        final savedOffer = await _databaseService.saveOffer(offer);

        _showSuccess('Offer added and notification sent!');
      }
    } catch (e) {
      print("$e");
    }finally{
      setState(() {
        _isLoading=false;
      });
    }
  }
}

class AddOfferDialog extends StatefulWidget {
  const AddOfferDialog({super.key});

  @override
  State<AddOfferDialog> createState() => _AddOfferDialogState();
}

class _AddOfferDialogState extends State<AddOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Offer'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter offer title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter offer description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter description' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter price';
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  hintText: 'Enter offer category (optional)',
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'Enter image URL (optional)',
                  prefixIcon: Icon(Icons.image),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'description': _descriptionController.text,
                'price': double.parse(_priceController.text),
                'category': _categoryController.text.isEmpty
                    ? null
                    : _categoryController.text,
                'imageUrl': _imageUrlController.text.isEmpty
                    ? null
                    : _imageUrlController.text,
              });
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
