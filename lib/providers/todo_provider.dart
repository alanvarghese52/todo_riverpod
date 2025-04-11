import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../utils/uuid_generator.dart';

// Define a TodoNotifier that extends StateNotifier
class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  void addTodo(String title, String description) {
    final newTodo = Todo(
      id: UuidGenerator.generateUuid(),
      title: title,
      description: description,
    );
    state = [...state, newTodo];
  }

  void toggleTodo(String id) {
    state =
        state.map((todo) {
          if (todo.id == id) {
            return todo.copyWith(isCompleted: !todo.isCompleted);
          }
          return todo;
        }).toList();
  }

  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void updateTodo(Todo updatedTodo) {
    state =
        state.map((todo) {
          if (todo.id == updatedTodo.id) {
            return updatedTodo;
          }
          return todo;
        }).toList();
  }
}

// Create a provider for the TodoNotifier
final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

// Additional provider to filter completed todos
final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoProvider);
  return todos.where((todo) => todo.isCompleted).toList();
});

// Additional provider to filter incomplete todos
final incompleteTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoProvider);
  return todos.where((todo) => !todo.isCompleted).toList();
});
