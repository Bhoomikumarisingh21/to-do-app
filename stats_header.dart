import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Consumer<TodoProvider>(
      builder: (_, provider, __) {
        final total = provider.totalCount;
        final done = provider.completedCount;
        final progress = total == 0 ? 0.0 : done / total;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cs.primaryContainer,
                cs.secondaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    label: 'Total',
                    value: total.toString(),
                    icon: Icons.list_alt,
                    context: context,
                  ),
                  _StatItem(
                    label: 'Done',
                    value: done.toString(),
                    icon: Icons.check_circle_outline,
                    context: context,
                  ),
                  _StatItem(
                    label: 'Pending',
                    value: provider.pendingCount.toString(),
                    icon: Icons.pending_actions,
                    context: context,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: cs.onPrimaryContainer.withOpacity(0.15),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(cs.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final BuildContext context;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, color: cs.onPrimaryContainer.withOpacity(0.7), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onPrimaryContainer,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: cs.onPrimaryContainer.withOpacity(0.6),
              ),
        ),
      ],
    );
  }
}
