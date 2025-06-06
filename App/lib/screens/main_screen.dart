import 'dart:convert';
import 'dart:developer';

import 'package:app/design/widgets/widgets.dart';
import 'package:app/main.dart';
import 'package:app/screens/test_screen.dart';
import 'package:app/utils/serialization_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastify/toastify.dart';

import '../core/widgets/custom_toast.dart';

class MainScreen extends StatefulWidget {
  final savedState;
  String screenName;

  MainScreen(this.savedState, {super.key, required this.screenName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  bool _isAddSectionVisible = false;
  final TestScreen _testScreen = testScreen;
  bool _isDebugConsoleOpen = false;
  bool _isDebugMode = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 300),
    );
    if (widget.savedState == "create_new_screen") {
      SerializationUtils.clear(_testScreen);
    } else if (widget.savedState != null) {
      SerializationUtils.loadFromJson(widget.savedState, _testScreen);
    }
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    _testScreen.debugNotifier.addListener(_toggleDebugMode);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAddSection() {
    setState(() {
      _isAddSectionVisible = !_isAddSectionVisible;
    });
  }

  void _showTerminalPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Console(consoleService: _testScreen.consoleService);
      },
    );
  }

  void _toggleDebugConsole() {
    setState(() {
      _isDebugConsoleOpen = !_isDebugConsoleOpen;
    });
  }

  void _toggleDebugMode() {
    setState(() {
      _isDebugMode = _testScreen.debugNotifier.getDebugMode();
      _isDebugConsoleOpen = (!_isDebugMode) ? false : _isDebugConsoleOpen;
    });
  }

  Future<void> _saveScreen() async {
    final prefs = await SharedPreferences.getInstance();
    if (widget.screenName.isEmpty) {
      var saveName = await showSaveDialog(context);
      if (saveName == null || saveName.trim().isEmpty) return;
      widget.screenName = saveName;
    }
    final jsonString = jsonEncode(
      SerializationUtils.saveScreenState(_testScreen),
    );

    prefs.setString(widget.screenName, jsonString);

    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 1),
        child: CustomToast(
          title: 'Сохраняем..',
          description: "Сохранено успешно!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        ),
      ),
    );

    log(jsonString);
  }

  Future<String?> showSaveDialog(BuildContext context) async {
    String? saveName;

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Сохранить проект'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Введите название сохранения',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              saveName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (saveName?.trim().isNotEmpty == true) {
                  Navigator.of(context).pop(saveName);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return PopScope(
        canPop: false,
        child: Stack(
          children: [
            _testScreen,
            Stack(
              children: [
                Positioned(
                  height: 200,
                  top: 125,
                  right: 20,
                  child: Visibility(
                    visible: _isDebugConsoleOpen,
                    maintainState: true,
                    child: DebugConsole(
                      onClose: _toggleDebugConsole,
                      debugConsoleService: _testScreen.debugConsoleService,
                    ),
                  ),
                ),
                if (_isDebugMode)
                  Align(
                    alignment: Alignment.centerRight,
                    child: VerticalDebugBar(
                      onNextPressed: () {
                        _testScreen.engine.next();
                      },
                      onStopPressed: () {
                        _testScreen.debugNotifier.setDebugMode(false);
                        _testScreen.engine.resume(_testScreen.debugNotifier);
                        _testScreen.selectedBlockService.clear();
                      },
                      onMenuPressed: () {
                        _toggleDebugConsole();
                      },
                    ),
                  ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: HorizontalTopBar(
                        play: () {
                          _testScreen.consoleService.clear();
                          _testScreen.debugNotifier.setDebugMode(false);
                          _testScreen.engine.run(
                            _testScreen.nodeGraph,
                            _testScreen.registry,
                            _testScreen.consoleService,
                            _testScreen.debugConsoleService,
                            _testScreen.selectedBlockService,
                            _testScreen.state,
                            _testScreen.debugNotifier,
                            context,
                          );
                        },
                        debug: () {
                          _testScreen.consoleService.clear();
                          _toggleDebugMode();
                          _testScreen.debugNotifier.setDebugMode(true);
                          _testScreen.engine.run(
                            _testScreen.nodeGraph,
                            _testScreen.registry,
                            _testScreen.consoleService,
                            _testScreen.debugConsoleService,
                            _testScreen.selectedBlockService,
                            _testScreen.state,
                            _testScreen.debugNotifier,
                            context,
                          );
                        },
                        state: _testScreen.state,
                        debugNotifier: _testScreen.debugNotifier,
                        stop: () {
                          _testScreen.engine.stop(
                            _testScreen.debugNotifier,
                            _testScreen.state,
                          );
                          _testScreen.selectedBlockService.clear();
                        },
                      ),
                    ),
                    Expanded(child: Center()),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        );
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 2),
                            end: Offset.zero,
                          ).animate(curvedAnimation),
                          child: child,
                        );
                      },
                      child:
                          _isAddSectionVisible
                              ? SizedBox(
                                key: const ValueKey('BlocksTabs'),
                                height: 360,
                                child: BlocksTabs(blocks: _testScreen.blocks),
                              )
                              : const SizedBox.shrink(),
                    ),
                    HorizontalBottomBar(
                      iconButton:
                          !_isAddSectionVisible
                              ? 'lib/design/assets/icons/add.svg'
                              : 'lib/design/assets/icons/down.svg',
                      onTerminalPressed: () => _showTerminalPanel(context),
                      onAddPressed: () => _toggleAddSection(),
                      onSavePressed: () => _saveScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return PopScope(
        canPop: false,
        child: Stack(
          children: [
            _testScreen,
            Stack(
              children: [
                if (_isDebugConsoleOpen)
                  Positioned(
                    height: 200,
                    top: 180,
                    left: 50,
                    child: DebugConsole(
                      onClose: _toggleDebugConsole,
                      debugConsoleService: _testScreen.debugConsoleService,
                    ),
                  ),
                if (_testScreen.debugNotifier.getDebugMode())
                  Align(
                    alignment: Alignment.topCenter,
                    child: HorizontalDebugBar(
                      onNextPressed: () {
                        _testScreen.engine.next();
                      },
                      onStopPressed: () {
                        _testScreen.debugNotifier.setDebugMode(false);
                        _testScreen.engine.resume(_testScreen.debugNotifier);
                        _testScreen.selectedBlockService.clear();
                      },
                      onMenuPressed: () {
                        _toggleDebugConsole();
                      },
                    ),
                  ),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: VerticalTopBar(
                        play: () {
                          _testScreen.consoleService.clear();
                          _testScreen.debugNotifier.setDebugMode(false);
                          _testScreen.engine.run(
                            _testScreen.nodeGraph,
                            _testScreen.registry,
                            _testScreen.consoleService,
                            _testScreen.debugConsoleService,
                            _testScreen.selectedBlockService,
                            _testScreen.state,
                            _testScreen.debugNotifier,
                            context,
                          );
                        },
                        debug: () {
                          _testScreen.consoleService.clear();
                          _toggleDebugMode();
                          _testScreen.debugNotifier.setDebugMode(true);
                          _testScreen.engine.run(
                            _testScreen.nodeGraph,
                            _testScreen.registry,
                            _testScreen.consoleService,
                            _testScreen.debugConsoleService,
                            _testScreen.selectedBlockService,
                            _testScreen.state,
                            _testScreen.debugNotifier,
                            context,
                          );
                        },
                        state: _testScreen.state,
                        debugNotifier: _testScreen.debugNotifier,
                        stop: () {
                          _testScreen.engine.stop(
                            _testScreen.debugNotifier,
                            _testScreen.state,
                          );
                          _testScreen.selectedBlockService.clear();
                        },
                      ),
                    ),
                    Expanded(child: Center()),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        );
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(2, 0),
                            end: Offset.zero,
                          ).animate(curvedAnimation),
                          child: child,
                        );
                      },
                      child:
                          _isAddSectionVisible
                              ? SizedBox(
                                key: const ValueKey('BlocksTabs'),
                                height: 360,
                                child: BlocksTabs(blocks: _testScreen.blocks),
                              )
                              : const SizedBox.shrink(),
                    ),
                    VerticalBottomBar(
                      iconButton:
                          !_isAddSectionVisible
                              ? 'lib/design/assets/icons/add.svg'
                              : 'lib/design/assets/icons/right.svg',
                      onTerminalPressed: () => _showTerminalPanel(context),
                      onAddPressed: () => _toggleAddSection(),
                      onSavePressed: () => _saveScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
