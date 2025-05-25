part of 'widgets.dart';

class VerticalTopBar extends StatelessWidget {
  final VoidCallback play;
  final VoidCallback debug;

  const VerticalTopBar({
    super.key,
    required this.play,
    required this.debug,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 150,
      margin: EdgeInsets.only(top: 20, left: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: debug,
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
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn),
                ),
              ),
              ElevatedButton(
                onPressed: play,
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
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}