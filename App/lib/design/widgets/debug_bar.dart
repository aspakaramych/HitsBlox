part of "widgets.dart";

class DebugBar extends StatelessWidget {
  final VoidCallback onNextPressed;
  final VoidCallback onStopPressed;
  const DebugBar({super.key, required this.onNextPressed, required this.onStopPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryFixed,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            children: [
              CustomIconButton(
                  pic: 'lib/design/assets/icons/next.svg',
                  function: onNextPressed,
                  color: Theme.of(context).colorScheme.onPrimaryFixed
              ),
              CustomIconButton(
                  pic: 'lib/design/assets/icons/stop.svg',
                  function: onStopPressed,
                  color: Theme.of(context).colorScheme.onPrimaryFixed
              ),
            ],
          ),
        ),
      )
    );
  }
}