import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';
import '../widgets/todo_card.dart';
import '../widgets/add_todo_sheet.dart';
import '../widgets/stats_header.dart';
import '../widgets/category_chips.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.elasticOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _showAddTodoSheet(BuildContext context, {Todo? editTodo}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTodoSheet(editTodo: editTodo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Taskly ✅',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Consumer<TodoProvider>(
                        builder: (_, provider, __) => Text(
                          '${provider.pendingCount} tasks remaining',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Consumer<TodoProvider>(
                    builder: (_, provider, __) => PopupMenuButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.more_vert,
                            color: colorScheme.onPrimaryContainer),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          onTap: provider.toggleShowCompleted,
                          child: Row(
                            children: [
                              Icon(
                                provider.showCompleted
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(provider.showCompleted
                                  ? 'Hide Completed'
                                  : 'Show Completed'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            if (provider.completedCount > 0) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Clear Completed?'),
                                  content: Text(
                                      'Remove ${provider.completedCount} completed tasks?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        provider.clearCompleted();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Clear'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.delete_sweep, size: 18),
                              SizedBox(width: 8),
                              Text('Clear Completed'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stats
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatsHeader(),
            ),

            const SizedBox(height: 16),

            // Search
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),

            const SizedBox(height: 12),

            // Category chips
            const CategoryChips(),

            const SizedBox(height: 8),

            // Todos list
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (_, provider, __) {
                  final todos = provider.todos;

                  if (todos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: colorScheme.primary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            provider.searchQuery.isNotEmpty
                                ? 'No tasks found'
                                : 'No tasks yet!\nTap + to add one.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: todos.length,
                    itemBuilder: (_, index) {
                      return TodoCard(
                        todo: todos[index],
                        onEdit: () => _showAddTodoSheet(context,
                            editTodo: todos[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: () => _showAddTodoSheet(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
          elevation: 4,
        ),
      ),
    );
  }
}
