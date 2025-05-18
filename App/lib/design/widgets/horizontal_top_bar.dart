part of 'widgets.dart';

class HorizontalTopBar extends StatelessWidget {
  final Engine play;
  final VariableRegistry registry;
  final NodeGraph nodeGraph;

  const HorizontalTopBar({super.key, required this.play, required this.nodeGraph, required this.registry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 70,
      margin: EdgeInsets.only(top: 60, right: 20),
      // padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixed,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          // width: 150,
          // height: 70,
          // margin: EdgeInsets.only(top: 60, right: 20),
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryFixed,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => play.run(nodeGraph, registry),
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
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimaryFixed, BlendMode.srcIn),
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
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimaryFixed, BlendMode.srcIn),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}