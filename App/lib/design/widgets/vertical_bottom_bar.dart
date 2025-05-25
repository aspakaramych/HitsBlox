part of 'widgets.dart';

class VerticalBottomBar extends StatelessWidget {
  final VoidCallback onTerminalPressed;
  final VoidCallback onAddPressed;
  final VoidCallback onSavePressed;

  final String shape = "M59.1514 370C64.6742 370 69.1514 365.523 69.1514 360V10C69.1514 4.47715 64.6742 0 59.1514 0H10C4.47715 0 0 4.47715 0 10V136.654C0 140.577 2.34976 144.056 5.65935 146.162C18.4884 154.324 27 168.668 27 185C27 201.332 18.4884 215.676 5.65935 223.838C2.34976 225.944 0 229.423 0 233.346V360C0 365.523 4.47715 370 10 370H59.1514Z";

  const VerticalBottomBar({
    super.key,
    required this.onTerminalPressed,
    required this.onAddPressed,
    required this.onSavePressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: double.infinity,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          PhysicalModel(
            elevation: 10,
            color: Colors.transparent,
            shadowColor: Colors.black.withOpacity(0.0001),
            clipBehavior: Clip.none,
            shape: BoxShape.rectangle,
            child: Container(
              child: CustomPaint(
                painter: BottomBarShadowPainter(shape),
                child: SizedBox(
                  height: 370,
                  width: 80,
                ),
              ),
            ),
          ),

          ClipPath(
            clipper: CustomSvgClipper(shape),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 370),
              child: Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'lib/design/assets/icons/settings.svg',
                        width: 40,
                        height: 40,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(
                            context,
                            '/settings',
                          ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'lib/design/assets/icons/download.svg',
                        width: 40,
                        height: 40,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn),
                      ),
                      onPressed: onSavePressed,
                    ),
                    SizedBox(width: 40,),
                    IconButton(
                      icon: SvgPicture.asset(
                        'lib/design/assets/icons/terminal.svg',
                        width: 40,
                        height: 40,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn),
                      ),
                      onPressed: onTerminalPressed,
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'lib/design/assets/icons/home.svg',
                        width: 40,
                        height: 40,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/home',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            right: 60,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'lib/design/assets/icons/add.svg',
                    width: 55,
                    height: 55,
                    colorFilter:
                    ColorFilter.mode(Theme.of(context).colorScheme.onPrimaryContainer, BlendMode.srcIn),
                  ),
                  onPressed: onAddPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}