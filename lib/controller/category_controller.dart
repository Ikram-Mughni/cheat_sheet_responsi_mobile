import 'package:get/get.dart';
import '../model/category_model.dart';
import '../service/api_service.dart';

class CategoryController extends GetxController {
  // TODO (RESPONSI): Ganti nama variabel list dan tipe Model ini sesuai tema
  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final data = await ApiService.fetchCategories();
      _categories.assignAll(data);
    } catch (e) {
      _errorMessage.value = e.toString();
      _categories.clear();
    } finally {
      _isLoading.value = false;
    }
  }
}
