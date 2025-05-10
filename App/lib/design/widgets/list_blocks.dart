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
    return GestureDetector(
      onTap: widget.item.action,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Center(
          child: Text(
            widget.item.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
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

class BlocksList extends StatefulWidget {
  final List<Block> blocks;

  BlocksList({required this.blocks});

  @override
  State<BlocksList> createState() => _BlocksListState();
}

class _BlocksListState extends State<BlocksList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: BlocksGrid(blocks: widget.blocks),
      ),
    );
  }
}