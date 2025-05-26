part of "widgets.dart";

class DebugConsole extends StatefulWidget {

  final VoidCallback onClose;
  final DebugConsoleService debugConsoleService;

  const DebugConsole({
    super.key,
    required this.onClose,
    required this.debugConsoleService
  });

  @override
  State<DebugConsole> createState() => _DebugConsoleState();
}

class _DebugConsoleState extends State<DebugConsole> {
  late List<String> logs;

  @override
  void initState() {
    super.initState();
    logs = widget.debugConsoleService.logs;
    widget.debugConsoleService.addListener(_updateLogs);
  }

  void _updateLogs() {
    setState(() {
      logs = widget.debugConsoleService.logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(10),
        width: 250,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.3,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            Text(
              "Переменные",
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: ListView(
                  children: [
                    Text(
                      '>${logs.join('\n>')}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}