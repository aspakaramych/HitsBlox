class Pin<T> {
  final String id;
  final String name;
  final bool isInput;
  T? value;

  Pin({required this.id, required this.name, required this.isInput});

  void setValue(T newValue) {
    value = newValue;
  }

  dynamic getValue() {
    return value;
  }
}
