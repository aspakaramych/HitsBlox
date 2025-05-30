import 'dart:ui';

extension OffsetExtension on Offset {
  Map<String, double> toJson() {
    return {'dx': dx, 'dy': dy};
  }

  static Offset fromJson(Map<String, dynamic> json) {
    return Offset(json['dx'], json['dy']);
  }
}
