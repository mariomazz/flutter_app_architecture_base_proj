import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

class PaginationBaseController<T, D> extends PagedNotifier<T, D> {
  PaginationBaseController({
    required Future<List<D>?> Function(T, int) load,
    required T? Function(List<D>?, T, int) nextPageKeyBuilder,
    String? Function(dynamic)? errorBuilder,
  }) : super(
          load: load,
          nextPageKeyBuilder: nextPageKeyBuilder,
          errorBuilder: errorBuilder,
        );
}
