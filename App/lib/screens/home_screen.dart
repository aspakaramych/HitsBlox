import 'package:app/screens/storage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/design/widgets/widgets.dart';
import 'package:app/design/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  bool _showFullGrid = false;
  int cnt = 4;

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
    cnt += 1;
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StorageScreen()));
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _showFullGrid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: SizedBox(
                  height: constraints.maxHeight * 2,
                  child: Center(),
                ),
              );
            },
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: Align(
                    alignment: Alignment.center,
                    child: GridSaves(),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showFullGrid ? 0 : 1,
                duration: Duration(milliseconds: 300),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: SvgPicture.asset("lib/design/assets/icons/scroll.svg"),
                  ),
                ),
              ),
              BottomBar(onTerminalPressed: () {}, onAddPressed: () {},),
            ],
          ),
        ]
      ),
    );
  }
}