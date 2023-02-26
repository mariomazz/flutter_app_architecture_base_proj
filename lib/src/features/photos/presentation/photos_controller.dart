import 'dart:async';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../common/widgets/paginator/common.dart';
import '../application/photos_service.dart';
import '../model/photo.dart';
part 'photos_controller.g.dart';

@riverpod
class PhotosController extends _$PhotosController {
  final photosPaginatorController =
      Completer<PagingController<int, PhotoDto>>();

  Future<FetchDataResult<int, PhotoDto>> whenInitializePhotosScreen(
      int pageNumber, int itemsPerPage, bool isFirstPage) async {
    final serv = ref.read(photosServiceProvider);
    final result = await serv.getPhotos(
      queryParameters: {
        "ItemsPerPage": itemsPerPage,
        "PageNumber": pageNumber,
      },
    );
    return FetchDataResult(elements: result, nextPageKey: pageNumber + 1);
  }

  @override
  void build() {
    /*  final serv = ref.read(photosServiceProvider);
    return await serv.getPhotos(); */
  }
}
