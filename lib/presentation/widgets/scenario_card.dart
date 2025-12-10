import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/category.dart';
import '../../domain/models/scenario.dart';

/// [StatefulWidget] Draggable scenario card with emoji and text.
/// Purpose: Interactive card that user drags to bottles to classify scenarios.
///
/// Features:
/// - Displays scenario emoji and text
/// - Draggable with custom feedback widget
/// - Shows error state with red border and shake animation
/// - Lifts on drag start with smooth animation
///
/// Example:
/// ```dart
/// ScenarioCard(
///   scenario: myScenario,
///   onAccepted: (category) {
///     // Handle drop on bottle
///   },
///   showError: false,
/// )
/// ```
class ScenarioCard extends StatefulWidget {
  /// Creates a scenario card.
  const ScenarioCard({
    required this.scenario,
    required this.onAccepted,
    this.showError = false,
    super.key,
  });

  /// The scenario to display.
  final Scenario scenario;

  /// Callback when card is dropped on a bottle.
  final void Function(Category category) onAccepted;

  /// Whether to show error state (red border, shake).
  final bool showError;

  @override
  State<ScenarioCard> createState() => _ScenarioCardState();
}

class _ScenarioCardState extends State<ScenarioCard>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _springController;
  late Animation<double> _springAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    // Shake animation for error feedback
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Spring animation for snap-back on drag end
    _springController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _springAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _springController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(ScenarioCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger shake animation when error state changes
    if (widget.showError && !oldWidget.showError) {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<Scenario>(
      data: widget.scenario,
      onDragStarted: () {
        setState(() => _isDragging = true);
      },
      onDragEnd: (_) {
        setState(() => _isDragging = false);
        // Trigger spring bounce animation on snap-back
        _springController.forward(from: 0.0);
      },
      feedback: _buildCardContent(isDragging: true, opacity: 0.8),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildCardContent(isDragging: false),
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([_shakeAnimation, _springAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _springAnimation.value,
            child: Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: child,
            ),
          );
        },
        child: AnimatedScale(
          scale: _isDragging ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: _buildCardContent(isDragging: false),
        ),
      ),
    );
  }

  Widget _buildCardContent({required bool isDragging, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.showError ? AppColors.error : Colors.transparent,
            width: widget.showError ? 3 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDragging ? 0.3 : 0.1),
              blurRadius: isDragging ? 20 : 10,
              offset: Offset(0, isDragging ? 10 : 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji
            Text(widget.scenario.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            // Scenario text
            Text(
              widget.scenario.text,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
