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
      keys.remove('9d6b82da-eaec-4634-8bdb-743f029cb961');
      keys.remove('95a51e91-aa1c-46b4-9591-0ee3f9fb5e39');
      if (keys.length >= 4) {
        keys.insert(3, "Новое сохранение");
      } else {
        keys.add("Новое сохранение");
      }
      itemCount = min(4, keys.length);
    });
  }

  Future<void> _deleteSave(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);

    setState(() {
      keys.remove("Новое сохранение");
      keys.remove(key);
      if (keys.length >= 4) {
        keys.insert(3, "Новое сохранение");
      } else {
        keys.add("Новое сохранение");
      }
      itemCount = min(4, keys.length);
    });
  }

  Future<Map<String, dynamic>?> _loadScreen(String screenName) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(screenName);

    final savedState = jsonDecode(jsonString!) as Map<String, dynamic>;
    return savedState;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 500),
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
          return Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  var savedState = null;
                  if (key != "Новое сохранение") {
                    savedState = await _loadScreen(key);
                  }
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              key != "Новое сохранение"
                                  ? MainScreen(savedState, screenName: key)
                                  : MainScreen(
                                    'create_new_screen',
                                    screenName: '',
                                  ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    if (key != "Новое сохранение")
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              '$key',
                              // maxLines: 1,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      )
                    else if (key == "Новое сохранение")
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'lib/design/assets/icons/add.svg',
                            width: 40,
                            height: 40,
                            colorFilter: ColorFilter.mode(
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (key != "Новое сохранение")
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap:
                        () => showDeleteConfirmationDialog(
                          context,
                          key,
                          _deleteSave,
                        ),
                    child: SvgPicture.asset(
                      'lib/design/assets/icons/trash.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.error,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
