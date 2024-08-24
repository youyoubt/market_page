// market data model
import 'package:intl/intl.dart';

class MarketModel {
  final String type;
  final String base;
  final String quote;
  final double lastPrice;
  final double volume;

  const MarketModel({
    this.type = '',
    this.base = '',
    this.quote = '',
    this.lastPrice = 0.0,
    this.volume = 0.0,
  });

  /// symbol display name
  String getSymbolDisplay() {
    if (type == 'SPOT') {
      return '$base/$quote';
    }
    return ' $base-PERP';
  }

  /// price display name
  String getPriceDisplay() {
    final parts = lastPrice.toString().split('.');
    final integerPart = NumberFormat('#,##0').format(int.parse(parts[0]));
    if (parts.length > 1) {
      return '\$$integerPart.${parts[1]}';
    } else {
      return '\$$integerPart';
    }
  }

  /// volume display name
  String getDisplayVolume() {
    if (volume >= 1e9) {
      return '\$${(volume / 1e9).toStringAsFixed(2)}B'; // Billion
    } else if (volume >= 1e6) {
      return '\$${(volume / 1e6).toStringAsFixed(2)}M'; // Million
    } else if (volume >= 1e3) {
      return '\$${(volume / 1e3).toStringAsFixed(2)}K'; // Thousand
    } else {
      return '\$${volume.toStringAsFixed(2)}';
    }
  }

  factory MarketModel.fromJson(Map map) {
    return MarketModel(
      type: map['type'] ?? '',
      base: map['base'] ?? '',
      quote: map['quote'] ?? '',
      lastPrice: checkDouble(map['lastPrice']) ?? 0.0,
      volume: checkDouble(map['volume']) ?? 0.0,
    );
  }

  static double? checkDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
