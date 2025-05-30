part of "widgets.dart";

class HorizontalDebugBar extends StatelessWidget {
  final VoidCallback onNextPressed;
  final VoidCallback onStopPressed;
  final VoidCallback onMenuPressed;
  const HorizontalDebugBar({super.key, required this.onNextPressed, required this.onStopPressed, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            children: [
              CustomIconButton(
                  pic: 'lib/design/assets/icons/next.svg',
                  function: onNextPressed,
                  color: Theme.of(context).colorScheme.onSecondaryContainer
              ),
              CustomIconButton(
                  pic: 'lib/design/assets/icons/to_end.svg',
                  function: onStopPressed,
                  color: Theme.of(context).colorScheme.onSecondaryContainer
              ),
              CustomIconButton(
                  pic: 'lib/design/assets/icons/bug-folder.svg',
                  function: onMenuPressed,
                  color: Theme.of(context).colorScheme.onSecondaryContainer)
            ],
          ),
        ),
      )
    );
  }
}