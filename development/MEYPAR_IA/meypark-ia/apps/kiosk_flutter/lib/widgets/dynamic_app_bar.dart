import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import 'package:intl/intl.dart';

class DynamicAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const DynamicAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<DynamicAppBar> createState() => _DynamicAppBarState();
}

class _DynamicAppBarState extends ConsumerState<DynamicAppBar> {
  int _tapCount = 0;
  Timer? _tapTimer;
  DateTime _currentTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tapTimer?.cancel();
    super.dispose();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  void _handleTripleTap() {
    _tapCount++;
    if (_tapTimer != null && _tapTimer!.isActive) {
      _tapTimer!.cancel();
    }
    _tapTimer = Timer(const Duration(milliseconds: 500), () {
      if (_tapCount >= 3) {
        // Triple tap detected
        context.goNamed('hidden-login');
      }
      _tapCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uiOverrides = ref.watch(uiOverridesProvider);
    final appTheme =
        ref.watch(uiOverridesProvider); // Using uiOverrides as fallback
    final deviceConfig =
        ref.watch(uiOverridesProvider); // Using uiOverrides as fallback

    return uiOverrides.when(
      data: (uiOverridesData) {
        return appTheme.when(
          data: (appThemeData) {
            return deviceConfig.when(
              data: (deviceConfigData) {
                return _buildAppBar(
                    uiOverridesData, appThemeData, deviceConfigData);
              },
              loading: () => _buildAppBar(uiOverridesData, appThemeData, null),
              error: (err, stack) =>
                  _buildAppBar(uiOverridesData, appThemeData, null),
            );
          },
          loading: () => _buildAppBar(uiOverridesData, null, null),
          error: (err, stack) => _buildAppBar(uiOverridesData, null, null),
        );
      },
      loading: () => _buildAppBar(null, null, null),
      error: (err, stack) => _buildAppBar(null, null, null),
    );
  }

  Widget _buildAppBar(
    Map<String, dynamic>? uiOverrides,
    Map<String, dynamic>? appTheme,
    Map<String, dynamic>? deviceConfig,
  ) {
    final appBarColor = _getAppBarColor(appTheme);
    final companyName = _getCompanyName(uiOverrides);
    final showTime = _shouldShowTime(deviceConfig);

    return AppBar(
      backgroundColor: appBarColor,
      title: GestureDetector(
        onTap: _handleTripleTap,
        child: Row(
          children: [
            // TODO: Add company logo from Supabase Storage
            // Image.network(
            //   'https://example.com/logo.png', // Replace with actual logo URL from Supabase
            //   height: 30,
            // ),
            // const SizedBox(width: 8),
            Text(
              companyName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (showTime) _buildTimeDate(deviceConfig),
          ],
        ),
      ),
    );
  }

  Color _getAppBarColor(Map<String, dynamic>? theme) {
    if (theme != null && theme['colors_json'] != null) {
      final colors = theme['colors_json'] as Map<String, dynamic>;
      final colorHex = colors['appbar_bg'] as String?;
      if (colorHex != null) {
        return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
      }
    }
    return Theme.of(context).primaryColor;
  }

  String _getCompanyName(Map<String, dynamic>? uiOverrides) {
    if (uiOverrides != null && uiOverrides['text_overrides_json'] != null) {
      final textOverrides =
          uiOverrides['text_overrides_json'] as Map<String, dynamic>;
      return textOverrides['appbar_phrase'] as String? ?? 'MEYPARK';
    }
    return 'MEYPARK';
  }

  bool _shouldShowTime(Map<String, dynamic>? deviceConfig) {
    // Assuming a feature flag 'show_time_date_appbar' controls this
    if (deviceConfig != null && deviceConfig['value_json'] != null) {
      final valueJson = deviceConfig['value_json'] as Map<String, dynamic>;
      return valueJson['show_time_date_appbar'] as bool? ?? true;
    }
    return true;
  }

  Widget _buildTimeDate(Map<String, dynamic>? deviceConfig) {
    // Assuming device timezone is configured in deviceConfig or fetched from device table
    final String timezone =
        deviceConfig?['timezone'] as String? ?? 'Europe/Madrid'; // Default
    final bool show24Hour =
        deviceConfig?['show_24_hour_format'] as bool? ?? true; // Default

    final DateFormat timeFormat = DateFormat(show24Hour ? 'HH:mm' : 'hh:mm a');
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy'); // Example format

    // TODO: Apply timezone if needed, currently uses local time
    final String formattedTime = timeFormat.format(_currentTime);
    final String formattedDate = dateFormat.format(_currentTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(formattedTime,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(formattedDate,
            style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
