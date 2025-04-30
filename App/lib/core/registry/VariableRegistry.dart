class VariableRegistry{
  final Map<String, dynamic> _variables = {};

  void setInt(String name, int value) => _variables[name] = value;
  void setBool(String name, bool value) => _variables[name] = value;
  void setArray<T>(String name, List<T> value) => _variables[name] = value;

  dynamic get(String name) => _variables[name];
  int? getInt(String name) => _variables[name] as int?;
  bool? getBool(String name) => _variables[name] as bool?;
  List<dynamic>? getArray(String name) => _variables[name] as List<dynamic>?;
}