part of 'widgets.dart';

class Block {
  late String name;
  VoidCallback action;

  Block({required this.name, required this.action});
}

class BlockCard extends StatefulWidget {
  final Block item;

  const BlockCard({super.key, required this.item});

  @override
  State<BlockCard> createState() => _BlockCardState();
}

class _BlockCardState extends State<BlockCard> {
  @override
  Widget build(BuildContext context) {
    final ToastService toastService = ToastService();
    late var hintsNotifier = Provider.of<HintsNotifier>(context, listen: false);
    return GestureDetector(
      onTap: () {
        widget.item.action();
        toastService.Show(
          context,
          widget.item.name,
          hintsNotifier.areHintsEnabled,
        );
      },
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        elevation: 5,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  widget.item.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.shadow.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, -5),
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

class BlocksGrid extends StatefulWidget {
  final List<Block> blocks;

  const BlocksGrid({super.key, required this.blocks});

  @override
  State<BlocksGrid> createState() => _BlocksGridState();
}

class _BlocksGridState extends State<BlocksGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
      ),
      itemCount: widget.blocks.length,
      itemBuilder: (context, index) {
        return BlockCard(item: widget.blocks[index]);
      },
    );
  }
}

class BlocksTabs extends StatefulWidget {
  final Map<String, List<Block>> blocks;

  BlocksTabs({required this.blocks});

  @override
  State<BlocksTabs> createState() => _BlocksTabsState();
}

class _BlocksTabsState extends State<BlocksTabs>
    with SingleTickerProviderStateMixin {
  late var hintsNotifier = Provider.of<HintsNotifier>(context);
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.blocks.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Material(
        elevation: 5,
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                enableFeedback: true,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                tabs: [
                  for (var item in widget.blocks.entries) Tab(text: item.key),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  for (var item in widget.blocks.entries)
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: BlocksGrid(blocks: item.value),
                    ),
                ],
              ),
            ),
            if (hintsNotifier.areHintsEnabled)
              Text(
                "удаление - длинное нажатие по блоку",
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
