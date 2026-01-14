import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Hardcoded - simple approach
  static const String supabaseUrl = 'https://yszszvjyahppsnrfrbqt.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlzenN6dmp5YWhwcHNucmZyYnF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1NTE3MTgsImV4cCI6MjA4MjEyNzcxOH0.DxW4YsxuzBf6A8Ggft9hMMRFIwJmfhfgzGczb6cMznU';

  static Future<void> initialize() async {
    try {
      print('Initializing Supabase...');

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      print('Supabase initialized successfully');
    } catch (e) {
      print('Supabase initialization error: $e');
      // Don't rethrow, just continue
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}
