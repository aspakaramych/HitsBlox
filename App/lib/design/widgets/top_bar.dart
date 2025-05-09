part of 'widgets.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 150,
        height: 75,
        margin: EdgeInsets.only(top: 40, right: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                maximumSize: Size(40, 40),
                minimumSize: Size(40, 40),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: SvgPicture.asset(
                'lib/design/assets/icons/play.svg',
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                maximumSize: Size(40, 40),
                minimumSize: Size(40, 40),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: SvgPicture.asset(
                'lib/design/assets/icons/debug.svg',
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            )
          ],
        ),
      )
    );
  }
}