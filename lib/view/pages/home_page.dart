import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/meal_controller.dart';
import '../../routes/app_routes.dart';
import '../widgets/meal_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final MealController _mealController = Get.find<MealController>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO (RESPONSI): Ganti opsi categoryList ini sesuai kategori API
    final categoryList = ['All', 'Seafood', 'Chicken', 'Beef', 'Dessert', 'Vegetarian'];

    return Column(
      children: [
        // Search Bar Area
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari resep makanan...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              _mealController.setSearchQuery('');
                              setState(() {});
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                  onSubmitted: (value) => _mealController.setSearchQuery(value),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _mealController.setSearchQuery(_searchController.text);
                },
                child: const Text('Cari'),
              ),
            ],
          ),
        ),

        // Filter Chips Area + Sort Button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categoryList.map((category) {
                        final isSelected = _mealController.selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            selectedColor: Colors.deepOrange.shade100,
                            checkmarkColor: Colors.deepOrange,
                            onSelected: (_) => _mealController.setCategoryFilter(category),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // Tombol Sort A-Z (Bonus 2)
              Obx(() => IconButton(
                    icon: Icon(
                      _mealController.isAscending ? Icons.sort_by_alpha : Icons.sort,
                      color: _mealController.isAscending ? Colors.deepOrange : Colors.grey.shade700,
                    ),
                    tooltip: _mealController.isAscending ? 'Urutan Default' : 'Urutkan A-Z',
                    onPressed: () => _mealController.toggleSort(),
                  )),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),

        // List Area
        Expanded(
          child: Obx(() {
            if (_mealController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_mealController.errorMessage.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      const Text(
                        'Gagal memuat resep masakan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _mealController.errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Coba Lagi'),
                        onPressed: () => _mealController.fetchMeals(),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_mealController.meals.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 54, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    const Text(
                      'Resep tidak ditemukan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Silakan coba kata kunci atau kategori masakan yang berbeda.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => await _mealController.fetchMeals(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _mealController.meals.length,
                itemBuilder: (context, index) {
                  final meal = _mealController.meals[index];
                  return MealCard(
                    meal: meal,
                    onTap: () {
                      Get.toNamed(AppRoutes.detail, arguments: meal);
                    },
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
