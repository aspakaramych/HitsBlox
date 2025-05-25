part of 'widgets.dart';

class VerticalTopBar extends StatelessWidget {
  final Engine play;
  final VariableRegistry registry;
  final NodeGraph nodeGraph;
  final ConsoleService consoleService;
  final DebugConsoleService debugConsoleService;

  const VerticalTopBar({
    super.key,
    required this.play,
    required this.nodeGraph,
    required this.registry,
    required this.consoleService,
    required this.debugConsoleService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 150,
      margin: EdgeInsets.only(top: 20, left: 20),
      // padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
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
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
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
                  'lib/design/assets/icons/debug.svg',
                  width: 40,
                  height: 40,
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn),
                ),
              ),
              ElevatedButton(
                onPressed:
                    () =>
                        play.run(nodeGraph, registry, consoleService, debugConsoleService, context),
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