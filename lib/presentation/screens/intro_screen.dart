import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/category.dart';
import '../animations/floating_animation.dart';
import '../widgets/bottle_widget.dart';
import '../widgets/expandable_section.dart';

/// [StatefulWidget] Intro screen with educational text and start button.
/// Purpose: First screen users see, explains worry vs fear distinction.
/// Navigation: Default route, navigates to gameplay on Start button tap.
///
/// Displays:
/// - Educational text about worry vs fear
/// - Two 3D bottles (Fear and Worry)
/// - Start button to begin game
/// - Expandable Scientific Background (future implementation)
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => const IntroScreen()),
/// );
/// ```
class IntroScreen extends StatefulWidget {
  /// Creates the intro screen.
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Educational text (FR-001 to FR-003)
                const Text(
                  'Worry vs Fear',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Worry imagines future what-ifs, while fear reacts to an immediate, present danger. Knowing which one you feel helps you choose the right response and calm faster.',
                  style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Bottles (FR-007 to FR-010)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingAnimation(
                      duration: const Duration(milliseconds: 2000),
                      offset: 6.0,
                      child: const BottleWidget(
                        category: Category.fear,
                        isGlowing: false,
                      ),
                    ),
                    FloatingAnimation(
                      duration: const Duration(milliseconds: 2300),
                      offset: 6.0,
                      child: const BottleWidget(
                        category: Category.worry,
                        isGlowing: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Start button (FR-004 to FR-006)
                ElevatedButton(
                  onPressed: () {
                    // Navigate to gameplay screen
                    Navigator.pushNamed(context, '/gameplay');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.textLight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 32),

                // Expandable Scientific Background (FR-012 to FR-015)
                ExpandableSection(
                  title: 'Scientific Background',
                  content: const Text(
                    'Fear and worry are distinct emotional responses:\n\n'
                    '• Fear activates when facing immediate danger, triggering '
                    'the fight-or-flight response to protect you now.\n\n'
                    '• Worry focuses on uncertain future events, often leading '
                    'to rumination about "what if" scenarios.\n\n'
                    'Understanding the difference helps you choose appropriate '
                    'coping strategies: action for fear, planning for worry.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
