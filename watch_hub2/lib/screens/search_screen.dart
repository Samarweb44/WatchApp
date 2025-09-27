import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/watch_model.dart';
import '/screens/product_detail_screen.dart';

class SearchScreen extends SearchDelegate<String> {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  final List<String> premiumBrands = [
    'Rolex',
    'Omega',
    'Tag Heuer', 
    'Samsung',
  ];

  List<String> _productNames = [];
  Future<void>? _loadNamesFuture;

  // Filter states using ValueNotifier for better reactivity
  final ValueNotifier<String?> selectedPriceRangeNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectedBrandNotifier = ValueNotifier<String?>(null);

  SearchScreen() {
    _loadNamesFuture = _loadProductNames();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: theme.iconTheme.copyWith(color: Colors.white),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: Colors.white70,
          fontWeight: FontWeight.w300,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      scaffoldBackgroundColor: Colors.black,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      AnimatedOpacity(
        opacity: query.isNotEmpty ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      ),
      _FilterButton(
        onPressed: () => _showFilterOptions(context),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        // If the search query is empty, close the search screen
        if (query.isEmpty) {
          close(context, '');
        } 
        // If there's a search query, clear it and show suggestions
        else {
          query = '';
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildInitialSuggestions(context);
    }
    return _buildQuerySuggestions(context);
  }

  Widget _buildInitialSuggestions(BuildContext context) {
    return Container(
      color: Colors.black,
      child: FutureBuilder<void>(
        future: _loadNamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingSuggestions(context);
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    "Premium Collections",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Color(0xFFD4AF37), // Gold color
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildBrandCarousel(context),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    "Popular Models",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildPopularSuggestionsList(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPopularSuggestionsList(BuildContext context) {
    final popularSuggestions = _productNames.take(5).toList();
    if (popularSuggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: popularSuggestions.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Icon(Icons.watch_outlined, color: Color(0xFFD4AF37)),
            title: Text(
              popularSuggestions[index],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            onTap: () {
              query = popularSuggestions[index];
              showResults(context);
            },
          ),
        );
      },
    );
  }

  Widget _buildQuerySuggestions(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadNamesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingSuggestions(context);
        }

        final suggestions = _getSuggestions();

        if (suggestions.isEmpty) {
          return _buildNoSuggestions(context);
        }

        return Container(
          color: Colors.black,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.search, color: Color(0xFFD4AF37)),
                  ),
                  title: Text(
                    suggestions[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  onTap: () {
                    query = suggestions[index];
                    showResults(context);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBrandCarousel(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: premiumBrands.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                query = premiumBrands[index];
                showResults(context);
              },
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.grey[850]!, Colors.grey[900]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFD4AF37).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    premiumBrands[index],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _getSuggestions() {
    final searchTerm = query.toLowerCase();

    final brandMatches = premiumBrands
        .where((brand) => brand.toLowerCase().contains(searchTerm))
        .toList();

    final productMatches = _productNames
        .where((name) => name.toLowerCase().contains(searchTerm))
        .toList();

    final combined = <String>{...brandMatches, ...productMatches}.toList();
    return combined;
  }

  Widget _buildLoadingSuggestions(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFFD4AF37),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading luxury collection...",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSuggestions(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            'No suggestions found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or explore brands.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _buildFilteredQuery().snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingResults(context);
          }

          if (snapshot.hasError) {
            return _buildErrorResults(context);
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildNoResults(context);
          }

          return _buildResultsGrid(context, snapshot.data!.docs);
        },
      ),
    );
  }

  Query _buildFilteredQuery() {
    Query currentQuery = productsRef;

    // Apply search query
    if (query.isNotEmpty) {
      currentQuery = currentQuery.where(
        'searchKeywords', 
        arrayContains: query.toLowerCase(),
      );
    }

    // Apply price range filter
    if (selectedPriceRangeNotifier.value != null) {
      switch (selectedPriceRangeNotifier.value) {
        case 'Under \$500':
          currentQuery = currentQuery.where('price', isLessThanOrEqualTo: 500);
          break;
        case '\$500 - \$2000':
          currentQuery = currentQuery
              .where('price', isGreaterThanOrEqualTo: 500)
              .where('price', isLessThanOrEqualTo: 2000);
          break;
        case '\$2000 - \$5000':
          currentQuery = currentQuery
              .where('price', isGreaterThanOrEqualTo: 2000)
              .where('price', isLessThanOrEqualTo: 5000);
          break;
        case 'Over \$5000':
          currentQuery = currentQuery.where('price', isGreaterThan: 5000);
          break;
      }
    }

    // Apply brand filter
    if (selectedBrandNotifier.value != null && selectedBrandNotifier.value != 'All Brands') {
      currentQuery = currentQuery.where('brand', isEqualTo: selectedBrandNotifier.value);
    }

    return currentQuery;
  }

  Widget _buildLoadingResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFFD4AF37),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Finding luxury timepieces...",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            'Error loading collection',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your internet connection.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            'No results for current filters.',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD4AF37),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              elevation: 4,
            ),
            onPressed: () {
              selectedPriceRangeNotifier.value = null;
              selectedBrandNotifier.value = null;
              query = '';
              showResults(context);
            },
            icon: const Icon(Icons.filter_alt_off, color: Colors.black),
            label: Text(
              'Clear Filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsGrid(BuildContext context, List<QueryDocumentSnapshot> docs) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final product = Watch.fromMap({
          ...docs[index].data() as Map<String, dynamic>,
          'id': docs[index].id
        });

        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Watch product) {
    return GestureDetector(
      onTap: () => _navigateToProductDetail(context, product),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: _buildProductImage(product.imageUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[800],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFFD4AF37),
              ),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[800],
        child: Center(
          child: Icon(
            Icons.watch,
            size: 40,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Watch product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product.toMap()),
      ),
    ).then((_) {
      // This ensures the search screen is still visible when returning from detail
      showResults(context);
    });
  }

  Future<void> _loadProductNames() async {
    try {
      final snapshot = await productsRef
          .limit(100)
          .get(const GetOptions(source: Source.serverAndCache));

      _productNames = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['name'] as String? ?? data['model'] as String? ?? '';
          })
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Error loading product names: $e');
      _productNames = [];
    }
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return ValueListenableBuilder(
                valueListenable: selectedPriceRangeNotifier,
                builder: (context, priceRange, _) {
                  return ValueListenableBuilder(
                    valueListenable: selectedBrandNotifier,
                    builder: (context, brand, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Filter Results',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFD4AF37),
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white70),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          Divider(height: 30, thickness: 1, color: Colors.grey[800]),

                          // Price Range Filter
                          _buildFilterSection(
                            context,
                            title: 'Price Range',
                            options: [
                              'Any',
                              'Under \$500',
                              '\$500 - \$2000',
                              '\$2000 - \$5000',
                              'Over \$5000'
                            ],
                            selectedOption: priceRange,
                            onSelected: (value) {
                              selectedPriceRangeNotifier.value =
                                  value == 'Any' ? null : value;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Brand Filter
                          _buildFilterSection(
                            context,
                            title: 'Brand',
                            options: ['All Brands', ...premiumBrands],
                            selectedOption: brand,
                            onSelected: (value) {
                              selectedBrandNotifier.value =
                                  value == 'All Brands' ? null : value;
                            },
                          ),
                          const SizedBox(height: 30),

                          // Apply and Clear Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: BorderSide(
                                      color: Color(0xFFD4AF37),
                                      width: 2,
                                    ),
                                  ),
                                  onPressed: () {
                                    selectedPriceRangeNotifier.value = null;
                                    selectedBrandNotifier.value = null;
                                    Navigator.pop(context);
                                    showResults(context);
                                  },
                                  child: Text(
                                    'Clear All',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Color(0xFFD4AF37),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFD4AF37),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showResults(context);
                                  },
                                  child: Text(
                                    'Apply Filters',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(
    BuildContext context, {
    required String title,
    required List<String> options,
    String? selectedOption,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedOption == option;
            return ChoiceChip(
              label: Text(
                option,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              selected: isSelected,
              selectedColor: Color(0xFFD4AF37),
              backgroundColor: Colors.grey[800],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Color(0xFFD4AF37) : Colors.grey[700]!,
                  width: 1.5,
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  onSelected(option);
                }
              },
              elevation: isSelected ? 3 : 1,
              shadowColor: isSelected ? Color(0xFFD4AF37).withOpacity(0.3) : Colors.black.withOpacity(0.1),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    selectedPriceRangeNotifier.dispose();
    selectedBrandNotifier.dispose();
    super.dispose();
  }
}

class _FilterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _FilterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.5)),
      ),
      child: IconButton(
        icon: Icon(
          Icons.filter_list,
          color: Color(0xFFD4AF37),
        ),
        onPressed: onPressed,
        tooltip: 'Filter results',
      ),
    );
  }
}////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/models/watch_model.dart';
// import '/screens/product_detail_screen.dart';

