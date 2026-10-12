import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../mock/mock_data.dart';
import '../../models/item_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';

/// Search and Advanced Filter Screen matching SMUCT Figma Screenshot 3
class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Electronics';
  String _selectedStatus = 'Found Only'; // 'All Items', 'Lost Only', 'Found Only'
  String _selectedLocation = 'Library';
  String _selectedDateWindow = 'Past 7 days';

  @override
  void initState() {
    super.initState();
    // Auto-open bottom filter sheet on launch to match figma demo view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFilterModal();
    });
  }

  List<ItemModel> get _searchResults {
    return MockData.items.where((item) {
      final matchesQuery = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' ||
          item.category.toLowerCase().contains(_selectedCategory.toLowerCase());

      final matchesStatus = _selectedStatus == 'All Items' ||
          (_selectedStatus == 'Lost Only' && item.status.toLowerCase() == 'lost') ||
          (_selectedStatus == 'Found Only' && item.status.toLowerCase() == 'found');

      return matchesQuery && matchesCategory && matchesStatus;
    }).toList();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            top: 12,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag indicator handle
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.tune_rounded, color: Color(0xFF0284C7), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Filters',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF0F172A),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _selectedStatus = 'All Items';
                        _selectedCategory = 'All';
                        _selectedLocation = 'All';
                        _selectedDateWindow = 'All';
                      });
                      setState(() {});
                    },
                    child: Text(
                      'Reset',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF0284C7),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 1. REPORT STATUS
              _buildFilterLabel('REPORT STATUS'),
              const SizedBox(height: 8),
              Row(
                children: ['All Items', 'Lost Only', 'Found Only'].map((st) {
                  final isSel = _selectedStatus == st;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setModalState(() => _selectedStatus = st);
                        setState(() => _selectedStatus = st);
                      },
                      child: _buildFilterChip(st, isSel),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // 2. ITEM CATEGORY
              _buildFilterLabel('ITEM CATEGORY'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryFilterChip('Electronics', Icons.laptop_chromebook_rounded, _selectedCategory == 'Electronics', (val) {
                    setModalState(() => _selectedCategory = 'Electronics');
                    setState(() => _selectedCategory = 'Electronics');
                  }),
                  _buildCategoryFilterChip('Keys', Icons.vpn_key_outlined, _selectedCategory == 'Keys', (val) {
                    setModalState(() => _selectedCategory = 'Keys');
                    setState(() => _selectedCategory = 'Keys');
                  }),
                  _buildCategoryFilterChip('Cards & IDs', Icons.badge_outlined, _selectedCategory == 'Cards & IDs', (val) {
                    setModalState(() => _selectedCategory = 'Cards & IDs');
                    setState(() => _selectedCategory = 'Cards & IDs');
                  }),
                  _buildCategoryFilterChip('Accessories', Icons.watch_outlined, _selectedCategory == 'Accessories', (val) {
                    setModalState(() => _selectedCategory = 'Accessories');
                    setState(() => _selectedCategory = 'Accessories');
                  }),
                  _buildCategoryFilterChip('Bags', Icons.work_outline_rounded, _selectedCategory == 'Bags', (val) {
                    setModalState(() => _selectedCategory = 'Bags');
                    setState(() => _selectedCategory = 'Bags');
                  }),
                ],
              ),
              const SizedBox(height: 18),

              // 3. CAMPUS LOCATION
              _buildFilterLabel('CAMPUS LOCATION'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryFilterChip('Library', Icons.account_balance_outlined, _selectedLocation == 'Library', (val) {
                    setModalState(() => _selectedLocation = 'Library');
                    setState(() => _selectedLocation = 'Library');
                  }),
                  _buildCategoryFilterChip('Faculty Hall', Icons.school_outlined, _selectedLocation == 'Faculty Hall', (val) {
                    setModalState(() => _selectedLocation = 'Faculty Hall');
                    setState(() => _selectedLocation = 'Faculty Hall');
                  }),
                  _buildCategoryFilterChip('Sports Center', Icons.fitness_center_outlined, _selectedLocation == 'Sports Center', (val) {
                    setModalState(() => _selectedLocation = 'Sports Center');
                    setState(() => _selectedLocation = 'Sports Center');
                  }),
                  _buildCategoryFilterChip('Cafeteria', Icons.restaurant_outlined, _selectedLocation == 'Cafeteria', (val) {
                    setModalState(() => _selectedLocation = 'Cafeteria');
                    setState(() => _selectedLocation = 'Cafeteria');
                  }),
                ],
              ),
              const SizedBox(height: 18),

              // 4. DATE WINDOW
              _buildFilterLabel('DATE WINDOW'),
              const SizedBox(height: 8),
              Row(
                children: ['Past 24h', 'Past 7 days', 'This Month'].map((dt) {
                  final isSel = _selectedDateWindow == dt;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setModalState(() => _selectedDateWindow = dt);
                        setState(() => _selectedDateWindow = dt);
                      },
                      child: _buildFilterChip(dt, isSel),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Show Results Button
              CustomButton(
                text: 'Show ${_searchResults.length} Results',
                icon: Icons.filter_list_rounded,
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterLabel(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        color: const Color(0xFF64748B),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFF00C6FF), Color(0xFF00E676)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isSelected ? null : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF00C6FF).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          color: isSelected ? Colors.white : const Color(0xFF475569),
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryFilterChip(String label, IconData icon, bool isSelected, Function(bool) onTap) {
    return GestureDetector(
      onTap: () => onTap(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF00C6FF), Color(0xFF00E676)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00C6FF).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? Colors.white : const Color(0xFF475569),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _searchResults;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE0F2FE),
              child: const Icon(Icons.shield_rounded, size: 18, color: Color(0xFF0284C7)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PORTAL', style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 10, fontWeight: FontWeight.w800)),
                Text('SMUCT Lost & Found', style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A)),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                controller: _searchController,
                hintText: 'Search items, tags, buildings...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onFilterTap: _showFilterModal,
              ),
              const SizedBox(height: 14),

              // Results Counter Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Results (${results.length})',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF0F172A),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFilterModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.tune_rounded, size: 14, color: Color(0xFF0284C7)),
                          const SizedBox(width: 4),
                          Text('Filters', style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: results.isEmpty
                    ? EmptyState(
                        title: 'No items found',
                        description: 'Try changing your search terms or resetting filters.',
                        buttonText: 'Reset Search',
                        onButtonPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                            _selectedCategory = 'All';
                            _selectedStatus = 'All Items';
                          });
                        },
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: results.length,
                        itemBuilder: (ctx, idx) {
                          final item = results[idx];
                          return ItemCard(
                            item: item,
                            isGridMode: true,
                            onTap: () => Navigator.pushNamed(context, '/item-detail', arguments: item),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
