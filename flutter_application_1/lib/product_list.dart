import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ProductsAdminScreen extends StatefulWidget {
  const ProductsAdminScreen({super.key});

  @override
  State<ProductsAdminScreen> createState() => _ProductsAdminScreenState();
}

class _ProductsAdminScreenState extends State<ProductsAdminScreen> {
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _features = [];
  final TextEditingController _featureController = TextEditingController();

  // Carousel controllers
  final TextEditingController _carouselTitleController =
      TextEditingController();
  final TextEditingController _carouselSubtitleController =
      TextEditingController();
  final TextEditingController _carouselImageUrlController =
      TextEditingController();

  // State variables
  String? _selectedCategory;
  String? _selectedCarouselCollection;
  Uint8List? _imageBytes;
  Uint8List? _carouselImageBytes;
  bool _isLoading = false;
  List<String> _categories = [];
  List<Map<String, dynamic>> _collections = [];
  bool _useImageUrl = false;
  bool _useCarouselImageUrl = false;
  String? _productId;
  String? _carouselItemId;
  List<String> _selectedCategories = [];
  List<String> _selectedProductIds = [];
  List<Map<String, dynamic>> _availableProducts = [];
  String _searchQuery = '';
  bool _showForm = false;
  bool _showCarouselForm = false;
  bool _isEditing = false;
  bool _isEditingCarousel = false;
  bool _isFeatured = false;

