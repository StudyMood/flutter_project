import 'dart:convert';

class HistoryItem {
  final String id;
  final String categoryId;
  final String categoryName;
  final double sourceValue;
  final String sourceUnitId;
  final String sourceUnitName;
  final String sourceUnitSymbol;
  final double targetValue;
  final String targetUnitId;
  final String targetUnitName;
  final String targetUnitSymbol;
  final String formula;
  final DateTime timestamp;

  HistoryItem({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.sourceValue,
    required this.sourceUnitId,
    required this.sourceUnitName,
    required this.sourceUnitSymbol,
    required this.targetValue,
    required this.targetUnitId,
    required this.targetUnitName,
    required this.targetUnitSymbol,
    required this.formula,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'sourceValue': sourceValue,
      'sourceUnitId': sourceUnitId,
      'sourceUnitName': sourceUnitName,
      'sourceUnitSymbol': sourceUnitSymbol,
      'targetValue': targetValue,
      'targetUnitId': targetUnitId,
      'targetUnitName': targetUnitName,
      'targetUnitSymbol': targetUnitSymbol,
      'formula': formula,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] as String,
      categoryId: map['categoryId'] as String? ?? 'general',
      categoryName: map['categoryName'] as String,
      sourceValue: (map['sourceValue'] as num).toDouble(),
      sourceUnitId: map['sourceUnitId'] as String? ?? '',
      sourceUnitName: map['sourceUnitName'] as String,
      sourceUnitSymbol: map['sourceUnitSymbol'] as String,
      targetValue: (map['targetValue'] as num).toDouble(),
      targetUnitId: map['targetUnitId'] as String? ?? '',
      targetUnitName: map['targetUnitName'] as String,
      targetUnitSymbol: map['targetUnitSymbol'] as String,
      formula: map['formula'] as String? ?? '',
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryItem.fromJson(String source) =>
      HistoryItem.fromMap(json.decode(source) as Map<String, dynamic>);
}

