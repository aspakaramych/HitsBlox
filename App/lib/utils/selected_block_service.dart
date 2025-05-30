import 'package:flutter/cupertino.dart';

import '../core/abstracts/node.dart';

class SelectedBlockService with ChangeNotifier {
  final List<String> activeNodeIds = [];

  void add(Node node) {
    activeNodeIds.clear();
    activeNodeIds.add(node.id);
    notifyListeners();
  }

  void clear() {
    activeNodeIds.clear();
    notifyListeners();
  }
}
