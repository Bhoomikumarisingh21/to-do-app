import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onEdit;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onEdit,
  });

  Color _priorityColor(Priority p, ColorScheme cs) {
    switch (p) {
      case Priority.high:
        return Colors.redAccent;
      case Priority.medium:
        return Colors.orangeAccent;
      case Priority.low:
        return Colors.greenAccent.shade400;
    }
  }

  IconData _priorityIcon(Priority p) {
    switch (p) {
      case Priority.high:
        return Icons.keyboard_double_arrow_up;
      case Priority.medium:
        return Icons.keyboard_arrow_up;
      case Priority.low:
        return Icons.keyboard_arrow_down;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final provider = Provider.of<TodoProvider>(context, listen: false);

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        provider.deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => provider.addTodo(todo),
            ),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: todo.isCompleted
              ? cs.surfaceVariant.withOpacity(0.5)
              : cs.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: todo.isCompleted
                ? cs.outline.withOpacity(0.2)
                : cs.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () => provider.toggleTodo(todo.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: todo.isCompleted ? cs.primary : Colors.transparent,
                      border: Border.all(
                        color:
                            todo.isCompleted ? cs.primary : cs.outline,
                        width: 2,
                      ),
                    ),
                    child: todo.isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              todo.title,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: todo.isCompleted
                                    ? cs.onSurface.withOpacity(0.4)
                                    : cs.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            _priorityIcon(todo.priority),
                            color: _priorityColor(todo.priority, cs),
                            size: 18,
                          ),
                        ],
                      ),
                      if (todo.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(0.5),
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              todo.category,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (todo.dueDate != null) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.schedule, size: 12,
                                color: _isDueSoon(todo.dueDate!)
                                    ? Colors.red
                                    : cs.onSurface.withOpacity(0.4)),
                            const SizedBox(width: 3),
                            Text(
                              _formatDate(todo.dueDate!),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _isDueSoon(todo.dueDate!)
                                    ? Colors.red
                                    : cs.onSurface.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isDueSoon(DateTime due) {
    final now = DateTime.now();
    return due.isBefore(now.add(const Duration(days: 1))) && !todo.isCompleted;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays == -1) return 'Yesterday';
    if (diff.inDays < 0) return '${diff.inDays.abs()}d overdue';
    return '${date.day}/${date.month}';
  }
}
