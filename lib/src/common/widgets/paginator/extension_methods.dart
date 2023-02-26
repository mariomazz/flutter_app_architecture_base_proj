import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

extension ExtPagingController<PageKeyType, ItemType>
    on PagingController<PageKeyType, ItemType> {
  void search() => syncRefresh();

  void endResearch() => syncRefresh();

  void syncRefresh() {
    Future.sync(
      () => refresh(),
    );
  }
}