  // Theme Colors
  static const Color _primaryYellow = Color(0xFFFFD700); // Gold-like yellow
  static const Color _onSurfaceBlack = Color(0xFF212121); // Dark black for text
  static const Color _surfaceWhite = Color(0xFFFFFFFF); // Pure white

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadCollections();
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _categories = snapshot.docs
              .map((doc) => doc['category'] as String)
              .toList();
          if (!_isEditing && _categories.isNotEmpty) {
            _selectedCategory = _categories.first;
          }
        });
      }
    } catch (e) {
      _showError('Failed to load categories: $e');
    }
  }

  Future<void> _loadProductsForCategories() async {
    if (_selectedCategories.isEmpty) {
      setState(() => _availableProducts = []);
      return;
    }

    try {
      final query = FirebaseFirestore.instance
          .collection('products')
          .where('category', whereIn: _selectedCategories);

      final snapshot = await query.get();
      setState(() {
        _availableProducts = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          };
        }).toList();
      });
    } catch (e) {
      _showError('Failed to load products: $e');
    }
  }

  Future<void> _loadCollections() async {
    try {
      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .get();

      setState(() {
        _collections = [
          {'id': 'featured', 'name': 'Featured Products'},
          ...categoriesSnapshot.docs.map(
            (doc) => {'id': doc.id, 'name': doc['category']},
          ),
        ];

        if (_collections.isNotEmpty) {
          _selectedCarouselCollection = _collections.first['id'];
        }
      });
    } catch (e) {
      _showError('Failed to load collections: $e');
    }
  }

  Future<void> _pickImage({bool isCarousel = false}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() => _isLoading = true);
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          if (isCarousel) {
            _carouselImageBytes = bytes;
            _useCarouselImageUrl = false;
          } else {
            _imageBytes = bytes;
            _useImageUrl = false;
            _imageUrlController.clear();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to pick image: $e');
    }
  }

  Future<String> _uploadImage(Uint8List bytes) async {
    setState(() => _isLoading = true);
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putData(bytes);
      final taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      _showError('Failed to upload image: $e');
      rethrow;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _brandController.clear();
    _imageUrlController.clear();
    setState(() {
      _imageBytes = null;
      _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
      _productId = null;
      _isEditing = false;
      _useImageUrl = false;
      _isFeatured = false;
      _features.clear();
    });
  }

  void _clearCarouselForm() {
    _carouselTitleController.clear();
    _carouselSubtitleController.clear();
    _carouselImageUrlController.clear();
    setState(() {
      _carouselImageBytes = null;
      _carouselItemId = null;
      _isEditingCarousel = false;
      _useCarouselImageUrl = false;
      _selectedCategories = [];
      _selectedProductIds = [];
      _availableProducts = [];
    });
  }

  void _editProduct(Map<String, dynamic> product) {
    setState(() {
      _productId = product['id'];
      _nameController.text = product['b_name'];
      _descController.text = product['b_desc'];
      _priceController.text = product['price'].toString();
      _brandController.text = product['brand'] ?? '';
      _selectedCategory = product['category'];
      _imageUrlController.text = product['b_img'];
      _useImageUrl = true;
      _isEditing = true;
      _showForm = true;
      _features.clear();
      if (product['features'] != null) {
        _features.addAll(List<String>.from(product['features']));
      }
      _isFeatured = product['isFeatured'] ?? false;
    });
  }

  void _editCarouselItem(Map<String, dynamic> item) {
    setState(() {
      _carouselItemId = item['id'];
      _carouselTitleController.text = item['title'];
      _carouselSubtitleController.text = item['subtitle'];
      _carouselImageUrlController.text = item['imageUrl'];
      _selectedCarouselCollection = item['collectionId'];
      _useCarouselImageUrl = true;
      _isEditingCarousel = true;
      _showCarouselForm = true;
      _selectedCategories = List<String>.from(item['selectedCategories'] ?? []);
      _selectedProductIds = List<String>.from(item['selectedProductIds'] ?? []);
      _loadProductsForCategories();
    });
  }

  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        _features.add(_featureController.text);
        _featureController.clear();
      });
    }
  }

  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if ((_imageBytes == null && !_useImageUrl && _productId == null) || _selectedCategory == null) {
      _showError('Please fill all fields and select an image or provide a URL.');
      return;
    }
    if (_nameController.text.isEmpty || _descController.text.isEmpty || _priceController.text.isEmpty) {
      _showError('Please fill in product name, description, and price.');
      return;
    }
    if (double.tryParse(_priceController.text) == null) {
      _showError('Please enter a valid price.');
      return;
    }


    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      String imageUrl;

      if (!_useImageUrl && _imageBytes != null) {
        imageUrl = await _uploadImage(_imageBytes!);
      } else if (_useImageUrl && _imageUrlController.text.isNotEmpty) {
        imageUrl = _imageUrlController.text;
      } else if (_isEditing && _productId != null) {
        // If editing and no new image/URL is provided, keep existing image
        imageUrl = _imageUrlController.text;
      }
      else {
        _showError('Please provide an image or image URL.');
        return;
      }

      final productData = {
        'b_name': _nameController.text,
        'b_desc': _descController.text,
        'b_img': imageUrl,
        'features': _features,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
        'brand': _brandController.text,
        'isFeatured': _isFeatured,
        'searchKeywords': [
          ..._nameController.text.toLowerCase().split(' '),
          ..._brandController.text.toLowerCase().split(' '),
          if (_selectedCategory != null) ..._selectedCategory!.toLowerCase().split(' '),
        ],
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (_productId == null) {
        await FirebaseFirestore.instance
            .collection('products')
            .add(productData);
        _showSuccess('Product added successfully');
      } else {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(_productId)
            .update(productData);
        _showSuccess('Product updated successfully');
      }

      _clearForm();
      if (!mounted) return;
      setState(() => _showForm = false);
    } catch (e) {
      _showError('Failed to save product: $e');
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitCarouselForm() async {
    if ((_carouselImageBytes == null && !_useCarouselImageUrl && _carouselItemId == null) ||
        _selectedProductIds.isEmpty || _carouselTitleController.text.isEmpty) {
      _showError('Please fill all fields, select at least one product, and provide an image.');
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      String imageUrl;

      if (!_useCarouselImageUrl && _carouselImageBytes != null) {
        imageUrl = await _uploadImage(_carouselImageBytes!);
      } else if (_useCarouselImageUrl && _carouselImageUrlController.text.isNotEmpty) {
        imageUrl = _carouselImageUrlController.text;
      } else if (_isEditingCarousel && _carouselItemId != null) {
        imageUrl = _carouselImageUrlController.text;
      }
      else {
        _showError('Please provide a carousel image or image URL.');
        return;
      }

      final carouselData = {
        'title': _carouselTitleController.text,
        'subtitle': _carouselSubtitleController.text,
        'imageUrl': imageUrl,
        'selectedCategories': _selectedCategories,
        'selectedProductIds': _selectedProductIds,
        'isActive': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (_carouselItemId == null) {
        await FirebaseFirestore.instance
            .collection('carousel_items')
            .add(carouselData);
        _showSuccess('Carousel item added successfully');
      } else {
        await FirebaseFirestore.instance
            .collection('carousel_items')
            .doc(_carouselItemId)
            .update(carouselData);
        _showSuccess('Carousel item updated successfully');
      }

      _clearCarouselForm();
      if (!mounted) return;
      setState(() => _showCarouselForm = false);
    } catch (e) {
      _showError('Failed to save carousel item: $e');
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteProduct(String productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete', style: TextStyle(color: _onSurfaceBlack)),
        content: const Text('Are you sure you want to delete this product?', style: TextStyle(color: _onSurfaceBlack)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: _onSurfaceBlack)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .delete();
        _showSuccess('Product deleted successfully');
      } catch (e) {
        _showError('Failed to delete product: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _deleteCarouselItem(String itemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete', style: TextStyle(color: _onSurfaceBlack)),
        content: const Text(
          'Are you sure you want to delete this carousel item?',
          style: TextStyle(color: _onSurfaceBlack),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: _onSurfaceBlack)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await FirebaseFirestore.instance
            .collection('carousel_items')
            .doc(itemId)
            .delete();
        _showSuccess('Carousel item deleted successfully');
      } catch (e) {
        _showError('Failed to delete carousel item: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Management', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        actions: [
          if (!_showForm && !_showCarouselForm)
            Row(
              children: [
                Tooltip(
                  message: 'Add New Product',
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      _clearForm();
                      setState(() {
                        _showForm = true;
                        _isEditing = false;
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: 'Add New Carousel Item',
                  child: IconButton(
                    icon: const Icon(Icons.slideshow, color: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      _clearCarouselForm();
                      setState(() {
                        _showCarouselForm = true;
                        _isEditingCarousel = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          if (_showForm || _showCarouselForm)
            IconButton(
              icon: const Icon(Icons.close, color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () {
                setState(() {
                  _showForm = false;
                  _showCarouselForm = false;
                });
                _clearForm();
                _clearCarouselForm();
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_primaryYellow)))
          : Column(
              children: [
                if (!_showForm && !_showCarouselForm)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search products',
                        labelStyle: const TextStyle(color: _onSurfaceBlack),
                        prefixIcon: const Icon(Icons.search, color: _onSurfaceBlack),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _onSurfaceBlack),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _primaryYellow, width: 2),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: _onSurfaceBlack),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value.toLowerCase());
                      },
                    ),
                  ),

                if (_showForm) _buildProductForm(),

                if (_showCarouselForm) _buildCarouselForm(),

                if (!_showForm && !_showCarouselForm)
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: _onSurfaceBlack,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: _primaryYellow,
                            tabs: const [
                              Tab(text: 'Products'),
                              Tab(text: 'Carousel Items'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildProductsList(),
                                _buildCarouselItemsList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildProductForm() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Edit Product' : 'Add New Product',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _onSurfaceBlack,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: _onSurfaceBlack),
                  onPressed: () {
                    setState(() => _showForm = false);
                    _clearForm();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Image Selection Toggle
            Row(
              children: [
                const Text('Image Source:', style: TextStyle(color: _onSurfaceBlack)),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('Upload', style: TextStyle(color: _onSurfaceBlack)),
                  selected: !_useImageUrl,
                  selectedColor: _primaryYellow.withOpacity(0.7),
                  backgroundColor: Colors.grey[200],
                  onSelected: (selected) {
                    setState(() => _useImageUrl = !selected);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('URL', style: TextStyle(color: _onSurfaceBlack)),
                  selected: _useImageUrl,
                  selectedColor: _primaryYellow.withOpacity(0.7),
                  backgroundColor: Colors.grey[200],
                  onSelected: (selected) {
                    setState(() => _useImageUrl = selected);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Image Input
            if (!_useImageUrl)
              GestureDetector(
                onTap: () => _pickImage(),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: _imageBytes == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 60, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'Tap to upload image',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        ),
                ),
              ),
            if (_useImageUrl)
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  labelStyle: const TextStyle(color: _onSurfaceBlack),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _onSurfaceBlack),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _primaryYellow, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.link, color: _onSurfaceBlack),
                ),
              ),
            const SizedBox(height: 20),

            // Product Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                labelStyle: const TextStyle(color: _onSurfaceBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _onSurfaceBlack),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primaryYellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: _onSurfaceBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _onSurfaceBlack),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primaryYellow, width: 2),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Price
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: const TextStyle(color: _onSurfaceBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _onSurfaceBlack),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primaryYellow, width: 2),
                ),
                prefixText: '\$ ',
                prefixStyle: const TextStyle(color: _onSurfaceBlack, fontWeight: FontWeight.bold),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Brand
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(
                labelText: 'Brand',
                labelStyle: const TextStyle(color: _onSurfaceBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _onSurfaceBlack),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primaryYellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: const TextStyle(color: _onSurfaceBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _onSurfaceBlack),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primaryYellow, width: 2),
                ),
              ),
              dropdownColor: _surfaceWhite,
              style: const TextStyle(color: _onSurfaceBlack),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 16),

            // Featured Toggle
            SwitchListTile(
              title: const Text('Featured Product', style: TextStyle(color: _onSurfaceBlack)),
              value: _isFeatured,
              onChanged: (value) {
                setState(() {
                  _isFeatured = value;
                });
              },
              activeColor: _primaryYellow,
              inactiveTrackColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),

            // Features List
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Features',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _onSurfaceBlack),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _features.length,
                  itemBuilder: (context, index) {
                    final feature = _features[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      elevation: 1,
                      color: Colors.grey[50],
                      child: ListTile(
                        title: Text(feature, style: const TextStyle(color: _onSurfaceBlack)),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                          onPressed: () => _removeFeature(index),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _featureController,
                  decoration: InputDecoration(
                    labelText: 'Add Feature',
                    labelStyle: const TextStyle(color: _onSurfaceBlack),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _onSurfaceBlack),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _primaryYellow, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_box, color: _primaryYellow),
                      onPressed: _addFeature,
                    ),
                  ),
                  onFieldSubmitted: (_) => _addFeature(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: _primaryYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: Text(
                _isEditing ? 'UPDATE PRODUCT' : 'ADD PRODUCT',
                style: const TextStyle(
                  color: _onSurfaceBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton(
                  onPressed: () => _deleteProduct(_productId!),
                  child: const Text(
                    'DELETE PRODUCT',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselForm() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditingCarousel ? 'Edit Carousel Item' : 'Add Carousel Item',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _onSurfaceBlack,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: _onSurfaceBlack),
                  onPressed: () {
                    setState(() => _showCarouselForm = false);
                    _clearCarouselForm();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Image Selection Toggle
            Row(
              children: [
                const Text('Image Source:', style: TextStyle(color: _onSurfaceBlack)),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('Upload', style: TextStyle(color: _onSurfaceBlack)),
                  selected: !_useCarouselImageUrl,
                  selectedColor: _primaryYellow.withOpacity(0.7),
                  backgroundColor: Colors.grey[200],
                  onSelected: (selected) {
                    setState(() => _useCarouselImageUrl = !selected);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('URL', style: TextStyle(color: _onSurfaceBlack)),
                  selected: _useCarouselImageUrl,
                  selectedColor: _primaryYellow.withOpacity(0.7),
                  backgroundColor: Colors.grey[200],
                  onSelected: (selected) {
                    setState(() => _useCarouselImageUrl = selected);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Image Input
            if (!_useCarouselImageUrl)
              GestureDetector(
                onTap: () => _pickImage(isCarousel: true),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: _carouselImageBytes == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 60, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'Tap to upload image',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _carouselImageBytes!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            if (_useCarouselImageUrl)
              TextFormField(
                controller: _carouselImageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  labelStyle: const TextStyle(color: _onSurfaceBlack),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _onSurfaceBlack),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _primaryYellow, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.link, color: _onSurfaceBlack),
                ),
              ),
            const SizedBox(height: 20),

            // Title
            TextFormField(
              controller: _carouselTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: _onSurfaceBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _onSurfaceBlack),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primaryYellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Subtitle
            TextFormField(
              controller: _carouselSubtitleController,
              decoration: InputDecoration(
                labelText: 'Subtitle',
                labelStyle: const TextStyle(color: _onSurfaceBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _onSurfaceBlack),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primaryYellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Multi-Select
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Categories for Products in Carousel',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _onSurfaceBlack),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    final isSelected = _selectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category, style: TextStyle(color: isSelected ? _onSurfaceBlack : Colors.grey[700])),
                      selected: isSelected,
                      selectedColor: _primaryYellow.withOpacity(0.7),
                      checkmarkColor: _onSurfaceBlack,
                      backgroundColor: Colors.grey[200],
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategories.add(category);
                          } else {
                            _selectedCategories.remove(category);
                            _selectedProductIds.removeWhere((productId) {
                              final product = _availableProducts.firstWhere(
                                (p) => p['id'] == productId,
                                orElse: () => {'category': ''},
                              );
                              return product['category'] == category;
                            });
                          }
                        });
                        _loadProductsForCategories();
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product Selection
            if (_selectedCategories.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Products for Carousel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _onSurfaceBlack),
                  ),
                  const SizedBox(height: 8),
                  if (_availableProducts.isEmpty)
                    const Text('No products found in selected categories.', style: TextStyle(color: Colors.grey)),
                  if (_availableProducts.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _availableProducts.length,
                      itemBuilder: (context, index) {
                        final product = _availableProducts[index];
                        final isSelected = _selectedProductIds.contains(product['id']);
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          elevation: 1,
                          color: Colors.grey[50],
                          child: CheckboxListTile(
                            title: Text(product['b_name'], style: const TextStyle(color: _onSurfaceBlack)),
                            subtitle: Text('\$${product['price']}', style: const TextStyle(color: _onSurfaceBlack)),
                            value: isSelected,
                            onChanged: (selected) {
                              setState(() {
                                if (selected == true) {
                                  _selectedProductIds.add(product['id']);
                                } else {
                                  _selectedProductIds.remove(product['id']);
                                }
                              });
                            },
                            secondary: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product['b_img'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image, color: Colors.grey),
                                    ),
                              ),
                            ),
                            activeColor: _primaryYellow,
                          ),
                        );
                      },
                    ),
                ],
              ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submitCarouselForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: _primaryYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: Text(
                _isEditingCarousel ? 'UPDATE CAROUSEL ITEM' : 'ADD CAROUSEL ITEM',
                style: const TextStyle(
                  color: _onSurfaceBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (_isEditingCarousel)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton(
                  onPressed: () => _deleteCarouselItem(_carouselItemId!),
                  child: const Text(
                    'DELETE CAROUSEL ITEM',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_primaryYellow)));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: _onSurfaceBlack)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found.', style: TextStyle(color: _onSurfaceBlack)));
        }

        final products = snapshot.data!.docs.map((doc) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }).where((product) {
          final name = (product['b_name'] as String? ?? '').toLowerCase();
          final brand = (product['brand'] as String? ?? '').toLowerCase();
          final category = (product['category'] as String? ?? '').toLowerCase();
          return name.contains(_searchQuery) ||
                 brand.contains(_searchQuery) ||
                 category.contains(_searchQuery);
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: _surfaceWhite,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product['b_img'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['b_name'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _onSurfaceBlack),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product['category'] ?? 'N/A',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${product['price'].toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _primaryYellow),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: _primaryYellow),
                      onPressed: () => _editProduct(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteProduct(product['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCarouselItemsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('carousel_items').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_primaryYellow)));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: _onSurfaceBlack)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No carousel items found.', style: TextStyle(color: _onSurfaceBlack)));
        }

        final carouselItems = snapshot.data!.docs.map((doc) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: carouselItems.length,
          itemBuilder: (context, index) {
            final item = carouselItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: _surfaceWhite,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['imageUrl'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _onSurfaceBlack),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle'] ?? 'No subtitle',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Products: ${item['selectedProductIds']?.length ?? 0}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: _primaryYellow),
                      onPressed: () => _editCarouselItem(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteCarouselItem(item['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
///////////////////////////////////////////////////////new work///////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:typed_data';

// class ProductsAdminScreen extends StatefulWidget {
//   const ProductsAdminScreen({super.key});

//   @override
//   State<ProductsAdminScreen> createState() => _ProductsAdminScreenState();
// }

// class _ProductsAdminScreenState extends State<ProductsAdminScreen> {
//   // Form controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _brandController = TextEditingController();
//   final TextEditingController _imageUrlController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//   final List<String> _features = [];
//   final TextEditingController _featureController = TextEditingController();

//   // Carousel controllers
//   final TextEditingController _carouselTitleController =
//       TextEditingController();
//   final TextEditingController _carouselSubtitleController =
//       TextEditingController();
//   final TextEditingController _carouselImageUrlController =
//       TextEditingController();

//   // State variables
//   String? _selectedCategory;
//   String? _selectedCarouselCollection;
//   Uint8List? _imageBytes;
//   Uint8List? _carouselImageBytes;
//   bool _isLoading = false;
//   List<String> _categories = [];
//   List<Map<String, dynamic>> _collections = [];
//   bool _useImageUrl = false;
//   bool _useCarouselImageUrl = false;
//   String? _productId;
//   String? _carouselItemId;
//   List<String> _selectedCategories = [];
//   List<String> _selectedProductIds = [];
//   List<Map<String, dynamic>> _availableProducts = [];
//   String _searchQuery = '';
//   bool _showForm = false;
//   bool _showCarouselForm = false;
//   bool _isEditing = false;
//   bool _isEditingCarousel = false;
//   bool _isFeatured = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//     _loadCollections();
//   }

//   Future<void> _loadCategories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         setState(() {
//           _categories = snapshot.docs
//               .map((doc) => doc['category'] as String)
//               .toList();
//           if (!_isEditing && _categories.isNotEmpty) {
//             _selectedCategory = _categories.first;
//           }
//         });
//       }
//     } catch (e) {
//       _showError('Failed to load categories: $e');
//     }
//   }

//   Future<void> _loadProductsForCategories() async {
//   if (_selectedCategories.isEmpty) {
//     setState(() => _availableProducts = []);
//     return;
//   }

//   try {
//     final query = FirebaseFirestore.instance
//         .collection('products')
//         .where('category', whereIn: _selectedCategories);

//     final snapshot = await query.get();
//     setState(() {
//       _availableProducts = snapshot.docs.map((doc) {
//         return {
//           'id': doc.id,
//           ...doc.data() as Map<String, dynamic>,
//         };
//       }).toList();
//     });
//   } catch (e) {
//     _showError('Failed to load products: $e');
//   }
// }

//   Future<void> _loadCollections() async {
//     try {
//       final categoriesSnapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .get();

//       setState(() {
//         _collections = [
//           {'id': 'featured', 'name': 'Featured Products'},
//           ...categoriesSnapshot.docs.map(
//             (doc) => {'id': doc.id, 'name': doc['category']},
//           ),
//         ];

//         if (_collections.isNotEmpty) {
//           _selectedCarouselCollection = _collections.first['id'];
//         }
//       });
//     } catch (e) {
//       _showError('Failed to load collections: $e');
//     }
//   }

//   Future<void> _pickImage({bool isCarousel = false}) async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//       if (pickedFile != null) {
//         setState(() => _isLoading = true);
//         final bytes = await pickedFile.readAsBytes();
//         setState(() {
//           if (isCarousel) {
//             _carouselImageBytes = bytes;
//             _useCarouselImageUrl = false;
//           } else {
//             _imageBytes = bytes;
//             _useImageUrl = false;
//             _imageUrlController.clear();
//           }
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showError('Failed to pick image: $e');
//     }
//   }

//   Future<String> _uploadImage(Uint8List bytes) async {
//     setState(() => _isLoading = true);
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('product_images')
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//       final uploadTask = storageRef.putData(bytes);
//       final taskSnapshot = await uploadTask;
//       return await taskSnapshot.ref.getDownloadURL();
//     } catch (e) {
//       _showError('Failed to upload image: $e');
//       rethrow;
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   void _clearForm() {
//     _nameController.clear();
//     _descController.clear();
//     _priceController.clear();
//     _brandController.clear();
//     _imageUrlController.clear();
//     setState(() {
//       _imageBytes = null;
//       _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
//       _productId = null;
//       _isEditing = false;
//       _useImageUrl = false;
//       _isFeatured = false;
//       _features.clear();
//     });
//   }

//  void _clearCarouselForm() {
//   _carouselTitleController.clear();
//   _carouselSubtitleController.clear();
//   _carouselImageUrlController.clear();
//   setState(() {
//     _carouselImageBytes = null;
//     _carouselItemId = null;
//     _isEditingCarousel = false;
//     _useCarouselImageUrl = false;
//     _selectedCategories = [];
//     _selectedProductIds = [];
//     _availableProducts = [];
//   });
// }
//   void _editProduct(Map<String, dynamic> product) {
//     setState(() {
//       _productId = product['id'];
//       _nameController.text = product['b_name'];
//       _descController.text = product['b_desc'];
//       _priceController.text = product['price'].toString();
//       _brandController.text = product['brand'] ?? '';
//       _selectedCategory = product['category'];
//       _imageUrlController.text = product['b_img'];
//       _useImageUrl = true;
//       _isEditing = true;
//       _showForm = true;
//       _features.clear();
//       if (product['features'] != null) {
//         _features.addAll(List<String>.from(product['features']));
//       }
//       _isFeatured = product['isFeatured'] ?? false;
//     });
//   }

//   void _editCarouselItem(Map<String, dynamic> item) {
//     setState(() {
//       _carouselItemId = item['id'];
//       _carouselTitleController.text = item['title'];
//       _carouselSubtitleController.text = item['subtitle'];
//       _carouselImageUrlController.text = item['imageUrl'];
//       _selectedCarouselCollection = item['collectionId'];
//       _useCarouselImageUrl = true;
//       _isEditingCarousel = true;
//       _showCarouselForm = true;
//        _selectedCategories = List<String>.from(item['selectedCategories'] ?? []);
//     _selectedProductIds = List<String>.from(item['selectedProductIds'] ?? []);
//      _loadProductsForCategories();
//     });
//   }

//   void _addFeature() {
//     if (_featureController.text.isNotEmpty) {
//       setState(() {
//         _features.add(_featureController.text);
//         _featureController.clear();
//       });
//     }
//   }

//   void _removeFeature(int index) {
//     setState(() {
//       _features.removeAt(index);
//     });
//   }

//   Future<void> _submitForm() async {
//     if ((_imageBytes == null && !_useImageUrl) || _selectedCategory == null) {
//       _showError('Please fill all fields and select an image');
//       return;
//     }

//     if (!mounted) return;
//     setState(() => _isLoading = true);

//     try {
//       String imageUrl;

//       if (!_useImageUrl) {
//         imageUrl = await _uploadImage(_imageBytes!);
//       } else {
//         if (_imageUrlController.text.isEmpty) {
//           _showError('Please provide an image URL');
//           return;
//         }
//         imageUrl = _imageUrlController.text;
//       }

//       final productData = {
//         'b_name': _nameController.text,
//         'b_desc': _descController.text,
//         'b_img': imageUrl,
//         'features': _features,
//         'price': double.parse(_priceController.text),
//         'category': _selectedCategory,
//         'brand': _brandController.text,
//         'isFeatured': _isFeatured,
//         'searchKeywords': [
//           ..._nameController.text.toLowerCase().split(' '),
//           ..._brandController.text.toLowerCase().split(' '),
//           ..._selectedCategory!.toLowerCase().split(' '),
//         ],
//         'updatedAt': FieldValue.serverTimestamp(),
//       };

//       if (_productId == null) {
//         await FirebaseFirestore.instance
//             .collection('products')
//             .add(productData);
//         _showSuccess('Product added successfully');
//       } else {
//         await FirebaseFirestore.instance
//             .collection('products')
//             .doc(_productId)
//             .update(productData);
//         _showSuccess('Product updated successfully');
//       }

//       _clearForm();
//       if (!mounted) return;
//       setState(() => _showForm = false);
//     } catch (e) {
//       _showError('Failed to save product: $e');
//     } finally {
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//     }
//   }

//  Future<void> _submitCarouselForm() async {
//   if ((_carouselImageBytes == null && !_useCarouselImageUrl) || 
//       _selectedProductIds.isEmpty) {
//     _showError('Please fill all fields and select at least one product');
//     return;
//   }

//   if (!mounted) return;
//   setState(() => _isLoading = true);

//   try {
//     String imageUrl;
    
//     if (!_useCarouselImageUrl) {
//       imageUrl = await _uploadImage(_carouselImageBytes!);
//     } else {
//       if (_carouselImageUrlController.text.isEmpty) {
//         _showError('Please provide an image URL');
//         return;
//       }
//       imageUrl = _carouselImageUrlController.text;
//     }

//     final carouselData = {
//       'title': _carouselTitleController.text,
//       'subtitle': _carouselSubtitleController.text,
//       'imageUrl': imageUrl,
//       'selectedCategories': _selectedCategories,
//       'selectedProductIds': _selectedProductIds,
//       'isActive': true,
//       'updatedAt': FieldValue.serverTimestamp(),
//     };

//     if (_carouselItemId == null) {
//       await FirebaseFirestore.instance
//           .collection('carousel_items')
//           .add(carouselData);
//       _showSuccess('Carousel item added successfully');
//     } else {
//       await FirebaseFirestore.instance
//           .collection('carousel_items')
//           .doc(_carouselItemId)
//           .update(carouselData);
//       _showSuccess('Carousel item updated successfully');
//     }

//     _clearCarouselForm();
//     if (!mounted) return;
//     setState(() => _showCarouselForm = false);
//   } catch (e) {
//     _showError('Failed to save carousel item: $e');
//   } finally {
//     if (!mounted) return;
//     setState(() => _isLoading = false);
//   }
// }


//   Future<void> _deleteProduct(String productId) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Delete'),
//         content: const Text('Are you sure you want to delete this product?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       setState(() => _isLoading = true);
//       try {
//         await FirebaseFirestore.instance
//             .collection('products')
//             .doc(productId)
//             .delete();
//         _showSuccess('Product deleted successfully');
//       } catch (e) {
//         _showError('Failed to delete product: $e');
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }

//   Future<void> _deleteCarouselItem(String itemId) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Delete'),
//         content: const Text(
//           'Are you sure you want to delete this carousel item?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       setState(() => _isLoading = true);
//       try {
//         await FirebaseFirestore.instance
//             .collection('carousel_items')
//             .doc(itemId)
//             .delete();
//         _showSuccess('Carousel item deleted successfully');
//       } catch (e) {
//         _showError('Failed to delete carousel item: $e');
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }

//   void _showError(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   void _showSuccess(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.green),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Products Management'),
//         centerTitle: true,
//         actions: [
//           if (!_showForm && !_showCarouselForm)
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () {
//                     _clearForm();
//                     setState(() {
//                       _showForm = true;
//                       _isEditing = false;
//                     });
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.slideshow),
//                   onPressed: () {
//                     _clearCarouselForm();
//                     setState(() {
//                       _showCarouselForm = true;
//                       _isEditingCarousel = false;
//                     });
//                   },
//                 ),
//               ],
//             ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 if (!_showForm && !_showCarouselForm)
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         labelText: 'Search products',
//                         prefixIcon: const Icon(Icons.search),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         suffixIcon: _searchQuery.isNotEmpty
//                             ? IconButton(
//                                 icon: const Icon(Icons.clear),
//                                 onPressed: () {
//                                   _searchController.clear();
//                                   setState(() => _searchQuery = '');
//                                 },
//                               )
//                             : null,
//                       ),
//                       onChanged: (value) {
//                         setState(() => _searchQuery = value.toLowerCase());
//                       },
//                     ),
//                   ),

//                 if (_showForm) _buildProductForm(),

//                 if (_showCarouselForm) _buildCarouselForm(),

//                 if (!_showForm && !_showCarouselForm)
//                   Expanded(
//                     child: DefaultTabController(
//                       length: 2,
//                       child: Column(
//                         children: [
//                           const TabBar(
//                             tabs: [
//                               Tab(text: 'Products'),
//                               Tab(text: 'Carousel Items'),
//                             ],
//                           ),
//                           Expanded(
//                             child: TabBarView(
//                               children: [
//                                 _buildProductsList(),
//                                 _buildCarouselItemsList(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//     );
//   }

//   Widget _buildProductForm() {
//     return Expanded(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _isEditing ? 'Edit Product' : 'Add New Product',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     setState(() => _showForm = false);
//                     _clearForm();
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Image Selection Toggle
//             Row(
//               children: [
//                 const Text('Image Source:'),
//                 const SizedBox(width: 16),
//                 ChoiceChip(
//                   label: const Text('Upload'),
//                   selected: !_useImageUrl,
//                   onSelected: (selected) {
//                     setState(() => _useImageUrl = !selected);
//                   },
//                 ),
//                 const SizedBox(width: 8),
//                 ChoiceChip(
//                   label: const Text('URL'),
//                   selected: _useImageUrl,
//                   onSelected: (selected) {
//                     setState(() => _useImageUrl = selected);
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Image Input
//             if (!_useImageUrl)
//               GestureDetector(
//                 onTap: () => _pickImage(),
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: _imageBytes == null
//                       ? const Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.add_a_photo, size: 50),
//                             SizedBox(height: 8),
//                             Text('Tap to upload image'),
//                           ],
//                         )
//                       : Image.memory(_imageBytes!, fit: BoxFit.cover),
//                 ),
//               ),
//             if (_useImageUrl)
//               TextFormField(
//                 controller: _imageUrlController,
//                 decoration: const InputDecoration(
//                   labelText: 'Image URL',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.link),
//                 ),
//               ),
//             const SizedBox(height: 20),

//             // Product Name
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Product Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Description
//             TextFormField(
//               controller: _descController,
//               decoration: const InputDecoration(
//                 labelText: 'Description',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),

//             // Price
//             TextFormField(
//               controller: _priceController,
//               decoration: const InputDecoration(
//                 labelText: 'Price',
//                 border: OutlineInputBorder(),
//                 prefixText: '\$ ',
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),

//             // Brand
//             TextFormField(
//               controller: _brandController,
//               decoration: const InputDecoration(
//                 labelText: 'Brand',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Category Dropdown
//             DropdownButtonFormField<String>(
//               value: _selectedCategory,
//               decoration: const InputDecoration(
//                 labelText: 'Category',
//                 border: OutlineInputBorder(),
//               ),
//               items: _categories.map((category) {
//                 return DropdownMenuItem(value: category, child: Text(category));
//               }).toList(),
//               onChanged: (value) {
//                 setState(() => _selectedCategory = value);
//               },
//             ),
//             const SizedBox(height: 16),

//             // Featured Toggle
//             SwitchListTile(
//               title: const Text('Featured Product'),
//               value: _isFeatured,
//               onChanged: (value) {
//                 setState(() {
//                   _isFeatured = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),

//             // Features List
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Features',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 ..._features.map((feature) {
//                   final index = _features.indexOf(feature);
//                   return ListTile(
//                     title: Text(feature),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.remove),
//                       onPressed: () => _removeFeature(index),
//                     ),
//                   );
//                 }).toList(),
//                 TextFormField(
//                   controller: _featureController,
//                   decoration: const InputDecoration(
//                     labelText: 'Add Feature',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: _addFeature,
//                   child: const Text('Add Feature'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Submit Button
//             ElevatedButton(
//               onPressed: _submitForm,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: Colors.amber,
//               ),
//               child: Text(
//                 _isEditing ? 'UPDATE PRODUCT' : 'ADD PRODUCT',
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             if (_isEditing)
//               TextButton(
//                 onPressed: () => _deleteProduct(_productId!),
//                 child: const Text(
//                   'DELETE PRODUCT',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//  Widget _buildCarouselForm() {
//   return Expanded(
//     child: SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 _isEditingCarousel ? 'Edit Carousel Item' : 'Add Carousel Item',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () {
//                   setState(() => _showCarouselForm = false);
//                   _clearCarouselForm();
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),

//           // Image Selection Toggle
//           Row(
//             children: [
//               const Text('Image Source:'),
//               const SizedBox(width: 16),
//               ChoiceChip(
//                 label: const Text('Upload'),
//                 selected: !_useCarouselImageUrl,
//                 onSelected: (selected) {
//                   setState(() => _useCarouselImageUrl = !selected);
//                 },
//               ),
//               const SizedBox(width: 8),
//               ChoiceChip(
//                 label: const Text('URL'),
//                 selected: _useCarouselImageUrl,
//                 onSelected: (selected) {
//                   setState(() => _useCarouselImageUrl = selected);
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Image Input
//           if (!_useCarouselImageUrl)
//             GestureDetector(
//               onTap: () => _pickImage(isCarousel: true),
//               child: Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: _carouselImageBytes == null
//                     ? const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.add_a_photo, size: 50),
//                           SizedBox(height: 8),
//                           Text('Tap to upload image'),
//                         ],
//                       )
//                     : Image.memory(
//                         _carouselImageBytes!,
//                         fit: BoxFit.cover,
//                       ),
//               ),
//             ),
//           if (_useCarouselImageUrl)
//             TextFormField(
//               controller: _carouselImageUrlController,
//               decoration: const InputDecoration(
//                 labelText: 'Image URL',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.link),
//               ),
//             ),
//           const SizedBox(height: 20),

//           // Title
//           TextFormField(
//             controller: _carouselTitleController,
//             decoration: const InputDecoration(
//               labelText: 'Title',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Subtitle
//           TextFormField(
//             controller: _carouselSubtitleController,
//             decoration: const InputDecoration(
//               labelText: 'Subtitle',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Category Multi-Select
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Select Categories',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 8,
//                 children: _categories.map((category) {
//                   final isSelected = _selectedCategories.contains(category);
//                   return FilterChip(
//                     label: Text(category),
//                     selected: isSelected,
//                     onSelected: (selected) {
//                       setState(() {
//                         if (selected) {
//                           _selectedCategories.add(category);
//                         } else {
//                           _selectedCategories.remove(category);
//                           // Remove products from unselected categories
//                           _selectedProductIds.removeWhere((productId) {
//                             final product = _availableProducts.firstWhere(
//                               (p) => p['id'] == productId,
//                               orElse: () => {'category': ''},
//                             );
//                             return product['category'] == category;
//                           });
//                         }
//                       });
//                       _loadProductsForCategories();
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Product Selection
//           if (_selectedCategories.isNotEmpty)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Select Products',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 if (_availableProducts.isEmpty)
//                   const Text('No products found in selected categories'),
//                 if (_availableProducts.isNotEmpty)
//                   Column(
//                     children: _availableProducts.map((product) {
//                       final isSelected = _selectedProductIds.contains(product['id']);
//                       return CheckboxListTile(
//                         title: Text(product['b_name']),
//                         subtitle: Text('\$${product['price']}'),
//                         value: isSelected,
//                         onChanged: (selected) {
//                           setState(() {
//                             if (selected == true) {
//                               _selectedProductIds.add(product['id']);
//                             } else {
//                               _selectedProductIds.remove(product['id']);
//                             }
//                           });
//                         },
//                         secondary: ClipRRect(
//                           borderRadius: BorderRadius.circular(4),
//                           child: Image.network(
//                             product['b_img'],
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(Icons.image),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//               ],
//             ),
//           const SizedBox(height: 24),

//           // Submit Button
//           ElevatedButton(
//             onPressed: _submitCarouselForm,
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: Colors.amber,
//             ),
//             child: Text(
//               _isEditingCarousel ? 'UPDATE CAROUSEL ITEM' : 'ADD CAROUSEL ITEM',
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           if (_isEditingCarousel)
//             TextButton(
//               onPressed: () => _deleteCarouselItem(_carouselItemId!),
//               child: const Text(
//                 'DELETE CAROUSEL ITEM',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//         ],
//       ),
//     ),
//   );
// }


//   Widget _buildProductsList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _searchQuery.isEmpty
//           ? FirebaseFirestore.instance
//                 .collection('products')
//                 .orderBy('b_name')
//                 .snapshots()
//           : FirebaseFirestore.instance
//                 .collection('products')
//                 .where('searchKeywords', arrayContains: _searchQuery)
//                 .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final products = snapshot.data!.docs;

//         if (products.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.inventory, size: 64),
//                 const SizedBox(height: 16),
//                 const Text('No products found'),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     _clearForm();
//                     setState(() {
//                       _showForm = true;
//                       _isEditing = false;
//                     });
//                   },
//                   child: const Text('ADD FIRST PRODUCT'),
//                 ),
//               ],
//             ),
//           );
//         }

//         return ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             final product = products[index];
//             final data = product.data() as Map<String, dynamic>;

//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: ListTile(
//                 leading: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     data['b_img'],
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                         const Icon(Icons.image, size: 50),
//                   ),
//                 ),
//                 title: Row(
//                   children: [
//                     Text(
//                       data['b_name'],
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     if (data['isFeatured'] == true)
//                       const Padding(
//                         padding: EdgeInsets.only(left: 8.0),
//                         child: Icon(Icons.star, color: Colors.amber, size: 16),
//                       ),
//                   ],
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('\$${data['price']}'),
//                     Text(data['brand'] ?? 'No brand'),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.amber),
//                   onPressed: () => _editProduct({...data, 'id': product.id}),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildCarouselItemsList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('carousel_items')
//           .orderBy('updatedAt', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final items = snapshot.data!.docs;

//         if (items.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.slideshow, size: 64),
//                 const SizedBox(height: 16),
//                 const Text('No carousel items found'),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     _clearCarouselForm();
//                     setState(() {
//                       _showCarouselForm = true;
//                       _isEditingCarousel = false;
//                     });
//                   },
//                   child: const Text('ADD FIRST CAROUSEL ITEM'),
//                 ),
//               ],
//             ),
//           );
//         }

//         return ListView.builder(
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             final item = items[index];
//             final data = item.data() as Map<String, dynamic>;
//             final collection = _collections.firstWhere(
//               (c) => c['id'] == data['collectionId'],
//               orElse: () => {'name': 'Unknown'},
//             );

//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: ListTile(
//                 leading: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     data['imageUrl'],
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                         const Icon(Icons.image, size: 50),
//                   ),
//                 ),
//                 title: Text(data['title']),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(data['subtitle']),
//                     Text('Links to: ${collection['name']}'),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.amber),
//                   onPressed: () => _editCarouselItem({...data, 'id': item.id}),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descController.dispose();
//     _priceController.dispose();
//     _brandController.dispose();
//     _imageUrlController.dispose();
//     _featureController.dispose();
//     _searchController.dispose();
//     _carouselTitleController.dispose();
//     _carouselSubtitleController.dispose();
//     _carouselImageUrlController.dispose();
//     super.dispose();
//   }
// }
///////////////////////////////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:typed_data';

// class ProductsAdminScreen extends StatefulWidget {
//   const ProductsAdminScreen({super.key});

//   @override
//   State<ProductsAdminScreen> createState() => _ProductsAdminScreenState();
// }

// class _ProductsAdminScreenState extends State<ProductsAdminScreen> {
//   // Form controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _brandController = TextEditingController();
//   final TextEditingController _imageUrlController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//   final List<String> _features = [];
//   final TextEditingController _featureController = TextEditingController();

//   // Carousel controllers
//   final TextEditingController _carouselTitleController = TextEditingController();
//   final TextEditingController _carouselSubtitleController = TextEditingController();
//   final TextEditingController _carouselImageUrlController = TextEditingController();
//   final TextEditingController _carouselProductNameController = TextEditingController();
//   final List<Map<String, dynamic>> _carouselProducts = []; // Changed to store both id and name
  

//   // State variables
//   String? _selectedCategory;
//   Uint8List? _imageBytes;
//   Uint8List? _carouselImageBytes;
//   bool _isLoading = false;
//   List<String> _categories = [];
//   bool _useImageUrl = false;
//   bool _useCarouselImageUrl = false;
//   String? _productId;
//   String? _carouselItemId;
//   String _searchQuery = '';
//   bool _showForm = false;
//   bool _showCarouselForm = false;
//   bool _isEditing = false;
//   bool _isEditingCarousel = false;
//   bool _isFeatured = false;
//   List<Map<String, dynamic>> _allProducts = []; // For product selection

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//     _loadAllProducts();
//   }

//   Future<void> _loadCategories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         setState(() {
//           _categories = snapshot.docs
//               .map((doc) => doc['category'] as String)
//               .toList();
//           if (!_isEditing && _categories.isNotEmpty) {
//             _selectedCategory = _categories.first;
//           }
//         });
//       }
//     } catch (e) {
//       _showError('Failed to load categories: $e');
//     }
//   }

//   Future<void> _loadAllProducts() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .get();

//       setState(() {
//         _allProducts = snapshot.docs.map((doc) {
//           return {
//             'id': doc.id,
//             'name': doc['b_name'],
//             'image': doc['b_img'],
//           };
//         }).toList();
//       });
//     } catch (e) {
//       _showError('Failed to load products: $e');
//     }
//   }

//   Future<void> _pickImage({bool isCarousel = false}) async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//       if (pickedFile != null) {
//         setState(() => _isLoading = true);
//         final bytes = await pickedFile.readAsBytes();
//         setState(() {
//           if (isCarousel) {
//             _carouselImageBytes = bytes;
//             _useCarouselImageUrl = false;
//           } else {
//             _imageBytes = bytes;
//             _useImageUrl = false;
//             _imageUrlController.clear();
//           }
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showError('Failed to pick image: $e');
//     }
//   }

//   Future<String> _uploadImage(Uint8List bytes) async {
//     setState(() => _isLoading = true);
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('product_images')
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//       final uploadTask = storageRef.putData(bytes);
//       final taskSnapshot = await uploadTask;
//       return await taskSnapshot.ref.getDownloadURL();
//     } catch (e) {
//       _showError('Failed to upload image: $e');
//       rethrow;
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   void _clearForm() {
//     _nameController.clear();
//     _descController.clear();
//     _priceController.clear();
//     _brandController.clear();
//     _imageUrlController.clear();
//     setState(() {
//       _imageBytes = null;
//       _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
//       _productId = null;
//       _isEditing = false;
//       _useImageUrl = false;
//       _isFeatured = false;
//       _features.clear();
//     });
//   }

//   void _clearCarouselForm() {
//     _carouselTitleController.clear();
//     _carouselSubtitleController.clear();
//     _carouselImageUrlController.clear();
//     _carouselProductNameController.clear();
//     setState(() {
//       _carouselImageBytes = null;
//       _carouselItemId = null;
//       _isEditingCarousel = false;
//       _useCarouselImageUrl = false;
//       _carouselProducts.clear();
//     });
//   }

//   void _editProduct(Map<String, dynamic> product) {
//     setState(() {
//       _productId = product['id'];
//       _nameController.text = product['b_name'];
//       _descController.text = product['b_desc'];
//       _priceController.text = product['price'].toString();
//       _brandController.text = product['brand'] ?? '';
//       _selectedCategory = product['category'];
//       _imageUrlController.text = product['b_img'];
//       _useImageUrl = true;
//       _isEditing = true;
//       _showForm = true;
//       _features.clear();
//       if (product['features'] != null) {
//         _features.addAll(List<String>.from(product['features']));
//       }
//       _isFeatured = product['isFeatured'] ?? false;
//     });
//   }

//   void _editCarouselItem(Map<String, dynamic> item) {
//     setState(() {
//       _carouselItemId = item['id'];
//       _carouselTitleController.text = item['title'];
//       _carouselSubtitleController.text = item['subtitle'];
//       _carouselImageUrlController.text = item['imageUrl'];
//       _useCarouselImageUrl = true;
//       _isEditingCarousel = true;
//       _showCarouselForm = true;
//       _carouselProducts.clear();
//       if (item['products'] != null) {
//         // Convert list of product references to our format
//         final products = List<Map<String, dynamic>>.from(item['products']);
//         _carouselProducts.addAll(products);
//       }
//     });
//   }

//   void _addFeature() {
//     if (_featureController.text.isNotEmpty) {
//       setState(() {
//         _features.add(_featureController.text);
//         _featureController.clear();
//       });
//     }
//   }

//   void _removeFeature(int index) {
//     setState(() {
//       _features.removeAt(index);
//     });
//   }

//   void _addCarouselProduct(Map<String, dynamic> product) {
//     setState(() {
//       // Check if product already exists
//       if (!_carouselProducts.any((p) => p['id'] == product['id'])) {
//         _carouselProducts.add({
//           'id': product['id'],
//           'name': product['name'],
//           'image': product['image'],
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Added: ${product['name']}'),
//             duration: const Duration(seconds: 1),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${product['name']} already added'),
//             backgroundColor: Colors.orange,
//           ),
//         );
//       }
//     });
//   }

//   void _removeCarouselProduct(int index) {
//     setState(() {
//       _carouselProducts.removeAt(index);
//     });
//   }

//   Future<void> _submitForm() async {
//     if ((_imageBytes == null && !_useImageUrl) || _selectedCategory == null) {
//       _showError('Please fill all fields and select an image');
//       return;
//     }

//     if (!mounted) return;
//     setState(() => _isLoading = true);

//     try {
//       String imageUrl;
      
//       if (!_useImageUrl) {
//         imageUrl = await _uploadImage(_imageBytes!);
//       } else {
//         if (_imageUrlController.text.isEmpty) {
//           _showError('Please provide an image URL');
//           return;
//         }
//         imageUrl = _imageUrlController.text;
//       }

//       final productData = {
//         'b_name': _nameController.text,
//         'b_desc': _descController.text,
//         'b_img': imageUrl,
//         'features': _features,
//         'price': double.parse(_priceController.text),
//         'category': _selectedCategory,
//         'brand': _brandController.text,
//         'isFeatured': _isFeatured,
//         'searchKeywords': [
//           ..._nameController.text.toLowerCase().split(' '),
//           ..._brandController.text.toLowerCase().split(' '),
//           ..._selectedCategory!.toLowerCase().split(' '),
//         ],
//         'updatedAt': FieldValue.serverTimestamp(),
//       };

//       if (_productId == null) {
//         await FirebaseFirestore.instance
//             .collection('products')
//             .add(productData);
//         _showSuccess('Product added successfully');
//       } else {
//         await FirebaseFirestore.instance
//             .collection('products')
//             .doc(_productId)
//             .update(productData);
//         _showSuccess('Product updated successfully');
//       }

//       _clearForm();
//       if (!mounted) return;
//       setState(() {
//         _showForm = false;
//         _loadAllProducts(); // Refresh product list
//       });
//     } catch (e) {
//       _showError('Failed to save product: $e');
//     } finally {
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//     }
//   }

// // In your _submitCarouselForm method, update the carousel data structure:
// Future<void> _submitCarouselForm() async {
//     if ((_carouselImageBytes == null && !_useCarouselImageUrl)) {
//       _showError('Please fill all fields and select an image');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       String imageUrl;
      
//       if (!_useCarouselImageUrl) {
//         imageUrl = await _uploadImage(_carouselImageBytes!);
//       } else {
//         if (_carouselImageUrlController.text.isEmpty) {
//           _showError('Please provide an image URL');
//           return;
//         }
//         imageUrl = _carouselImageUrlController.text;
//       }

//       // Create the carousel data
//       final carouselData = {
//         'title': _carouselTitleController.text,
//         'subtitle': _carouselSubtitleController.text,
//         'imageUrl': imageUrl,
//         'products': _carouselProducts.map((p) => {
//           'id': p['id'],
//           'name': p['name'],
//           'image': p['image'],
//         }).toList(),
//         'productIds': _carouselProducts.map((p) => p['id']).toList(), // Store IDs separately for easy querying
//         'isActive': true,
//         'updatedAt': FieldValue.serverTimestamp(),
//         'collectionId': 'featured', // Or make this configurable
//       };

//       if (_carouselItemId == null) {
//         await FirebaseFirestore.instance
//             .collection('carousel_items')
//             .add(carouselData);
//       } else {
//         await FirebaseFirestore.instance
//             .collection('carousel_items')
//             .doc(_carouselItemId)
//             .update(carouselData);
//       }
      
//       _showSuccess('Carousel item saved successfully');
//       _clearCarouselForm();
//       setState(() => _showCarouselForm = false);
//     } catch (e) {
//       _showError('Failed to save carousel: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _deleteProduct(String productId) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Delete'),
//         content: const Text('Are you sure you want to delete this product?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       setState(() => _isLoading = true);
//       try {
//         await FirebaseFirestore.instance
//             .collection('products')
//             .doc(productId)
//             .delete();
//         _showSuccess('Product deleted successfully');
//         _loadAllProducts(); // Refresh product list
//       } catch (e) {
//         _showError('Failed to delete product: $e');
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }

//   Future<void> _deleteCarouselItem(String itemId) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Delete'),
//         content: const Text('Are you sure you want to delete this carousel item?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       setState(() => _isLoading = true);
//       try {
//         await FirebaseFirestore.instance
//             .collection('carousel_items')
//             .doc(itemId)
//             .delete();
//         _showSuccess('Carousel item deleted successfully');
//       } catch (e) {
//         _showError('Failed to delete carousel item: $e');
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }

//   void _showError(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   void _showSuccess(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.green),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Products Management'),
//         centerTitle: true,
//         actions: [
//           if (!_showForm && !_showCarouselForm)
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () {
//                     _clearForm();
//                     setState(() {
//                       _showForm = true;
//                       _isEditing = false;
//                     });
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.slideshow),
//                   onPressed: () {
//                     _clearCarouselForm();
//                     setState(() {
//                       _showCarouselForm = true;
//                       _isEditingCarousel = false;
//                     });
//                   },
//                 ),
//               ],
//             ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 if (!_showForm && !_showCarouselForm)
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         labelText: 'Search products',
//                         prefixIcon: const Icon(Icons.search),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         suffixIcon: _searchQuery.isNotEmpty
//                             ? IconButton(
//                                 icon: const Icon(Icons.clear),
//                                 onPressed: () {
//                                   _searchController.clear();
//                                   setState(() => _searchQuery = '');
//                                 },
//                               )
//                             : null,
//                       ),
//                       onChanged: (value) {
//                         setState(() => _searchQuery = value.toLowerCase());
//                       },
//                     ),
//                   ),

//                 if (_showForm)
//                   _buildProductForm(),
                
//                 if (_showCarouselForm)
//                   _buildCarouselForm(),

//                 if (!_showForm && !_showCarouselForm)
//                   Expanded(
//                     child: DefaultTabController(
//                       length: 2,
//                       child: Column(
//                         children: [
//                           const TabBar(
//                             tabs: [
//                               Tab(text: 'Products'),
//                               Tab(text: 'Carousel Items'),
//                             ],
//                           ),
//                           Expanded(
//                             child: TabBarView(
//                               children: [
//                                 _buildProductsList(),
//                                 _buildCarouselItemsList(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//     );
//   }

//   Widget _buildProductForm() {
//     return Expanded(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _isEditing ? 'Edit Product' : 'Add New Product',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     setState(() => _showForm = false);
//                     _clearForm();
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Image Selection Toggle
//             Row(
//               children: [
//                 const Text('Image Source:'),
//                 const SizedBox(width: 16),
//                 ChoiceChip(
//                   label: const Text('Upload'),
//                   selected: !_useImageUrl,
//                   onSelected: (selected) {
//                     setState(() => _useImageUrl = !selected);
//                   },
//                 ),
//                 const SizedBox(width: 8),
//                 ChoiceChip(
//                   label: const Text('URL'),
//                   selected: _useImageUrl,
//                   onSelected: (selected) {
//                     setState(() => _useImageUrl = selected);
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Image Input
//             if (!_useImageUrl)
//               GestureDetector(
//                 onTap: () => _pickImage(),
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: _imageBytes == null
//                       ? const Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.add_a_photo, size: 50),
//                             SizedBox(height: 8),
//                             Text('Tap to upload image'),
//                           ],
//                         )
//                       : Image.memory(
//                           _imageBytes!,
//                           fit: BoxFit.cover,
//                         ),
//                 ),
//               ),
//             if (_useImageUrl)
//               TextFormField(
//                 controller: _imageUrlController,
//                 decoration: const InputDecoration(
//                   labelText: 'Image URL',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.link),
//                 ),
//               ),
//             const SizedBox(height: 20),

//             // Product Name
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Product Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Description
//             TextFormField(
//               controller: _descController,
//               decoration: const InputDecoration(
//                 labelText: 'Description',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),

//             // Price
//             TextFormField(
//               controller: _priceController,
//               decoration: const InputDecoration(
//                 labelText: 'Price',
//                 border: OutlineInputBorder(),
//                 prefixText: '\$ ',
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),

//             // Brand
//             TextFormField(
//               controller: _brandController,
//               decoration: const InputDecoration(
//                 labelText: 'Brand',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Category Dropdown
//             DropdownButtonFormField<String>(
//               value: _selectedCategory,
//               decoration: const InputDecoration(
//                 labelText: 'Category',
//                 border: OutlineInputBorder(),
//               ),
//               items: _categories.map((category) {
//                 return DropdownMenuItem(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() => _selectedCategory = value);
//               },
//             ),
//             const SizedBox(height: 16),

//             // Featured Toggle
//             SwitchListTile(
//               title: const Text('Featured Product'),
//               value: _isFeatured,
//               onChanged: (value) {
//                 setState(() {
//                   _isFeatured = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),

//             // Features List
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Features',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 ..._features.map((feature) {
//                   final index = _features.indexOf(feature);
//                   return ListTile(
//                     title: Text(feature),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.remove),
//                       onPressed: () => _removeFeature(index),
//                     ),
//                   );
//                 }).toList(),
//                 TextFormField(
//                   controller: _featureController,
//                   decoration: const InputDecoration(
//                     labelText: 'Add Feature',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: _addFeature,
//                   child: const Text('Add Feature'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Submit Button
//             ElevatedButton(
//               onPressed: _submitForm,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: Colors.amber,
//               ),
//               child: Text(
//                 _isEditing ? 'UPDATE PRODUCT' : 'ADD PRODUCT',
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             if (_isEditing)
//               TextButton(
//                 onPressed: () => _deleteProduct(_productId!),
//                 child: const Text(
//                   'DELETE PRODUCT',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCarouselForm() {
//     return Expanded(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _isEditingCarousel ? 'Edit Carousel Item' : 'Add Carousel Item',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     setState(() => _showCarouselForm = false);
//                     _clearCarouselForm();
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Image Selection Toggle
//             Row(
//               children: [
//                 const Text('Image Source:'),
//                 const SizedBox(width: 16),
//                 ChoiceChip(
//                   label: const Text('Upload'),
//                   selected: !_useCarouselImageUrl,
//                   onSelected: (selected) {
//                     setState(() => _useCarouselImageUrl = !selected);
//                   },
//                 ),
//                 const SizedBox(width: 8),
//                 ChoiceChip(
//                   label: const Text('URL'),
//                   selected: _useCarouselImageUrl,
//                   onSelected: (selected) {
//                     setState(() => _useCarouselImageUrl = selected);
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Image Input
//             if (!_useCarouselImageUrl)
//               GestureDetector(
//                 onTap: () => _pickImage(isCarousel: true),
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: _carouselImageBytes == null
//                       ? const Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.add_a_photo, size: 50),
//                             SizedBox(height: 8),
//                             Text('Tap to upload image'),
//                           ],
//                         )
//                       : Image.memory(
//                           _carouselImageBytes!,
//                           fit: BoxFit.cover,
//                         ),
//                 ),
//               ),
//             if (_useCarouselImageUrl)
//               TextFormField(
//                 controller: _carouselImageUrlController,
//                 decoration: const InputDecoration(
//                   labelText: 'Image URL',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.link),
//                 ),
//               ),
//             const SizedBox(height: 20),

//             // Title
//             TextFormField(
//               controller: _carouselTitleController,
//               decoration: const InputDecoration(
//                 labelText: 'Title',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Subtitle
//             TextFormField(
//               controller: _carouselSubtitleController,
//               decoration: const InputDecoration(
//                 labelText: 'Subtitle',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Products List
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Featured Products',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
                
//                 // Product search and add
//                 Autocomplete<Map<String, dynamic>>(
//                   optionsBuilder: (TextEditingValue textEditingValue) {
//                     if (textEditingValue.text == '') {
//                       return const Iterable<Map<String, dynamic>>.empty();
//                     }
//                     return _allProducts.where((product) => 
//                       product['name'].toLowerCase().contains(textEditingValue.text.toLowerCase())
//                     );
//                   },
//                   displayStringForOption: (option) => option['name'],
//                   fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
//                     return TextField(
//                       controller: controller,
//                       focusNode: focusNode,
//                       decoration: const InputDecoration(
//                         labelText: 'Search and add product',
//                         border: OutlineInputBorder(),
//                         suffixIcon: Icon(Icons.search),
//                       ),
//                     );
//                   },
//                   onSelected: (Map<String, dynamic> selection) {
//                     _addCarouselProduct(selection);
//                   },
//                   optionsViewBuilder: (context, onSelected, options) {
//                     return Align(
//                       alignment: Alignment.topLeft,
//                       child: Material(
//                         elevation: 4.0,
//                         child: SizedBox(
//                           width: 300,
//                           child: ListView.builder(
//                             padding: EdgeInsets.zero,
//                             shrinkWrap: true,
//                             itemCount: options.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               final option = options.elementAt(index);
//                               return ListTile(
//                                 leading: Image.network(
//                                   option['image'],
//                                   width: 40,
//                                   height: 40,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) => 
//                                     const Icon(Icons.image, size: 40),
//                                 ),
//                                 title: Text(option['name']),
//                                 onTap: () {
//                                   onSelected(option);
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),
                
//                 // List of added products
//                 if (_carouselProducts.isEmpty)
//     const Center(
//       child: Text(
//         'No products added yet',
//         style: TextStyle(color: Colors.grey),
//       ),
//     )
//   else
//     ..._carouselProducts.map((product) {
//       final index = _carouselProducts.indexOf(product);
//       return Card(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         child: ListTile(
//           leading: Image.network(
//             product['image'],
//             width: 40,
//             height: 40,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) =>
//                 const Icon(Icons.image, size: 40),
//           ),
//           title: Text(product['name']),
//           trailing: IconButton(
//             icon: const Icon(Icons.remove, color: Colors.red),
//             onPressed: () => _removeCarouselProduct(index),
//           ),
//         ),
//       );
//     }).toList(),
//   ],
//             ),
//             const SizedBox(height: 24),

//             // Submit Button
//             ElevatedButton(
//               onPressed: _submitCarouselForm,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: Colors.amber,
//               ),
//               child: Text(
//                 _isEditingCarousel ? 'UPDATE CAROUSEL ITEM' : 'ADD CAROUSEL ITEM',
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             if (_isEditingCarousel)
//               TextButton(
//                 onPressed: () => _deleteCarouselItem(_carouselItemId!),
//                 child: const Text(
//                   'DELETE CAROUSEL ITEM',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductsList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _searchQuery.isEmpty
//           ? FirebaseFirestore.instance
//                 .collection('products')
//                 .orderBy('b_name')
//                 .snapshots()
//           : FirebaseFirestore.instance
//                 .collection('products')
//                 .where(
//                   'searchKeywords',
//                   arrayContains: _searchQuery,
//                 )
//                 .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         final products = snapshot.data!.docs;

//         if (products.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.inventory, size: 64),
//                 const SizedBox(height: 16),
//                 const Text('No products found'),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     _clearForm();
//                     setState(() {
//                       _showForm = true;
//                       _isEditing = false;
//                     });
//                   },
//                   child: const Text('ADD FIRST PRODUCT'),
//                 ),
//               ],
//             ),
//           );
//         }

//         return ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             final product = products[index];
//             final data = product.data() as Map<String, dynamic>;

//             return Card(
//               margin: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 8,
//               ),
//               child: ListTile(
//                 leading: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     data['b_img'],
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                         const Icon(Icons.image, size: 50),
//                   ),
//                 ),
//                 title: Row(
//                   children: [
//                     Text(
//                       data['b_name'],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     if (data['isFeatured'] == true)
//                       const Padding(
//                         padding: EdgeInsets.only(left: 8.0),
//                         child: Icon(Icons.star, color: Colors.amber, size: 16),
//                       ),
//                   ],
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('\$${data['price']}'),
//                     Text(data['brand'] ?? 'No brand'),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(
//                     Icons.edit,
//                     color: Colors.amber,
//                   ),
//                   onPressed: () => _editProduct({...data, 'id': product.id}),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildCarouselItemsList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('carousel_items')
//           .orderBy('updatedAt', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         final items = snapshot.data!.docs;

//         if (items.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.slideshow, size: 64),
//                 const SizedBox(height: 16),
//                 const Text('No carousel items found'),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     _clearCarouselForm();
//                     setState(() {
//                       _showCarouselForm = true;
//                       _isEditingCarousel = false;
//                     });
//                   },
//                   child: const Text('ADD FIRST CAROUSEL ITEM'),
//                 ),
//               ],
//             ),
//           );
//         }

//         return ListView.builder(
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             final item = items[index];
//             final data = item.data() as Map<String, dynamic>;

//             return Card(
//               margin: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 8,
//               ),
//               child: ListTile(
//                 leading: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     data['imageUrl'],
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                         const Icon(Icons.image, size: 50),
//                   ),
//                 ),
//                 title: Text(data['title']),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(data['subtitle']),
//                     if (data['products'] != null && data['products'].isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 8),
//                           const Text(
//                             'Featured Products:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 4),
//                           Wrap(
//                             spacing: 8,
//                             children: List<Widget>.from(data['products'].map((product) => 
//                               Chip(
//                                 label: Text(product['name']),
//                                 backgroundColor: Colors.amber[100],
//                               )
//                             )),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(
//                     Icons.edit,
//                     color: Colors.amber,
//                   ),
//                   onPressed: () => _editCarouselItem({...data, 'id': item.id}),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descController.dispose();
//     _priceController.dispose();
//     _brandController.dispose();
//     _imageUrlController.dispose();
//     _featureController.dispose();
//     _searchController.dispose();
//     _carouselTitleController.dispose();
//     _carouselSubtitleController.dispose();
//     _carouselImageUrlController.dispose();
//     _carouselProductNameController.dispose();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProductAdminScreen extends StatefulWidget {
//   const ProductAdminScreen({super.key});

//   @override
//   State<ProductAdminScreen> createState() => _ProductAdminScreenState();
// }

// class _ProductAdminScreenState extends State<ProductAdminScreen> {
//   final List<String> curatedCategories = [
//     'Luxury Timepieces',
//     'Sport Watches',
//     'Smart Wearables',
//     'Women',
//     'Kids',
//     'Couples',
//   ];

//   List<Map<String, dynamic>> _products = [];
//   List<Map<String, dynamic>> _filteredProducts = [];
//   TextEditingController searchController = TextEditingController();
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     final snapshot = await FirebaseFirestore.instance.collection('products').get();
//     final data = snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();

//     setState(() {
//       _products = data;
//       _filteredProducts = data;
//       isLoading = false;
//     });
//   }

//   void updateData(String docId, Map<String, dynamic> newData) async {
//     await FirebaseFirestore.instance.collection('products').doc(docId).update(newData);
//     fetchData();
//   }

//   void deleteData(String docId) async {
//     await FirebaseFirestore.instance.collection('products').doc(docId).delete();
//     fetchData();
//   }

//   void deleteDialog(String docId) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Delete Confirmation'),
//         content: const Text('Are you sure you want to delete this product?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           TextButton(
//             onPressed: () {
//               deleteData(docId);
//               Navigator.pop(context);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void showEditDialog(Map<String, dynamic> product) {
//     final bName = TextEditingController(text: product["b_name"]);
//     final bDesc = TextEditingController(text: product["b_desc"]);
//     final bImg = TextEditingController(text: product["b_img"]);
//     final priceController = TextEditingController(text: product["price"].toString());
//     String? selectedCategory = product["cat_id"];

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Edit Product'),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(controller: bName, decoration: const InputDecoration(labelText: 'Product Name')),
//               TextField(controller: bDesc, decoration: const InputDecoration(labelText: 'Description')),
//               TextField(controller: bImg, decoration: const InputDecoration(labelText: 'Image URL')),
//               DropdownButtonFormField<String>(
//                 value: selectedCategory,
//                 decoration: const InputDecoration(labelText: 'Select Category'),
//                 items: curatedCategories.map((category) {
//                   return DropdownMenuItem(
//                     value: category,
//                     child: Text(category),
//                   );
//                 }).toList(),
//                 onChanged: (val) {
//                   selectedCategory = val;
//                 },
//               ),
//               TextField(
//                 controller: priceController,
//                 decoration: const InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               if (bName.text.isEmpty || bDesc.text.isEmpty || bImg.text.isEmpty || priceController.text.isEmpty || selectedCategory == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All fields are required.')));
//                 return;
//               }

//               final price = double.tryParse(priceController.text);
//               if (price == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid price.')));
//                 return;
//               }

//               updateData(product["id"], {
//                 "b_name": bName.text,
//                 "b_desc": bDesc.text,
//                 "b_img": bImg.text,
//                 "price": price,
//                 "cat_id": selectedCategory,
//               });

//               Navigator.pop(context);
//             },
//             child: const Text('Update'),
//           ),
//         ],
//       ),
//     );
//   }

//   void showAddProductDialog() {
//     final bName = TextEditingController();
//     final bDesc = TextEditingController();
//     final bImg = TextEditingController();
//     final priceController = TextEditingController();
//     String? selectedCategory;

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Add New Product'),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(controller: bName, decoration: const InputDecoration(labelText: 'Product Name')),
//               TextField(controller: bDesc, decoration: const InputDecoration(labelText: 'Description')),
//               TextField(controller: bImg, decoration: const InputDecoration(labelText: 'Image URL')),
//               DropdownButtonFormField<String>(
//                 value: selectedCategory,
//                 decoration: const InputDecoration(labelText: 'Select Category'),
//                 items: curatedCategories.map((category) {
//                   return DropdownMenuItem(
//                     value: category,
//                     child: Text(category),
//                   );
//                 }).toList(),
//                 onChanged: (val) {
//                   selectedCategory = val;
//                 },
//               ),
//               TextField(
//                 controller: priceController,
//                 decoration: const InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               if (bName.text.isEmpty || bDesc.text.isEmpty || bImg.text.isEmpty || priceController.text.isEmpty || selectedCategory == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All fields are required.')));
//                 return;
//               }

//               final price = double.tryParse(priceController.text);
//               if (price == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid price.')));
//                 return;
//               }

//               FirebaseFirestore.instance.collection('products').add({
//                 "b_name": bName.text,
//                 "b_desc": bDesc.text,
//                 "b_img": bImg.text,
//                 "price": price,
//                 "cat_id": selectedCategory,
//               });

//               Navigator.pop(context);
//               fetchData();
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }

//   void searchProducts(String query) {
//     setState(() {
//       _filteredProducts = _products
//           .where((product) => product["b_name"]
//               .toString()
//               .toLowerCase()
//               .contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Admin Panel'),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//         actions: [
//           IconButton(onPressed: showAddProductDialog, icon: const Icon(Icons.add)),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: TextField(
//                     controller: searchController,
//                     onChanged: searchProducts,
//                     decoration: const InputDecoration(
//                       labelText: 'Search',
//                       prefixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredProducts.length,
//                     itemBuilder: (context, index) {
//                       final p = _filteredProducts[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         child: ListTile(
//                           leading: p["b_img"] != null
//                               ? CircleAvatar(backgroundImage: NetworkImage(p["b_img"]))
//                               : null,
//                           title: Text(p["b_name"] ?? ""),
//                           subtitle: Text("Price: \$${p["price"]} | Category: ${p["cat_id"]}"),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(onPressed: () => showEditDialog(p), icon: const Icon(Icons.edit)),
//                               IconButton(onPressed: () => deleteDialog(p["id"]), icon: const Icon(Icons.delete)),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
                  
//                 ),    
//                   floatingActionButton: FloatingActionButton(
//         onPressed: showAddCategoryDialog,
//         child: const Icon(Icons.add),
//       ),
//               ],
              
//             ),
//     );
//   }
// }
