import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/paginator/paginator_widget.dart';
import '../../../localization/locale_keys.g.dart';
import '../../../routes/constants.dart';
import '../../../routes/router.dart';
import '../model/photo.dart';
import 'photos_controller.dart';

class PhotosScreen extends ConsumerWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosController = ref.watch(photosControllerProvider.notifier);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text(LocaleKeys.buttons_titles_go_to_todos_screen.tr()),
        onPressed: () => ref.read(goRouterProvider).go(todosRoute),
      ),
      appBar: AppBar(
        title: Text(LocaleKeys.screens_titles_photos.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => ref.read(goRouterProvider).go(profileRoute),
          ),
        ],
      ),
      body: PaginatedList<int, PhotoDto>(
        refreshIndicator: (child, fnRefresh) {
          return RefreshIndicator(
            onRefresh: () async {
              fnRefresh.call();
            },
            child: child,
          );
        },
        builderPageController: (c) =>
            photosController.photosPaginatorController.complete(c),
        fetching: (pageNumber, int itemsPerPage, bool isFirstPage) async {
          return await photosController.whenInitializePhotosScreen(
            pageNumber,
            itemsPerPage,
            isFirstPage,
          );
        },
        initialPageNumber: 1,
        itemsPerPage: 10,
        widgetBuilder: (photo) {
          return ListTile(
            onTap: () =>
                ref.read(goRouterProvider).go("$photosRoute/${photo.id}"),
            title: Text(photo.title),
            subtitle: SizedBox(
              height: 150,
              width: 150,
              child: CachedNetworkImage(imageUrl: photo.thumbnailUrl),
            ),
            leading: Text(photo.id.toString()),
            trailing: Text(photo.albumId.toString()),
          );
        },
      ),
    );
  }
}
