import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// [StatefulWidget] Expandable section that reveals content when tapped.
/// Purpose: Shows/hides detailed information like scientific background.
///
/// Features:
/// - Smooth expand/collapse animation
/// - Chevron icon that rotates
/// - Customizable header and content
///
/// Example:
/// ```dart
/// ExpandableSection(
///   title: 'Scientific Background',
///   content: Text('Detailed explanation...'),
/// )
/// ```
class ExpandableSection extends StatefulWidget {
  /// Creates an expandable section.
  const ExpandableSection({
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    super.key,
  });

  /// The header title displayed when collapsed.
  final String title;

  /// The content widget to show when expanded.
  final Widget content;

  /// Whether the section starts expanded.
  final bool initiallyExpanded;

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconRotation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconRotation = Tween<double>(
      begin: 0,
      end: 0.5, // 180 degrees (0.5 * 2π)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _iconRotation,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: widget.content,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
