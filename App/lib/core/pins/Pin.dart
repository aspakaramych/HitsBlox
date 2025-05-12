class Pin<T> {
  final String id;
  final String name;
  final bool isInput;
  T? value;

  Pin({required this.id, required this.name, required this.isInput});

  void setValue(T? newValue) {
    if (T != dynamic && newValue != null && newValue is! T) {
      throw Exception("Type mismatch: expected $T, got ${newValue.runtimeType}");
    }
    value = newValue;
  }

  T? getValue() {
    return value;
  }
}
