class VariableRegistry{
  final Map<String, dynamic> _variables = {};

  void setValue<T>(String name, T value) => _variables[name] = value;

  T? getValue<T>(String name) {
    var value = _variables[name];
    if (value is T){
      return value;
    }
    return null;
  }

  List<String> getAllVars() => _variables.keys.toList();
}