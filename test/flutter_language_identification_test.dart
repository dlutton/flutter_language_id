import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ignore: omit_local_variable_types
  const MethodChannel channel =
      MethodChannel('flutter_language_identification');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
