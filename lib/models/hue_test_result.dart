class HueTestResult {
  const HueTestResult({
    required this.accuracy,
    required this.totalError,
    required this.band,
    required this.displacements,
    required this.createdAt,
  });

  /// 0–100, 100 = perfect arrangement.
  final int accuracy;

  /// Sum of tile displacements; 0 = perfect.
  final int totalError;

  /// Qualitative label, e.g. "Typical discrimination".
  final String band;

  /// Per-position displacement, in final arrangement order.
  final List<int> displacements;

  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'accuracy': accuracy,
        'totalError': totalError,
        'band': band,
        'displacements': displacements,
        'createdAt': createdAt.toIso8601String(),
      };

  factory HueTestResult.fromMap(Map<dynamic, dynamic> map) => HueTestResult(
        accuracy: map['accuracy'] as int,
        totalError: map['totalError'] as int,
        band: map['band'] as String,
        displacements: List<int>.from(map['displacements'] as List),
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}
