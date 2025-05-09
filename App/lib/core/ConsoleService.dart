import 'dart:ui';

class ConsoleService {
  static final ConsoleService _instance = ConsoleService._internal();
  factory ConsoleService() => _instance;
  ConsoleService._internal();

  final List<String> _logs = [];

  List<String> get logs => List.unmodifiable(_logs);

  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);
  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void log(String message) {
    print('\n\n\n\n\n ${message} \n\n\n\n');
    _logs.add(message);
    notifyListeners();
  }

  void clear() {
    _logs.clear();
    notifyListeners();
  }
}