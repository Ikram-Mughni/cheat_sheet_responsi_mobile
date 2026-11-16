import 'package:get/get.dart';
import '../model/character_model.dart';
import '../service/api_service.dart';

class CharacterController extends GetxController {
  final RxList<CharacterModel> _characters = <CharacterModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
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

  void setStatusFilter(String status) {
    if (_selectedStatus.value != status) {
      _selectedStatus.value = status;
      fetchCharacters();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    fetchCharacters();
  }
}

