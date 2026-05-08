import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class AddTodoSheet extends StatefulWidget {
  final Todo? editTodo;

  const AddTodoSheet({super.key, this.editTodo});

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  late Priority _priority;
  DateTime? _dueDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final t = widget.editTodo;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _categoryController =
        TextEditingController(text: t?.category ?? 'General');
    _priority = t?.priority ?? Priority.medium;
    _dueDate = t?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<TodoProvider>(context, listen: false);
    final isEdit = widget.editTodo != null;

    final todo = Todo(
      id: widget.editTodo?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority,
      category: _categoryController.text.trim().isEmpty
          ? 'General'
          : _categoryController.text.trim(),
      createdAt: widget.editTodo?.createdAt ?? DateTime.now(),
      dueDate: _dueDate,
      isCompleted: widget.editTodo?.isCompleted ?? false,
    );

    if (isEdit) {
      provider.updateTodo(todo);
    } else {
      provider.addTodo(todo);
    }

    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isEdit = widget.editTodo != null;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                isEdit ? 'Edit Task' : 'New Task',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Task title *',
                  prefixIcon: const Icon(Icons.task_alt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: cs.surfaceVariant.withOpacity(0.5),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  prefixIcon: const Icon(Icons.notes),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: cs.surfaceVariant.withOpacity(0.5),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 12),

              // Category
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.label_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: cs.surfaceVariant.withOpacity(0.5),
                ),
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 16),

              // Priority
              Text('Priority',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: Priority.values.map((p) {
                  final isSelected = _priority == p;
                  final colors = {
                    Priority.low: Colors.green,
                    Priority.medium: Colors.orange,
                    Priority.high: Colors.red,
                  };
                  final labels = {
                    Priority.low: 'Low',
                    Priority.medium: 'Medium',
                    Priority.high: 'High',
                  };
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _priority = p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors[p]!.withOpacity(0.15)
                              : cs.surfaceVariant.withOpacity(0.5),
                          border: Border.all(
                            color: isSelected
                                ? colors[p]!
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            labels[p]!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected ? colors[p] : cs.onSurface.withOpacity(0.6),
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Due date
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: cs.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: cs.outline.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: cs.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _dueDate == null
                              ? 'Set due date (optional)'
                              : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _dueDate == null
                                ? cs.onSurface.withOpacity(0.5)
                                : cs.onSurface,
                          ),
                        ),
                      ),
                      if (_dueDate != null)
                        GestureDetector(
                          onTap: () => setState(() => _dueDate = null),
                          child: Icon(Icons.close,
                              size: 18, color: cs.onSurface.withOpacity(0.5)),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _save,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(isEdit ? 'Update Task' : 'Add Task'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
