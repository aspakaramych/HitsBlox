library;

import 'dart:convert';
import 'dart:math';

import 'package:app/core/node_graph.dart';
import 'package:app/core/debug_console_service.dart';
import 'package:app/core/literals/variable_literal.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/screens/settings_screen.dart';
import 'package:app/screens/test_screen.dart';
import 'package:app/utils/debug_notifier.dart';
import 'package:app/utils/engine_state.dart';
import 'package:app/utils/help_toast.dart';
import 'package:app/utils/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:app/core/engine.dart';
import 'package:toastify/toastify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/console_service.dart';
import '../../core/widgets/custom_toast.dart';
import '../../utils/hints_notifier.dart';

part 'horizontal_bottom_bar.dart';

part 'vertical_bottom_bar.dart';

part 'horizontal_top_bar.dart';

part 'vertical_top_bar.dart';

part 'console.dart';

part 'tab_blocks.dart';

part 'saves_grid.dart';

part 'bouncing_scroll.dart';

part 'vertical_debug_bar.dart';

part 'horizontal_debug_bar.dart';

part 'custom_icon_button.dart';

part 'debug_console.dart';

part 'about_section.dart';

part 'deletion_alert.dart';
