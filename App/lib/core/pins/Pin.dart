class Pin {
  final String id;
  final String name;
  final bool isInput;
  dynamic value;

  Pin({required this.id, required this.name, required this.isInput});

  void setValue(dynamic newValue) {
    value = newValue;
  }

  dynamic getValue() {
    return value;
  }
}
