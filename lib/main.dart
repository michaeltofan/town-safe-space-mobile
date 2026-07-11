import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'owner_preview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.uri, this.isWeb});

  /// Optional override for tests. Production uses [Uri.base].
  final Uri? uri;

  /// Optional override for tests. Production uses [kIsWeb].
  final bool? isWeb;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOWN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDFBF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E140F),
          brightness: Brightness.light,
        ),
      ),
      home: initialHomeForApp(uri: uri ?? Uri.base, isWeb: isWeb ?? kIsWeb),
    );
  }
}
