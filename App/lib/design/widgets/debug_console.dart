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
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.4,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.3,
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Переменные",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall,
                ),
              ),
              SizedBox(height: 10),
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
      ),
    );
  }
}