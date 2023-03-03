import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/authentication/application/authentication_service.dart';
import '../features/authentication/presentation/login/login_screen.dart';
import '../features/posts/presentation/posts_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/todos/presentation/todos_screen.dart';
import '../features/photos/presentation/photo_detail_screen.dart';
import '../features/photos/presentation/photos_screen.dart';
import '../features/todos/presentation/todo_detail_screen.dart';
import '../features/users/presentation/users_screen.dart';
import '../localization/locale_keys.g.dart';
import 'constants.dart';
import 'router_refresh_stream.dart';
part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final authService = ref.watch(authenticationServiceProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: rootRoute,
    refreshListenable:
        GoRouterRefreshStream(streams: [authService.authStateChanges()]),
    routes: [
      GoRoute(
        path: rootRoute,
        redirect: (ctx, state) => todosRoute,
      ),
      GoRoute(
        path: todosRoute,
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context: context,
          state: state,
          child: const TodosScreen(),
        ),
        routes: [
          GoRoute(
            path: ":todoId",
            pageBuilder: (context, state) => _buildPageWithFadeTransition(
              context: context,
              state: state,
              child: TodoDetailScreen(
                todoId: int.tryParse(state.params["todoId"] ?? "") ?? 0,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: photosRoute,
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context: context,
          state: state,
          child: const PhotosScreen(),
        ),
        routes: [
          GoRoute(
            path: ":photoId",
            pageBuilder: (context, state) => _buildPageWithFadeTransition(
              context: context,
              state: state,
              child: PhotoDetailScreen(
                photoId: int.tryParse(state.params["photoId"] ?? "") ?? 0,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: profileRoute,
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context: context,
          state: state,
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: postsRoute,
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context: context,
          state: state,
          child: const PostsScreen(),
        ),
      ),
      GoRoute(
        path: usersRoute,
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context: context,
          state: state,
          child: const UsersScreen(),
        ),
      ),
      GoRoute(
        path: authRoute,
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
    ],
    redirect: (context, state) async {
      //AUTH MANAGER - REDIRECT
      final isAuth = await authService.getCredentials() != null;
      if (isAuth && state.location == authRoute) {
        return rootRoute;
      } else if (isAuth == false && state.location != authRoute) {
        return authRoute;
      }

      return null;
    },
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AutoSizeText(LocaleKeys.errors_messages_default.tr()),
        ),
      ),
    ),
  );
}

// ignore: unused_element
CustomTransitionPage<Object> _buildPageWithModalTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<Object>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeIn)),
            ),
            child: child),
  );
}

CustomTransitionPage<Object> _buildPageWithFadeTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<Object>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
