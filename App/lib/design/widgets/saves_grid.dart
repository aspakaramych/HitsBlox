part of 'widgets.dart';

class GridSaves extends StatefulWidget {
  const GridSaves({super.key});

  @override
  State<GridSaves> createState() => _GridSavesState();
}

class _GridSavesState extends State<GridSaves> {
  int itemCount = 0;
  List<String> keys = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSharedPreferences();
    });
  }

  Future<void> loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      keys = prefs.getKeys().toList();
      itemCount = keys.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 600),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          final String key = keys[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(screenName: key),
                ),
              );
            },
            child: Card(
              color: Theme.of(context).colorScheme.primaryFixed,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  'Сохранение $key',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
