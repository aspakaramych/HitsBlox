part of 'widgets.dart';

class Console extends StatefulWidget {
  final ConsoleService consoleService;

  const Console({super.key, required this.consoleService});

  @override
  State<Console> createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  late ConsoleService _consoleService;
  late List<String> logs = [];

  @override
  void initState() {
    super.initState();
    _consoleService = widget.consoleService;
    _consoleService.addListener(_onLogsChanged);
  }

  void _onLogsChanged() {
    setState(() {
      logs = _consoleService.logs;
    );
  }

  @override
  void dispose() {
    _consoleService.removeListener(_onLogsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Консоль",
              style: Theme.of(context).textTheme.headlineSmall,
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
