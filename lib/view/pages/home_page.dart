import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/wizard_controller.dart'; // TERUBAH: Import WizardController menggantikan CharacterController
import '../../routes/app_routes.dart';
import '../widgets/wizard_card.dart'; // TERUBAH: Import WizardCard menggantikan CharacterCard

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  // TERUBAH: Mengambil instance WizardController melalui Get.find()
  final WizardController _wizardController = Get.find<WizardController>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TERUBAH: Mengganti opsi filter menjadi daftar Asrama Hogwarts (House)
    final houseList = ['All', 'Gryffindor', 'Slytherin', 'Hufflepuff', 'Ravenclaw'];

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
                    // TERUBAH: Mengganti hint pencarian menjadi nama penyihir
                    hintText: 'Cari nama penyihir...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              // TERUBAH: Reset pencarian pada WizardController
                              _wizardController.setSearchQuery('');
                              setState(() {});
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                  // TERUBAH: Submit pencarian nama penyihir
                  onSubmitted: (value) => _wizardController.setSearchQuery(value),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  // TERUBAH: Memanggil setSearchQuery dari controller penyihir
                  _wizardController.setSearchQuery(_searchController.text);
                },
                child: const Text('Cari'),
              ),
            ],
          ),
        ),

        // Filter Chips Asrama Hogwarts & Tombol Sort A-Z
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
                      children: houseList.map((house) {
                        // TERUBAH: Memeriksa seleksi asrama terpilih
                        final isSelected = _wizardController.selectedHouse.toLowerCase() == house.toLowerCase();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(house),
                            selected: isSelected,
                            selectedColor: Colors.deepPurple.shade100,
                            checkmarkColor: Colors.deepPurple,
                            // TERUBAH: Memanggil filter asrama pada controller
                            onSelected: (_) => _wizardController.setHouseFilter(house),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // TERUBAH: Tombol Sort A-Z (Bonus 2)
              Obx(() => IconButton(
                    icon: Icon(
                      _wizardController.isAscending ? Icons.sort_by_alpha : Icons.sort,
                      color: _wizardController.isAscending ? Colors.deepPurple : Colors.grey.shade700,
                    ),
                    tooltip: _wizardController.isAscending ? 'Urutan Default' : 'Urutkan A-Z',
                    onPressed: () => _wizardController.toggleSort(),
                  )),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),

        // List Area Karakter Penyihir
        Expanded(
          child: Obx(() {
            if (_wizardController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_wizardController.errorMessage.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      // TERUBAH: Pesan error khusus karakter penyihir
                      const Text(
                        'Gagal memuat data penyihir',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _wizardController.errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Coba Lagi'),
                        // TERUBAH: Coba lagi memuat karakter penyihir
                        onPressed: () => _wizardController.fetchWizards(),
                      ),
                    ],
                  ),
                ),
              );
            }

            // TERUBAH: Memeriksa kekosongan data list wizards
            if (_wizardController.wizards.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 54, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    // TERUBAH: Teks saat karakter tidak ditemukan
                    const Text(
                      'Penyihir tidak ditemukan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coba cari dengan nama atau filter asrama Hogwarts yang lain.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              // TERUBAH: Pull-to-refresh memanggil fetchWizards
              onRefresh: () async => await _wizardController.fetchWizards(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _wizardController.wizards.length, // TERUBAH: Panjang data wizards
                itemBuilder: (context, index) {
                  final wizard = _wizardController.wizards[index]; // TERUBAH: Mengambil objek wizard
                  // TERUBAH: Menggunakan WizardCard dan mengirimkan objek wizard via arguments
                  return WizardCard(
                    wizard: wizard,
                    onTap: () {
                      Get.toNamed(AppRoutes.detail, arguments: wizard);
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