// class SearchScreen extends SearchDelegate<String> {
//   final CollectionReference productsRef = FirebaseFirestore.instance.collection(
//     'products',
//   );

//   final List<String> premiumBrands = [
//     'Rolex',
//     'Patek Philippe',
//     'Audemars Piguet',
//     'Omega',
//     'Jaeger-LeCoultre',
//     'Cartier',
//     'Tag Heuer',
//     'Breitling',
//     'Samsung',
//     'Panerai',
//   ];

//   List<String> _productNames = [];
//   Future<void>? _loadNamesFuture;

//   // Filter variables
//   double _minPrice = 0;
//   double _maxPrice = 100000;
//   String? _selectedBrand;
//   String _sortBy = 'price';
//   bool _ascending = false;

//   SearchScreen() {
//     _loadNamesFuture = _loadProductNames();
//   }

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     final theme = Theme.of(context);
//     return theme.copyWith(
//       appBarTheme: AppBarTheme(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         iconTheme: theme.iconTheme.copyWith(color: Colors.black87),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         hintStyle: theme.textTheme.titleMedium?.copyWith(
//           color: Colors.black54,
//           fontWeight: FontWeight.w300,
//         ),
//         border: InputBorder.none,
//         focusedBorder: InputBorder.none,
//         enabledBorder: InputBorder.none,
//         errorBorder: InputBorder.none,
//         disabledBorder: InputBorder.none,
//       ),
//     );
//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       if (query.isNotEmpty)
//         IconButton(
//           icon: const Icon(Icons.clear, color: Colors.black87),
//           onPressed: () {
//             query = '';
//             showSuggestions(context);
//           },
//         ),
//       IconButton(
//         icon: const Icon(Icons.filter_alt, color: Colors.black87),
//         onPressed: () => _showFilterDialog(context),
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back, color: Colors.black87),
//       onPressed: () => close(context, ''),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildSearchResults(context);
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query.isEmpty) {
//       return _buildInitialSuggestions(context);
//     }
//     return _buildQuerySuggestions(context);
//   }

//   Widget _buildInitialSuggestions(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: FutureBuilder<void>(
//         future: _loadNamesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildLoadingSuggestions(context);
//           }

//           return CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 backgroundColor: Colors.white,
//                 pinned: true,
//                 expandedHeight: 120.0,
//                 flexibleSpace: FlexibleSpaceBar(
//                   titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
//                   title: Text(
//                     "Luxury Timepieces",
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       color: Colors.black87,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   background: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.white, Colors.grey[100]!],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 16,
//                   ),
//                   child: Text(
//                     "Premium Collections",
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       color: Colors.black87,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(child: _buildBrandCarousel(context)),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 16,
//                   ),
//                   child: Text(
//                     "Popular Models",
//                     style: Theme.of(
//                       context,
//                     ).textTheme.titleMedium?.copyWith(color: Colors.black54),
//                   ),
//                 ),
//               ),
//               SliverPadding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 sliver: SliverGrid(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     childAspectRatio: 0.75,
//                   ),
//                   delegate: SliverChildBuilderDelegate((context, index) {
//                     return _buildPopularItemPlaceholder(context, index);
//                   }, childCount: 4),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildPopularItemPlaceholder(BuildContext context, int index) {
//     final dummyProducts = [
//       {'brand': 'Rolex', 'name': 'Submariner', 'price': 8999},
//       {'brand': 'Omega', 'name': 'Seamaster', 'price': 5499},
//       {'brand': 'Patek Philippe', 'name': 'Nautilus', 'price': 34999},
//       {'brand': 'Audemars Piguet', 'name': 'Royal Oak', 'price': 28999},
//     ];

