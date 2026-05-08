import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showCompleted = true;

  List<Todo> get todos => _filteredTodos;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get showCompleted => _showCompleted;

  List<String> get categories {
    final cats = _todos.map((t) => t.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  int get completedCount => _todos.where((t) => t.isCompleted).length;
  int get totalCount => _todos.length;
  int get pendingCount => _todos.where((t) => !t.isCompleted).length;

  List<Todo> get _filteredTodos {
    List<Todo> result = List.from(_todos);

    if (!_showCompleted) {
      result = result.where((t) => !t.isCompleted).toList();
    }

    if (_selectedCategory != 'All') {
      result = result.where((t) => t.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              t.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    result.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.priority.index.compareTo(a.priority.index);
    });

    return result;
  }

  TodoProvider() {
    _loadTodos();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    _saveTodos();
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      _saveTodos();
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    _saveTodos();
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );
      _saveTodos();
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleShowCompleted() {
    _showCompleted = !_showCompleted;
    notifyListeners();
  }

  void clearCompleted() {
    _todos.removeWhere((t) => t.isCompleted);
    _saveTodos();
    notifyListeners();
  }

  Future<void> _saveTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = _todos.map((t) => t.toJson()).toList();
      await prefs.setStringList('todos', todosJson);
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }

  Future<void> _loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getStringList('todos') ?? [];
      _todos = todosJson.map((json) => Todo.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading todos: $e');
    }
  }
}
