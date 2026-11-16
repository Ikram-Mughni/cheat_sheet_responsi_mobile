import 'package:get/get.dart';
import '../model/character_model.dart';
import '../service/api_service.dart';

class CharacterController extends GetxController {
  // TODO (RESPONSI): Ganti tipe Model dan nama variabel list ini sesuai tema (misal: RxList<MovieModel> _movies = <MovieModel>[].obs;).
  final RxList<CharacterModel> _characters = <CharacterModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // TODO (RESPONSI): Sesuaikan variabel penyaring (filter status/kategori & search) dengan dokumentasi API baru.
  final RxString _selectedStatus = 'All'.obs;
  final RxString _searchQuery = ''.obs;

  List<CharacterModel> get characters => _characters;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get selectedStatus => _selectedStatus.value;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // TODO (RESPONSI): Sesuaikan pemanggilan fungsi service dan argumen query-nya (?status= / ?name=).
      final data = await ApiService.fetchCharacters(
        status: _selectedStatus.value,
        name: _searchQuery.value,
      );
      _characters.assignAll(data);
    } catch (e) {
      _errorMessage.value = e.toString();
      _characters.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  // TODO (RESPONSI): Sesuaikan method filter jika menyaring berdasarkan kategori, status, atau genre.
  void setStatusFilter(String status) {
    if (_selectedStatus.value != status) {
      _selectedStatus.value = status;
      fetchCharacters();
    }
  }

  // TODO (RESPONSI): Sesuaikan method search query jika ada pencarian kata kunci.
  void setSearchQuery(String query) {
    _searchQuery.value = query;
    fetchCharacters();
  }
}
