import 'package:flutter/material.dart';

/// Entry point for the Worry vs Fear cognitive training game.
/// Initializes AppLogger and runs the application.
void main() {
  // TODO: Initialize AppLogger in Phase 2
  // AppLogger.initialize(format: LogFormat.console);

  runApp(const MyApp());
}

/// [StatelessWidget] Root application widget.
/// Purpose: Configures MaterialApp with theme and routing.
///
/// This is a temporary placeholder. Will be replaced with proper
/// app configuration in Phase 3 (User Story 1).
class MyApp extends StatelessWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worry vs Fear Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Worry vs Fear Game'),
    );
  }
}

/// [StatefulWidget] Temporary home page placeholder.
/// Purpose: Placeholder screen until intro screen is implemented.
/// Navigation: Default route (will be replaced in Phase 3)
class MyHomePage extends StatefulWidget {
  /// Creates the home page with the given title.
  const MyHomePage({super.key, required this.title});

  /// Title displayed in the app bar.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Placeholder - will be replaced with Intro Screen'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
