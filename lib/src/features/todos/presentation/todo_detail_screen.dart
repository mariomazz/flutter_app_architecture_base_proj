import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../localization/locale_keys.g.dart';
import 'todo_controller.dart';

class TodoDetailScreen extends ConsumerWidget {
  final int todoId;
  const TodoDetailScreen({
    super.key,
    required this.todoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(todoControllerProvider(todoId));
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.screens_titles_todo_detail.tr())),
      body: todo.when(
        data: (todo) {
          return Center(
            child: ListTile(
              title: Text(todo.title),
              subtitle: Text("${todo.completed}"),
              leading: Text(todo.userId.toString()),
              trailing: Text(todo.userId.toString()),
            ),
          );
        },
        error: (err, stacktrace) {
          return Center(child: Text(LocaleKeys.errors_messages_default.tr()));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
