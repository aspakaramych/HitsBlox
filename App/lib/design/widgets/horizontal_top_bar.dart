part of 'widgets.dart';

class HorizontalTopBar extends StatefulWidget {
  final VoidCallback debug;
  final VoidCallback play;
  final EngineState state;

  const HorizontalTopBar({
    super.key,
    required this.play,
    required this.debug,
    required this.state,
  });

  @override
  State<HorizontalTopBar> createState() => _HorizontalTopBarState();
}

class _HorizontalTopBarState extends State<HorizontalTopBar> {
  late bool _areRunning;

  @override
  void initState(){
    super.initState();
    _areRunning = widget.state.getAreRunning();
    widget.state.addListener(_updateIcon);
  }

  void _updateIcon(){
    setState(() {
      _areRunning = widget.state.getAreRunning();
    });
  }

  @override
  void dispose() {
    widget.state.removeListener(_updateIcon);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 70,
      margin: EdgeInsets.only(top: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: (!_areRunning)
                    ? widget.play
                    : () {widget.state.setRunning(false);},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  maximumSize: Size(40, 40),
                  minimumSize: Size(40, 40),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: SvgPicture.asset(
                  (!_areRunning)
                      ? 'lib/design/assets/icons/play.svg'
                      : 'lib/design/assets/icons/stop.svg',
                  width: 40,
                  height: 40,
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn),
                ),
              ),
              ElevatedButton(
                onPressed: widget.debug,
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
            ],
          ),
        ),
      ),
    );
  }
}