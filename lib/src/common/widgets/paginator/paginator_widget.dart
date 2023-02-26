import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:testpaginator/src/common/widgets/paginator/extension_methods.dart';
import 'common.dart';

class PaginatedList<K, T> extends StatefulWidget {
  final K initialPageNumber;
  final int itemsPerPage;
  final void Function(PagingController<K, T>)? builderPageController;
  final Future<FetchDataResult<K, T>> Function(
      K pageNumber, int itemsPerPage, bool isFirstPage) fetching;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget Function(T data) widgetBuilder;
  final Widget? Function(Widget child, VoidCallback refresh)? refreshIndicator;
  final ScrollController? scrollController;
  final Axis scrollDirection;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final Widget Function(BuildContext)? firstPageErrorIndicatorBuilder;
  final Widget Function(BuildContext)? newPageErrorIndicatorBuilder;
  final Widget Function(BuildContext)? firstPageProgressIndicatorBuilder;
  final Widget Function(BuildContext)? newPageProgressIndicatorBuilder;
  final Widget Function(BuildContext)? noItemsFoundIndicatorBuilder;
  final Widget Function(BuildContext)? noMoreItemsIndicatorBuilder;
  const PaginatedList({
    super.key,
    required this.initialPageNumber,
    this.itemsPerPage = 0,
    required this.fetching,
    required this.widgetBuilder,
    this.separatorBuilder,
    this.refreshIndicator,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.padding = EdgeInsets.zero,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.builderPageController,
    this.shrinkWrap = false,
  });

  @override
  State<PaginatedList<K, T>> createState() => _PaginatedListState<K, T>();
}

class _PaginatedListState<K, T> extends State<PaginatedList<K, T>> {
  late final pagingController =
      PagingController<K, T>(firstPageKey: widget.initialPageNumber);

  @override
  void initState() {
    widget.builderPageController?.call(pagingController);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(K pageKey) async {
    try {
      final newItems = await widget.fetching(
        pageKey,
        widget.itemsPerPage,
        pagingController.itemList == null,
      );
      final isLastPage = newItems.elements.length < widget.itemsPerPage;
      if (isLastPage) {
        pagingController.appendLastPage(newItems.elements);
      } else {
        pagingController.appendPage(newItems.elements, newItems.nextPageKey);
      }
    } catch (e) {
      pagingController.error = e;
      // rethrow; ?
    }
  }

  @override
  Widget build(context) {
    final Widget paginatorWidget = PagedListView<K, T>.separated(
      separatorBuilder: widget.separatorBuilder ?? _defaultSeparatorBuilder,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap, //just set this property
      scrollDirection: widget.scrollDirection,
      scrollController: widget.scrollController,
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: (context, item, index) => widget.widgetBuilder(item),
        firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder,
        newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
        firstPageProgressIndicatorBuilder:
            widget.firstPageProgressIndicatorBuilder,
        newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder,
        noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder,
        noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder,
      ),
    );

    return Builder(
      builder: (context) {
        final refreshIndicatorWidget = widget.refreshIndicator?.call(
          paginatorWidget,
          pagingController.syncRefresh,
        );
        if (refreshIndicatorWidget != null) {
          return refreshIndicatorWidget;
        }
        return paginatorWidget;
      },
    );
  }

  Widget _defaultSeparatorBuilder(BuildContext context, int index) {
    return const SizedBox();
  }
}
