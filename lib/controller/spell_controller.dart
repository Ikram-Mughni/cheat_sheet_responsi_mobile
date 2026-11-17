import 'package:get/get.dart';
import '../model/spell_model.dart'; // TERUBAH: Import SpellModel menggantikan EpisodeModel
import '../service/api_service.dart';

class SpellController extends GetxController {
  // TERUBAH: Mengganti tipe data list menjadi RxList<SpellModel> dan nama variabel menjadi _spells
  final RxList<SpellModel> _spells = <SpellModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<SpellModel> get spells => _spells; // TERUBAH: Getter spells
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    fetchSpells(); // TERUBAH: Inisialisasi memuat data mantra sihir
  }

  // TERUBAH: Method fetchSpells menggantikan fetchEpisodes
  Future<void> fetchSpells() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      // TERUBAH: Memanggil ApiService.fetchSpells() untuk mengambil data mantra
      final data = await ApiService.fetchSpells();
      _spells.assignAll(data);
    } catch (e) {
      _errorMessage.value = e.toString();
      _spells.clear();
    } finally {
      _isLoading.value = false;
    }
  }
}
