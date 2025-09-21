import 'package:supabase_flutter/supabase_flutter.dart';
import '../env.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      debug: Env.isDebug,
    );
  }

  // Auth helpers
  static User? get currentUser => client.auth.currentUser;
  static bool get isAuthenticated => currentUser != null;

  // Device authentication
  static Future<AuthResponse> signInAsDevice({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Realtime subscriptions
  static RealtimeChannel subscribeToDeviceCommands(String deviceId) {
    return client.channel('device-commands-$deviceId').onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'device_commands',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'device_id',
            value: deviceId,
          ),
          callback: (payload) {
            // Handle device command
            print('New device command: ${payload.newRecord}');
          },
        );
  }

  static RealtimeChannel subscribeToUIUpdates(String companyId) {
    return client
        .channel('ui-updates-$companyId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'themes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'company_id',
            value: companyId,
          ),
          callback: (payload) {
            // Handle theme update
            print('Theme updated: ${payload.newRecord}');
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'ui_overrides',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'company_id',
            value: companyId,
          ),
          callback: (payload) {
            // Handle UI override update
            print('UI override updated: ${payload.newRecord}');
          },
        );
  }
}
