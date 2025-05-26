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
  void Clear(){
    _variables.clear();
  }

  List<String> getAllVars() => _variables.keys.toList();

  @override
  String toString() {
    var output = "";
    for (var el in _variables.entries){
      output += el.key + ": " + el.value.toString() + "\n" + ">";
    }
    return output;
  }
}