import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, {String locale = 'es_ES'}) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: '€',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatCents(int cents, {String locale = 'es_ES'}) {
    return format(cents / 100.0, locale: locale);
  }

  static String formatCompact(double amount, {String locale = 'es_ES'}) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k€';
    }
    return format(amount, locale: locale);
  }
}
