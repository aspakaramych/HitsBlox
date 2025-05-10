part of 'widgets.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback onTerminalPressed;
  final VoidCallback onAddPressed;

  const BottomBar({
    super.key,
    required this.onTerminalPressed,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      height: 70,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'lib/design/assets/icons/home.svg',
                  width: 40,
                  height: 40,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                'lib/design/assets/icons/terminal.svg',
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
              onPressed: onTerminalPressed,
            ),
            IconButton(
              icon: SvgPicture.asset(
                'lib/design/assets/icons/add.svg',
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
              onPressed: onAddPressed,
            ),
            IconButton(
              icon: SvgPicture.asset(
                'lib/design/assets/icons/download.svg',
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: SvgPicture.asset(
                'lib/design/assets/icons/settings.svg',
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}