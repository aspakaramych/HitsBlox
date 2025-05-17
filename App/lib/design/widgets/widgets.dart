library;

import 'dart:convert';

import 'package:app/core/NodeGraph.dart';
import 'package:app/core/literals/VariableLiteral.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/screens/settings_screen.dart';
import 'package:app/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:app/core/Engine.dart';

import '../../core/ConsoleService.dart';

part 'bottom_bar.dart';
part 'top_bar.dart';
part 'console.dart';
part 'list_blocks.dart';
part 'saves_grid.dart';