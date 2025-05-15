class Pin<T> {
  final String id;
  final String name;
  final bool isInput;
  final bool isRequired;
  final bool isExecutionPin;
  T? value;

  Pin({
    required this.id,
    required this.name,
    required this.isInput,
    this.isRequired = true,
    this.isExecutionPin = false,
  });

  void setValue(T? newValue) {
    if (T != dynamic && newValue != null && newValue is! T) {
      throw Exception(
        "Type mismatch: expected $T, got ${newValue.runtimeType}",
      );
    }
    value = newValue;
  }

  T? getValue() {
    return value;
  }

  bool hasValue() => value != null;
}

Map<String, dynamic> pinToJson(Pin pin) {
  var value = pin.value;
  String? serializedValue;
  String valueType = 'null';

  if (value is String) {
    valueType = 'String';
    serializedValue = value;
  } else if (value is int) {
    valueType = 'int';
    serializedValue = value.toString();
  } else if (value is double) {
    valueType = 'double';
    serializedValue = value.toString();
  } else if (value is bool) {
    valueType = 'bool';
    serializedValue = value.toString();
  }

  return {
    'id': pin.id,
    'name': pin.name,
    'isInput': pin.isInput,
    'isRequired': pin.isRequired,
    'isExecutionPin': pin.isExecutionPin,
    'valueType': valueType,
    'value': serializedValue,
  };
}

Pin pinFromJson(Map<String, dynamic> json) {
  final pin = Pin(
    id: json['id'],
    name: json['name'],
    isInput: json['isInput'],
    isRequired: json['isRequired'],
    isExecutionPin: json['isExecutionPin'],
  );

  final type = json['valueType'];
  final valueStr = json['value'];

  if (type == 'String' && valueStr != null) {
    pin.setValue(valueStr);
  } else if (type == 'int' && valueStr != null) {
    pin.setValue(int.tryParse(valueStr));
  } else if (type == 'double' && valueStr != null) {
    pin.setValue(double.tryParse(valueStr));
  } else if (type == 'bool' && valueStr != null) {
    pin.setValue(valueStr == 'true');
  }

  return pin;
}
