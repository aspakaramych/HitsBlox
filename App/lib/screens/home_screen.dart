import 'package:app/screens/storage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/design/widgets/widgets.dart';
import 'package:app/design/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  bool _showStorage = false;

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

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _showStorage = true;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _showStorage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(alignment:Alignment.bottomCenter, child: Container(margin: EdgeInsets.symmetric(horizontal: 40), child: GridSaves())),
                      ),
                      Container(margin: EdgeInsets.symmetric(vertical: 20), child: SvgPicture.asset("lib/design/assets/icons/scroll.svg")),
                      BottomBar(
                          onTerminalPressed: () {},
                          onAddPressed: () {},
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