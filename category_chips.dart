import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (_, provider, __) {
        final cats = provider.categories;
        return SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: cats.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = cats[i];
              final isSelected = provider.selectedCategory == cat;
              final cs = Theme.of(context).colorScheme;
              return FilterChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) => provider.setCategory(cat),
                selectedColor: cs.primaryContainer,
                checkmarkColor: cs.primary,
                labelStyle: TextStyle(
                  color: isSelected ? cs.primary : cs.onSurface.withOpacity(0.7),
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.normal,
                  fontSize: 13,
                ),
                side: BorderSide(
                  color: isSelected
                      ? cs.primary.withOpacity(0.5)
                      : cs.outline.withOpacity(0.2),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
