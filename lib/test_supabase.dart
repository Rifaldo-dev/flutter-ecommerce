import 'package:ecommerce_ui/config/supabase_config.dart';

class TestSupabase {
  static Future<void> testConnection() async {
    try {
      print('=== TESTING SUPABASE CONNECTION ===');

      final client = SupabaseConfig.client;
      print('Client initialized successfully');

      // Test 1: Simple table query
      print('Testing table access...');
      try {
        final result = await client.from('users').select('count').count();
        print('Table access successful. Count: $result');
      } catch (e) {
        print('Table access failed: $e');
      }

      // Test 2: Auth signup with simple data
      print('Testing auth signup...');
      try {
        final response = await client.auth.signUp(
          email: 'test${DateTime.now().millisecondsSinceEpoch}@example.com',
          password: 'password123',
        );
        print('Auth signup response: ${response.user?.id}');
        print('Session: ${response.session != null}');
      } catch (e) {
        print('Auth signup failed: $e');
      }

      print('=== TEST COMPLETE ===');
    } catch (e) {
      print('Test error: $e');
    }
  }
}
