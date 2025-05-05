part of 'widgets.dart';

class Console extends StatefulWidget {
  final String initialOutput;

  const Console({Key? key, this.initialOutput = ""}) : super(key: key);

  @override
  State<Console> createState() => ConsoleState();
}

class ConsoleState extends State<Console> {
  late String currentOutput;

  void appendText(String newText) {
    setState(() {
      currentOutput += "\n$newText";
    });
  }

  @override
  void initState() {
    super.initState();
    currentOutput = widget.initialOutput;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 100),
      height: 500,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Консоль", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text), textAlign: TextAlign.left,),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Text(currentOutput,
                  style: TextStyle(fontSize: 14, fontFamily: 'monospace', color: AppColors.text),
                  textAlign: TextAlign.left,),
              ),
            )
          ),
        ],
      ),
    );
  }
}