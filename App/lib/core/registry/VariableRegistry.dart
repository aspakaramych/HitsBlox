class VariableRegistry{
  final Map<String, Object?> _variables = {};

  void setValue<T>(String name, T value) => _variables[name] = value;

  T? getValue<T>(String name) {
    var value = _variables[name];
    if (value is T){
      return value;
    }
    return null;
  }
}