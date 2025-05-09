import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/screens/main_screen.dart';
import 'package:app/design/widgets/widgets.dart';
import 'package:app/design/theme/colors.dart';

class StorageSaves extends StatelessWidget {
  final int itemCount;

  const StorageSaves({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 🔽 Добавляем пустой слайвер с нужным padding
        SliverPadding(
          padding: const EdgeInsets.only(top: 40), // ← Задаём отступ сверху
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },
                  child: Card(
                    color: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text('Сохранение $index'),
                    ),
                  ),
                );
              },
              childCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }
}

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      color: AppColors.background,
      height: double.infinity,
      width: double.infinity,
      child: StorageSaves()
    );
  }
}