//     return GestureDetector(
//       onTap: () {
//         query = dummyProducts[index]['name'] as String;
//         showResults(context);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(12),
//                 ),
//                 child: Container(
//                   color: Colors.grey[100],
//                   child: Center(
//                     child: Icon(Icons.watch, size: 40, color: Colors.grey[400]),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     dummyProducts[index]['brand'] as String,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     dummyProducts[index]['name'] as String,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: Colors.black87,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '\$${dummyProducts[index]['price']}',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: Theme.of(context).primaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuerySuggestions(BuildContext context) {
//     return FutureBuilder<void>(
//       future: _loadNamesFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingSuggestions(context);
//         }

//         final suggestions = _getSuggestions();

//         if (suggestions.isEmpty) {
//           return _buildNoSuggestions(context);
//         }

//         return Container(
//           color: Colors.white,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: suggestions.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 4),
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: ListTile(
//                   leading: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.search,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   title: Text(
//                     suggestions[index],
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
//                   ),
//                   onTap: () {
//                     query = suggestions[index];
//                     showResults(context);
//                   },
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBrandCarousel(BuildContext context) {
//     return SizedBox(
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: premiumBrands.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: InkWell(
//               onTap: () {
//                 query = premiumBrands[index];
//                 showResults(context);
//               },
//               child: Container(
//                 width: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: LinearGradient(
//                     colors: [
//                       Theme.of(context).primaryColor.withOpacity(0.8),
//                       Theme.of(context).primaryColor,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 1,
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       premiumBrands[index],
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   List<String> _getSuggestions() {
//     final searchTerm = query.toLowerCase();

//     final brandMatches = premiumBrands
//         .where((brand) => brand.toLowerCase().contains(searchTerm))
//         .toList();

//     final productMatches = _productNames
//         .where((name) => name.toLowerCase().contains(searchTerm))
//         .toList();

//     return [...brandMatches, ...productMatches];
//   }

//   Widget _buildLoadingSuggestions(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(
//               Theme.of(context).primaryColor,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Loading luxury collection...",
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoSuggestions(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'No matches found',
//             style: Theme.of(
//               context,
//             ).textTheme.titleMedium?.copyWith(color: Colors.black87),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Try different keywords',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: StreamBuilder<QuerySnapshot>(
//         stream: _getFilteredQuery().snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildLoadingResults(context);
//           }

//           if (snapshot.hasError) {
//             debugPrint('Firestore error: ${snapshot.error}');
//             return _buildErrorResults(context, snapshot.error.toString());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return _buildNoResults(context);
//           }

//           return Column(
//             children: [
//               _buildActiveFilters(context),
//               Expanded(child: _buildResultsGrid(context, snapshot.data!.docs)),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Query _getFilteredQuery() {
//     try {
//       Query queryRef = productsRef.where(
//         'searchKeywords',
//         arrayContains: query.toLowerCase(),
//       );

//       // Apply brand filter if selected
//       if (_selectedBrand != null && _selectedBrand!.isNotEmpty) {
//         queryRef = queryRef.where('brand', isEqualTo: _selectedBrand);
//       }

//       // Convert price values to double to match Firestore
//       double minPrice = _minPrice.toDouble();
//       double maxPrice = _maxPrice.toDouble();

//       // Apply price range filter
//       queryRef = queryRef.where('price', isGreaterThanOrEqualTo: minPrice);
//       queryRef = queryRef.where('price', isLessThanOrEqualTo: maxPrice);

//       // Apply sorting - ensure the field exists in your Firestore documents
//       String sortField = _sortBy;
//       if (sortField == 'price' || sortField == 'brand' || sortField == 'name') {
//         queryRef = queryRef.orderBy(sortField, descending: !_ascending);
//       } else {
//         // Default sorting if invalid field is selected
//         queryRef = queryRef.orderBy('price', descending: !_ascending);
//       }

//       // Limit results for better performance
//       queryRef = queryRef.limit(50);

//       return queryRef;
//     } catch (e, stack) {
//       debugPrint('Error creating query: $e');
//       debugPrint(stack.toString());
//       // Return a basic query as fallback
//       return productsRef
//           .where('searchKeywords', arrayContains: query.toLowerCase())
//           .limit(50);
//     }
//   }

//   Widget _buildActiveFilters(BuildContext context) {
//     final hasFilters =
//         _selectedBrand != null ||
//         _minPrice > 0 ||
//         _maxPrice < 100000 ||
//         _sortBy != 'price' ||
//         !_ascending;

//     if (!hasFilters) return const SizedBox.shrink();

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       color: Colors.grey[50],
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: [
//           if (_selectedBrand != null)
//             _buildFilterChip(
//               context,
//               label: 'Brand: $_selectedBrand',
//               onDeleted: () => _removeBrandFilter(context),
//             ),
//           if (_minPrice > 0 || _maxPrice < 100000)
//             _buildFilterChip(
//               context,
//               label: 'Price: \$${_minPrice.toInt()} - \$${_maxPrice.toInt()}',
//               onDeleted: () => _removePriceFilter(context),
//             ),
//           _buildFilterChip(
//             context,
//             label: 'Sort: ${_sortBy.capitalize()} ${_ascending ? '↑' : '↓'}',
//             onDeleted: () => _removeSortFilter(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(
//     BuildContext context, {
//     required String label,
//     required VoidCallback onDeleted,
//   }) {
//     return Chip(
//       label: Text(
//         label,
//         style: Theme.of(
//           context,
//         ).textTheme.bodySmall?.copyWith(color: Colors.black87),
//       ),
//       backgroundColor: Colors.white,
//       shape: StadiumBorder(
//         side: BorderSide(
//           color: Theme.of(context).primaryColor.withOpacity(0.2),
//         ),
//       ),
//       deleteIcon: Icon(
//         Icons.close,
//         size: 16,
//         color: Theme.of(context).primaryColor,
//       ),
//       onDeleted: onDeleted,
//     );
//   }

//   void _removeBrandFilter(BuildContext context) {
//     _selectedBrand = null;
//     showResults(context);
//   }

//   void _removePriceFilter(BuildContext context) {
//     _minPrice = 0;
//     _maxPrice = 100000;
//     showResults(context);
//   }

//   void _removeSortFilter(BuildContext context) {
//     _sortBy = 'price';
//     _ascending = false;
//     showResults(context);
//   }

//   Widget _buildLoadingResults(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(
//               Theme.of(context).primaryColor,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Finding luxury timepieces...",
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorResults(BuildContext context, String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 48, color: Colors.red),
//           const SizedBox(height: 16),
//           Text(
//             'Error loading collection',
//             style: Theme.of(
//               context,
//             ).textTheme.titleMedium?.copyWith(color: Colors.black87),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Text(
//               error,
//               style: Theme.of(
//                 context,
//               ).textTheme.bodySmall?.copyWith(color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () => showResults(context),
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoResults(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'No results for "$query"',
//             style: Theme.of(
//               context,
//             ).textTheme.titleMedium?.copyWith(color: Colors.black87),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Try searching for another model or brand',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//             onPressed: () {
//               query = '';
//               showSuggestions(context);
//             },
//             child: Text(
//               'Browse Collection',
//               style: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.copyWith(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildResultsGrid(
//     BuildContext context,
//     List<QueryDocumentSnapshot> docs,
//   ) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.75,
//       ),
//       itemCount: docs.length,
//       itemBuilder: (context, index) {
//         final product = Watch.fromMap({
//           ...docs[index].data() as Map<String, dynamic>,
//           'id': docs[index].id,
//         });

//         return _buildProductCard(context, product);
//       },
//     );
//   }

//   Widget _buildProductCard(BuildContext context, Watch product) {
//     return GestureDetector(
//       onTap: () => _navigateToProductDetail(context, product),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(12),
//                     ),
//                     child: _buildProductImage(product.imageUrl),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor.withOpacity(0.9),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         '\$${product.price}',
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.brand,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     product.name,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: Colors.black87,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.amber, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         '4.8',
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductImage(String imageUrl) {
//     return Image.network(
//       imageUrl,
//       fit: BoxFit.cover,
//       width: double.infinity,
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return Container(
//           color: Colors.grey[100],
//           child: Center(
//             child: CircularProgressIndicator(
//               value: loadingProgress.expectedTotalBytes != null
//                   ? loadingProgress.cumulativeBytesLoaded /
//                         loadingProgress.expectedTotalBytes!
//                   : null,
//               strokeWidth: 2,
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 Theme.of(context).primaryColor,
//               ),
//             ),
//           ),
//         );
//       },
//       errorBuilder: (_, __, ___) => Container(
//         color: Colors.grey[100],
//         child: Center(
//           child: Icon(Icons.watch, size: 40, color: Colors.grey[400]),
//         ),
//       ),
//     );
//   }

//   Future<void> _showFilterDialog(BuildContext context) async {
//   await showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Filters',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 16),

//                 // Brand Filter
//                 Text(
//                   'Brand',
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 8),
//                 DropdownButtonFormField<String>(
//                   value: _selectedBrand,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                   ),
//                   items: [
//                     const DropdownMenuItem(
//                       value: null,
//                       child: Text('All Brands'),
//                     ),
//                     ...premiumBrands.map((brand) {
//                       return DropdownMenuItem(
//                         value: brand,
//                         child: Text(brand),
//                       );
//                     }).toList(),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedBrand = value;
//                     });
//                   },
//                 ),

//                 const SizedBox(height: 24),

//                 // Price Range
//                 Text(
//                   'Price Range',
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 8),
//                 RangeSlider(
//                   values: RangeValues(_minPrice, _maxPrice),
//                   min: 0,
//                   max: 100000,
//                   divisions: 20,
//                   labels: RangeLabels(
//                     '\$${_minPrice.toInt()}',
//                     '\$${_maxPrice.toInt()}',
//                   ),
//                   onChanged: (values) {
//                     setState(() {
//                       _minPrice = values.start;
//                       _maxPrice = values.end;
//                     });
//                   },
//                 ),

//                 const SizedBox(height: 24),

//                 // Sort By
//                 Text(
//                   'Sort By',
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: _sortBy,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                         items: const [
//                           DropdownMenuItem(
//                             value: 'price',
//                             child: Text('Price'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'brand',
//                             child: Text('Brand'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'name',
//                             child: Text('Name'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             _sortBy = value!;
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     IconButton(
//                       icon: Icon(
//                         _ascending
//                             ? Icons.arrow_upward
//                             : Icons.arrow_downward,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _ascending = !_ascending;
//                         });
//                       },
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // Apply Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       showResults(context);
//                     },
//                     child: Text(
//                       'Apply Filters',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }


//   void _navigateToProductDetail(BuildContext context, Watch product) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             ProductDetailScreen(product: product.toMap()),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = 0.0;
//           const end = 1.0;
//           const curve = Curves.easeInOut;

//           var fadeAnimation = CurvedAnimation(parent: animation, curve: curve);

//           return FadeTransition(opacity: fadeAnimation, child: child);
//         },
//         transitionDuration: const Duration(milliseconds: 500),
//       ),
//     );
//   }

//   Future<void> _loadProductNames() async {
//     try {
//       final snapshot = await productsRef
//           .limit(100)
//           .get(const GetOptions(source: Source.serverAndCache));

//       _productNames = snapshot.docs
//           .map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             return data['b_name'] as String? ?? data['name'] as String? ?? '';
//           })
//           .where((name) => name.isNotEmpty)
//           .toList();
//     } catch (e) {
//       debugPrint('Error loading product names: $e');
//       _productNames = [];
//     }
//   }
// }

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/models/watch_model.dart';
// import '/screens/product_detail_screen.dart';

// class SearchScreen extends SearchDelegate<String> {
//   final CollectionReference productsRef =
//       FirebaseFirestore.instance.collection('products');

//   final List<String> premiumBrands = [
//     'Rolex', 'Patek Philippe', 'Audemars Piguet',
//     'Omega', 'Jaeger-LeCoultre', 'Cartier',
//     'Tag Heuer', 'Breitling', 'Samsung', 'Panerai'
//   ];

//   List<String> _productNames = [];
//   Future<void>? _loadNamesFuture;

//   SearchScreen() {
//     _loadNamesFuture = _loadProductNames();
//   }

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     final theme = Theme.of(context);
//     return theme.copyWith(
//       appBarTheme: AppBarTheme(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         iconTheme: theme.iconTheme.copyWith(color: Colors.black87),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         hintStyle: theme.textTheme.titleMedium?.copyWith(
//           color: Colors.black54,
//           fontWeight: FontWeight.w300,
//         ),
//         border: InputBorder.none,
//         focusedBorder: InputBorder.none,
//         enabledBorder: InputBorder.none,
//         errorBorder: InputBorder.none,
//         disabledBorder: InputBorder.none,
//       ),
//     );
//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       AnimatedOpacity(
//         opacity: query.isNotEmpty ? 1.0 : 0.0,
//         duration: const Duration(milliseconds: 200),
//         child: IconButton(
//           icon: const Icon(Icons.clear, color: Colors.black87),
//           onPressed: () {
//             query = '';
//             showSuggestions(context);
//           },
//         ),
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back, color: Colors.black87),
//       onPressed: () => close(context, ''),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildSearchResults(context);
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query.isEmpty) {
//       return _buildInitialSuggestions(context);
//     }
//     return _buildQuerySuggestions(context);
//   }

//   Widget _buildInitialSuggestions(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: FutureBuilder<void>(
//         future: _loadNamesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildLoadingSuggestions(context);
//           }
//           return CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   child: Text(
//                     "Premium Collections",
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           color: Colors.black87,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: _buildBrandCarousel(context),
//               ),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   child: Text(
//                     "Popular Models",
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Colors.black54,
//                         ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildQuerySuggestions(BuildContext context) {
//     return FutureBuilder<void>(
//       future: _loadNamesFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingSuggestions(context);
//         }
        
//         final suggestions = _getSuggestions();
        
//         if (suggestions.isEmpty) {
//           return _buildNoSuggestions(context);
//         }
        
//         return Container(
//           color: Colors.white,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: suggestions.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(Icons.search, color: Colors.grey[600]),
//                 ),
//                 title: Text(
//                   suggestions[index],
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Colors.black87,
//                       ),
//                 ),
//                 onTap: () {
//                   query = suggestions[index];
//                   showResults(context);
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBrandCarousel(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: premiumBrands.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: InkWell(
//               onTap: () {
//                 query = premiumBrands[index];
//                 showResults(context);
//               },
//               child: Container(
//                 width: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey[300]!),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 3,
//                       offset: const Offset(0, 1),
//                  ), ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     premiumBrands[index],
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Colors.black87,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }


//   List<String> _getSuggestions() {
//     final searchTerm = query.toLowerCase();
    
//     final brandMatches = premiumBrands
//         .where((brand) => brand.toLowerCase().contains(searchTerm))
//         .toList();
    
//     final productMatches = _productNames
//         .where((name) => name.toLowerCase().contains(searchTerm))
//         .toList();
    
//     return [...brandMatches, ...productMatches];
//   }

//   Widget _buildLoadingSuggestions(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 24,
//             height: 24,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 Theme.of(context).primaryColor,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Loading luxury collection...",
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Colors.black54,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoSuggestions(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'No matches found',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   color: Colors.black87,
//                 ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Try different keywords',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Colors.grey[600],
//                 ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: StreamBuilder<QuerySnapshot>(
//         stream: productsRef
//             .where('searchKeywords', arrayContains: query.toLowerCase())
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildLoadingResults(context);
//           }

//           if (snapshot.hasError) {
//             return _buildErrorResults(context);
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return _buildNoResults(context);
//           }

//           return _buildResultsGrid(context, snapshot.data!.docs);
//         },
//       ),
//     );
//   }

//   Widget _buildLoadingResults(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 24,
//             height: 24,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 Theme.of(context).primaryColor,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Finding luxury timepieces...",
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Colors.black54,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorResults(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 48, color: Colors.red),
//           const SizedBox(height: 16),
//           Text(
//             'Error loading collection',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   color: Colors.black87,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoResults(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'No results for "$query"',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   color: Colors.black87,
//                 ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Try searching for another model or brand',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Colors.grey[600],
//                 ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//             onPressed: () {
//               query = '';
//               showSuggestions(context);
//             },
//             child: Text(
//               'Browse Collection',
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: Colors.white,
//                   ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildResultsGrid(BuildContext context, List<QueryDocumentSnapshot> docs) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.75,
//       ),
//       itemCount: docs.length,
//       itemBuilder: (context, index) {
//         final product = Watch.fromMap({
//           ...docs[index].data() as Map<String, dynamic>,
//           'id': docs[index].id
//         });

//         return _buildProductCard(context, product);
//       },
//     );
//   }

//   Widget _buildProductCard(BuildContext context, Watch product) {
//     return GestureDetector(
//       onTap: () => _navigateToProductDetail(context, product),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(12),
//                 ),
//                 child: _buildProductImage(product.imageUrl),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.brand,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Theme.of(context).primaryColor,
//                         ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     product.name,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: Colors.black87,
//                           fontWeight: FontWeight.bold,
//                         ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '\$${product.price}',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: Theme.of(context).primaryColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductImage(String imageUrl) {
//     return Image.network(
//       imageUrl,
//       fit: BoxFit.cover,
//       width: double.infinity,
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return Container(
//           color: Colors.grey[100],
//           child: Center(
//             child: CircularProgressIndicator(
//               value: loadingProgress.expectedTotalBytes != null
//                   ? loadingProgress.cumulativeBytesLoaded /
//                       loadingProgress.expectedTotalBytes!
//                   : null,
//               strokeWidth: 2,
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 Theme.of(context).primaryColor,
//               ),
//             ),
//           ),
//         );
//       },
//       errorBuilder: (_, __, ___) => Container(
//         color: Colors.grey[100],
//         child: Center(
//           child: Icon(
//             Icons.watch,
//             size: 40,
//             color: Colors.grey[400],
//           ),
//         ),
//       ),
//     );
//   }

//   void _navigateToProductDetail(BuildContext context, Watch product) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             ProductDetailScreen(product: product.toMap()),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = 0.0;
//           const end = 1.0;
//           const curve = Curves.easeInOut;
          
//           var fadeAnimation = CurvedAnimation(
//             parent: animation,
//             curve: curve,
//           );
          
//           return FadeTransition(
//             opacity: fadeAnimation,
//             child: child,
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 500),
//      ), );
//   }

//   Future<void> _loadProductNames() async {
//     try {
//       final snapshot = await productsRef
//           .limit(100)
//           .get(const GetOptions(source: Source.serverAndCache));

//       _productNames = snapshot.docs
//           .map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             return data['b_name'] as String? ??
//                 data['name'] as String? ??
//                 '';
//           })
//           .where((name) => name.isNotEmpty)
//           .toList();
//     } catch (e) {
//       debugPrint('Error loading product names: $e');
//       _productNames = [];
//     }
//   }
// }
