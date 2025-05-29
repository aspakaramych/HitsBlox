part of 'widgets.dart';

class HorizontalBottomBar extends StatelessWidget {
  final VoidCallback? onTerminalPressed;
  final VoidCallback? onAddPressed;
  final VoidCallback? onSavePressed;
  final String iconButton;
  final List<String> inactiveButtons;
  final String activeButton;

  final String shape = "M375 62.1514C375 67.6742 370.523 72.1514 365 72.1514H15C9.47715 72.1514 5 67.6742 5 62.1514V13C5 7.47715 9.47715 3 15 3H141.654C145.577 3 149.056 5.34976 151.162 8.65935C159.324 21.4884 173.668 30 190 30C206.332 30 220.676 21.4884 228.838 8.65935C230.944 5.34976 234.423 3 238.346 3H365C370.523 3 375 7.47715 375 13V62.1514Z";

  HorizontalBottomBar({
    super.key,
    required this.onTerminalPressed,
    required this.onAddPressed,
    required this.onSavePressed,
    String? iconButton,
    List<String>? inactiveButtons,
    String? activeButton
  }) : iconButton = iconButton ?? 'lib/design/assets/icons/add.svg', inactiveButtons = inactiveButtons ?? [], activeButton = activeButton ?? '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 151,
      color: Colors.transparent,
      padding: EdgeInsets.only(bottom: 20, right: 20, left: 20),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
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
                  height: 80,
                  // width: MediaQuery.of(context).size.width + 40,
                  width: 370,
                ),
              ),
            ),
          ),

          ClipPath(
            clipper: CustomSvgClipper(shape),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 370),
              child: Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: (activeButton == 'home') ? Theme.of(context).colorScheme.surfaceContainer : Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
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
                            '/home'
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'lib/design/assets/icons/terminal.svg',
                        width: 40,
                        height: 40,
                        colorFilter: ColorFilter.mode(
                            (onTerminalPressed != null) ? Theme.of(context).colorScheme.onSecondaryContainer : Theme.of(context).colorScheme.outline, BlendMode.srcIn),
                      ),
                      onPressed: onTerminalPressed,
                    ),
                    SizedBox(width: 40,),
                    IconButton(
                      icon: SvgPicture.asset(
                        'lib/design/assets/icons/download.svg',
                        width: 40,
                        height: 40,
                        colorFilter: ColorFilter.mode(
                            (onSavePressed != null) ? Theme.of(context).colorScheme.onSecondaryContainer : Theme.of(context).colorScheme.outline, BlendMode.srcIn),
                      ),
                      onPressed: onSavePressed,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: (activeButton == 'settings') ? Theme.of(context).colorScheme.surfaceContainer : Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
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
                              '/settings'
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 60,
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
                    iconButton,
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

class CustomSvgClipper extends CustomClipper<Path> {
  final String svgPath;

  CustomSvgClipper(this.svgPath);

  @override
  Path getClip(Size size) {
    Path path = parseSvgPathData(svgPath);

    Rect originalBounds = path.getBounds();
    double originalWidth = originalBounds.width;
    double originalHeight = originalBounds.height;

    double scaleX = size.width / originalWidth;
    double scaleY = size.height / originalHeight;

    Matrix4 matrix = Matrix4.identity()
      ..scale(scaleX, scaleY)
      ..translate(-originalBounds.left, -originalBounds.top);

    return path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(CustomSvgClipper oldDelegate) => true;
}

class BottomBarShadowPainter extends CustomPainter {
  final String svgPath;

  BottomBarShadowPainter(this.svgPath);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = parseSvgPathData(svgPath);
    Rect originalBounds = path.getBounds();
    double scaleX = size.width / originalBounds.width;
    double scaleY = size.height / originalBounds.height;

    Matrix4 matrix = Matrix4.identity()
      ..scale(scaleX, scaleY)
      ..translate(-originalBounds.left, -originalBounds.top);

    Path transformedPath = path.transform(matrix.storage);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawPath(transformedPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}