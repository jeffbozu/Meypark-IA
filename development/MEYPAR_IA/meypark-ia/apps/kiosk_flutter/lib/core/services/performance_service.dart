import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerformanceService {
  static final Map<String, DateTime> _timers = {};
  static final List<PerformanceMetric> _metrics = [];

  static void startTimer(String name) {
    _timers[name] = DateTime.now();
  }

  static void endTimer(String name) {
    final startTime = _timers[name];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _metrics.add(PerformanceMetric(
        name: name,
        duration: duration,
        timestamp: DateTime.now(),
      ));
      _timers.remove(name);

      if (kDebugMode) {
        print('Performance: $name took ${duration.inMilliseconds}ms');
      }
    }
  }

  static List<PerformanceMetric> getMetrics() => List.unmodifiable(_metrics);

  static void clearMetrics() {
    _metrics.clear();
  }

  static Map<String, Duration> getAverageMetrics() {
    final Map<String, List<Duration>> grouped = {};

    for (final metric in _metrics) {
      grouped.putIfAbsent(metric.name, () => []).add(metric.duration);
    }

    return grouped.map((name, durations) {
      final total = durations.fold<Duration>(
        Duration.zero,
        (sum, duration) => sum + duration,
      );
      return MapEntry(name,
          Duration(microseconds: total.inMicroseconds ~/ durations.length));
    });
  }
}

class PerformanceMetric {
  final String name;
  final Duration duration;
  final DateTime timestamp;

  PerformanceMetric({
    required this.name,
    required this.duration,
    required this.timestamp,
  });
}

// Provider para métricas de performance
final performanceMetricsProvider =
    StateProvider<List<PerformanceMetric>>((ref) => []);

// Provider para métricas promedio
final averageMetricsProvider = Provider<Map<String, Duration>>((ref) {
  final metrics = ref.watch(performanceMetricsProvider);
  return PerformanceService.getAverageMetrics();
});

// Widget para mostrar métricas de performance (solo en debug)
class PerformanceOverlay extends ConsumerWidget {
  const PerformanceOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    final metrics = ref.watch(performanceMetricsProvider);
    final averages = ref.watch(averageMetricsProvider);

    return Positioned(
      top: 50,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Performance Metrics',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...averages.entries.map((entry) => Text(
                  '${entry.key}: ${entry.value.inMilliseconds}ms',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                )),
            const SizedBox(height: 4),
            Text(
              'Total metrics: ${metrics.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
