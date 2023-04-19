import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import '../../../common/extensions/pagination_base_controller.dart';
import '../application/photos_service.dart';
import '../model/photo.dart';

final paginationPhotosControllerProvider = StateNotifierProvider<
    PaginationBaseController<int, PhotoDto>, PagedState<int, PhotoDto>>((ref) {
  final photosService = ref.watch(photosServiceProvider);
  return PaginationBaseController<int, PhotoDto>(
    load: (page, limit) async => (await photosService
        .getPhotos(queryParameters: {"PageNumber": page.toString()})),
    nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
  );
});
