import 'package:flutter/foundation.dart';

class Env {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://edkwlmauywdxbencaucj.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVka3dsbWF1eXdkeGJlbmNhdWNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg0MDM3ODAsImV4cCI6MjA3Mzk3OTc4MH0.Y_V6wokZoYd7UcHNvNUPHER-d76ZEu-6wtKHavYZ8eA',
  );

  static const String supabaseServiceRoleKey = String.fromEnvironment(
    'SUPABASE_SERVICE_ROLE_KEY',
    defaultValue: '',
  );

  static const String supabaseProjectRef = String.fromEnvironment(
    'SUPABASE_PROJECT_REF',
    defaultValue: 'edkwlmauywdxbencaucj',
  );

  static bool get isDebug => kDebugMode;
  static bool get isRelease => kReleaseMode;
  static bool get isWeb => kIsWeb;
  static bool get isLinux =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;
}
