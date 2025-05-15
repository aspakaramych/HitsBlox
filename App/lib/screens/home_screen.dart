import 'package:app/screens/storage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app/design/widgets/widgets.dart';
import 'package:app/design/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  bool _isStorageVisible = false;
  bool _hasSnapped = false;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_isAnimating) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final offset = _scrollController.offset;

    if (offset > 0 && !_hasSnapped) {
      _isAnimating = true;
      await _snapToStorage();
      _isAnimating = false;
    } else if (offset < screenHeight && _hasSnapped) {
      _isAnimating = true;
      await _snapToMain();
      _isAnimating = false;
    }
  }

  Future<void> _snapToStorage() async {
    final screenHeight = MediaQuery.of(context).size.height;
    await _scrollController.animateTo(
      screenHeight,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );

    if (mounted) {
      setState(() {
        _hasSnapped = true;
      });
    }
  }

  Future<void> _snapToMain() async {
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    if (mounted) {
      setState(() {
        _hasSnapped = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverFillRemaining(
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(alignment:Alignment.bottomCenter, child: Container(margin: EdgeInsets.symmetric(horizontal: 40), child: GridSaves())),
                      ),
                      Container(margin: EdgeInsets.symmetric(vertical: 0), child: SvgPicture.asset("lib/design/assets/icons/scroll.svg")),
                      BottomBar(
                          onTerminalPressed: () {},
                          onAddPressed: () {},
                          onSavePressed: () {},
                        ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: StorageScreen(),
                  ),
              ],
            )
          ),
        ],
      ),
    );
  }
}