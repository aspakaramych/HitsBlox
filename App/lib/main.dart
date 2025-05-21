import 'dart:convert';

import 'package:app/screens/home_screen.dart';
import 'package:app/screens/settings_screen.dart';
import 'package:app/screens/test_screen.dart';
import 'package:app/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/design/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'design/AppRouter.dart';

TestScreen testScreen = TestScreen();

void hideStatusBar() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

void showStatusBar() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _saveScreen("print sample", jsonEncode(SamplesForLoading.getPrintSample()));


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final router = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Inter Tight", "Inter");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'HITsBlocks',
      theme: theme.lightMediumContrast(),
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: '/',
    );
  }

}

Future<void> _saveScreen(String name, String jsonString) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(name, jsonString);
}

class SamplesForLoading {
  static getPrintSample() {
    return {"assignmentBlocks":[{"position":{"dx":1991.3281250000002,"dy":1157.7845982142867},"node":{"id":"node_1747821770258","position":{"dx":1901.4285714285716,"dy":964.2857142857144},"title":"Присвоить (string)","rawExpression":"a=\"privet\";","inputs":[{"id":"exec_in_1747821774202","name":"Exec In","isInput":true,"isRequired":true,"isExecutionPin":true,"valueType":"null","value":null}],"outputs":[{"id":"exec_out_1747821775699","name":"Exec Out","isInput":false,"isRequired":true,"isExecutionPin":true,"valueType":"String","value":"a"}]},"blockName":"string","width":200.0,"height":100.0,"isEditing":false,"wasEdited":true}],"logicBlocks":[{"position":{"dx":1901.4285714285716,"dy":1014.2857142857144},"node":{"id":"node_1747821767463","position":{"dx":1901.4285714285716,"dy":1014.2857142857144},"title":"Старт","inputs":[],"outputs":[{"id":"exec_out_1747821774202","name":"Exec Out","isInput":false,"isRequired":true,"isExecutionPin":true,"valueType":"null","value":null}]},"blockName":"start","width":100.0,"height":100.0,"leftArrows":[],"rightArrows":[{"offset":{"dx":15.0,"dy":55.0},"isWired":false}]}],"printBlocks":[{"position":{"dx":2029.42224702381,"dy":1342.271205357143},"node":{"id":"node_1747821768441","position":{"dx":1901.4285714285716,"dy":1014.2857142857144},"title":"Распечатать","rawExpression":"{a}","inputs":[{"id":"exec_in_1747821775699","name":"Exec In","isInput":true,"isRequired":true,"isExecutionPin":true,"valueType":"String","value":"a"}],"outputs":[]},"blockName":"print","width":200.0,"height":90.0,"isEditing":false,"wasEdited":true}],"ifElseBlocks":[],"whileBlocks":[],"swapBlocks":[],"commentBlocks":[],"wiredBlocks":[{"first":{"position":{"dx":1901.4285714285716,"dy":1014.2857142857144},"nodeId":"node_1747821767463"},"second":{"position":{"dx":1991.3281250000002,"dy":1157.7845982142867},"nodeId":"node_1747821770258"}},{"first":{"position":{"dx":1991.3281250000002,"dy":1157.7845982142867},"nodeId":"node_1747821770258"},"second":{"position":{"dx":2029.42224702381,"dy":1342.271205357143},"nodeId":"node_1747821768441"}}],"calibrations":{"node_1747821767463node_1747821770258":{"dx":0.0,"dy":60.0},"node_1747821770258node_1747821768441":{"dx":0.0,"dy":60.0}},"outputCalibrations":{"node_1747821767463node_1747821770258":{"dx":100.0,"dy":65.0},"node_1747821770258node_1747821768441":{"dx":200.0,"dy":65.0}},"nodeGraph":{"nodes":[{"id":"node_1747821767463","position":{"dx":1901.4285714285716,"dy":1014.2857142857144},"title":"Старт","inputs":[],"outputs":[{"id":"exec_out_1747821774202","name":"Exec Out","isInput":false,"isRequired":true,"isExecutionPin":true,"valueType":"null","value":null}]},{"id":"node_1747821768441","position":{"dx":1901.4285714285716,"dy":1014.2857142857144},"title":"Распечатать","rawExpression":"{a}","inputs":[{"id":"exec_in_1747821775699","name":"Exec In","isInput":true,"isRequired":true,"isExecutionPin":true,"valueType":"String","value":"a"}],"outputs":[]},{"id":"node_1747821770258","position":{"dx":1901.4285714285716,"dy":964.2857142857144},"title":"Присвоить (string)","rawExpression":"a=\"privet\";","inputs":[{"id":"exec_in_1747821774202","name":"Exec In","isInput":true,"isRequired":true,"isExecutionPin":true,"valueType":"null","value":null}],"outputs":[{"id":"exec_out_1747821775699","name":"Exec Out","isInput":false,"isRequired":true,"isExecutionPin":true,"valueType":"String","value":"a"}]}],"connections":[{"fromNodeId":"node_1747821767463","toNodeId":"node_1747821770258","fromPinId":"exec_out_1747821774202","toPinId":"exec_in_1747821774202"},{"fromNodeId":"node_1747821770258","toNodeId":"node_1747821768441","fromPinId":"exec_out_1747821775699","toPinId":"exec_in_1747821775699"}]}};
  }
}