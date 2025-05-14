part of 'widgets.dart';

class Console extends StatefulWidget {
  final ConsoleService consoleService;

  const Console({
    super.key,
    required this.consoleService,
  });

  @override
  State<Console> createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  late ConsoleService _consoleService;

  @override
  void initState() {
    super.initState();
    _consoleService = widget.consoleService;
  }

  void _onLogsChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _consoleService.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = _consoleService.logs;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Консоль",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
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
                    style: TextStyle(fontFamily: 'monospace', fontSize: 14, color: AppColors.text),
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