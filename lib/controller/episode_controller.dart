import 'package:get/get.dart';
import '../model/episode_model.dart';
import '../service/api_service.dart';

class EpisodeController extends GetxController {
  // TODO (RESPONSI): Ganti nama variabel list dan tipe Model ini sesuai tema (misal: RxList<ReviewModel> _reviews = <ReviewModel>[].obs;).
  final RxList<EpisodeModel> _episodes = <EpisodeModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<EpisodeModel> get episodes => _episodes;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    fetchEpisodes();
  }

  Future<void> fetchEpisodes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      // TODO (RESPONSI): Panggil method fetch data sekunder yang sesuai dari ApiService.
      final data = await ApiService.fetchEpisodes();
      _episodes.assignAll(data);
    } catch (e) {
      _errorMessage.value = e.toString();
      _episodes.clear();
    } finally {
      _isLoading.value = false;
    }
  }
}
