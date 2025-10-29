import 'package:flutter/material.dart';
import 'package:flutter_redirectly/flutter_redirectly.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Redirectly Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RedirectlyExample(),
    );
  }
}

class RedirectlyExample extends StatefulWidget {
  const RedirectlyExample({super.key});

  @override
  State<RedirectlyExample> createState() => _RedirectlyExampleState();
}

class _RedirectlyExampleState extends State<RedirectlyExample> {
  final FlutterRedirectly _redirectly = FlutterRedirectly();
  final TextEditingController _slugController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController(
    text: "3de41dc9-e139-45a2-b25c-9b5bb1c2d289",
  );

  //bool _isInitialized = false;
  // bool _isLoading = false;
  //  String _status = 'Not initialized';
  //final List<String> _linkHistory = [];
  //RedirectlyLinkClick? _lastLinkClick;
  //RedirectlyLink? _lastCreatedLink;
  //RedirectlyTempLink? _lastCreatedTempLink;
  //RedirectlyAppInstallResponse? _lastAppInstall;

  String? productId;
  bool isLoading = true; // 👈 to track loading state

  @override
  void initState() {
    super.initState();
    _targetController.text = 'https://iraq.redirectly.app';
    _initializeRedirectly();
  }

  @override
  void dispose() {
    _slugController.dispose();
    _targetController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _initializeRedirectly() async {
    if (_apiKeyController.text.isEmpty) {
      _showSnackBar('Please enter your API key', isError: true);
      return;
    }

    try {
      await _redirectly.initialize(
        RedirectlyConfig(
          apiKey: _apiKeyController.text,
          enableDebugLogging: true,
        ),
      );

      // Listen for incoming links when app is running

      // Listen for app install events
      // Check for initial link (when app was opened via link)
    } catch (e) {
      _showSnackBar('Initialization failed: $e', isError: true);
      return;
    }

    // ✅ Handle initial link first (await its value)
    final initialLink = await _redirectly.getInitialLink();

    if (initialLink != null && initialLink.originalUrl.contains('products')) {
      final uri = Uri.parse(initialLink.originalUrl);
      final fragment = uri.fragment;
      final parts = fragment.split('/');
      final id = parts.isNotEmpty ? parts.last : null;

      productId = id;
      debugPrint('Initial product ID: $productId');
    }

    // ✅ Listen for future redirects
    _redirectly.onLinkClick.listen((linkClick) async {
      if (linkClick.originalUrl.contains('products')) {
        final uri = Uri.parse(linkClick.originalUrl);
        final fragment = uri.fragment;
        final parts = fragment.split('/');
        final id = parts.isNotEmpty ? parts.last : null;

        setState(() {
          productId = id;
        });
        debugPrint('Stream product ID: $productId');
      }
    });

    // ✅ Finish loading after async setup
    setState(() {
      isLoading = false;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Redirectly Example')),
      body: Center(
        child: Text(
          productId != null
              ? 'Product ID: $productId'
              : 'No product link detected',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/* import 'package:flutter/material.dart';
import 'package:flutter_redirectly/flutter_redirectly.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Redirectly Example',
      home: RedirectlyExample(),
    );
  }
}

class RedirectlyExample extends StatefulWidget {
  const RedirectlyExample({super.key});

  @override
  State<RedirectlyExample> createState() => _RedirectlyExampleState();
}

class _RedirectlyExampleState extends State<RedirectlyExample> {
  final FlutterRedirectly _redirectly = FlutterRedirectly();

  String? productId;
  bool isLoading = true; // 👈 to track loading state

  @override
  void initState() {
    super.initState();
    _initializeRedirectly();
  }

  Future<void> _initializeRedirectly() async {
    await _redirectly.initialize(
      RedirectlyConfig(
        apiKey: "3de41dc9-e139-45a2-b25c-9b5bb1c2d289",
        enableDebugLogging: true,
      ),
    );

    // ✅ Handle initial link first (await its value)
    final initialLink = await _redirectly.getInitialLink();

    if (initialLink != null && initialLink.originalUrl.contains('products')) {
      final uri = Uri.parse(initialLink.originalUrl);
      final fragment = uri.fragment;
      final parts = fragment.split('/');
      final id = parts.isNotEmpty ? parts.last : null;

      productId = id;
      debugPrint('Initial product ID: $productId');
    }

    // ✅ Listen for future redirects
    _redirectly.onLinkClick.listen((linkClick) async {
      if (linkClick.originalUrl.contains('products')) {
        final uri = Uri.parse(linkClick.originalUrl);
        final fragment = uri.fragment;
        final parts = fragment.split('/');
        final id = parts.isNotEmpty ? parts.last : null;

        setState(() {
          productId = id;
        });
        debugPrint('Stream product ID: $productId');
      }
    });

    // ✅ Finish loading after async setup
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Redirectly Example')),
      body: Center(
        child: Text(
          productId != null
              ? 'Product ID: $productId'
              : 'No product link detected',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
} */
