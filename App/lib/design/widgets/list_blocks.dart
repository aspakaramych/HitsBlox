part of 'widgets.dart';

final ITEMS = [
  Item(
    id: '1',
    title: 'Блок 1',
    subtitle: '',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Item(
    id: '2',
    title: 'Блок 2',
    subtitle: 'обновлено 03.05.2025',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Item(
    id: '3',
    title: 'Блок 3',
    subtitle: 'обновлено 03.05.2025',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Item(
    id: '4',
    title: 'Блок 4',
    subtitle: 'обновлено 03.05.2025',
    imageUrl: 'https://via.placeholder.com/150',
  ),
];

class Item {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;

  Item({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class ItemCard extends StatefulWidget {
  final Item item;

  const ItemCard({required this.item});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              widget.item.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  widget.item.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemsGrid extends StatefulWidget {
  final List<Item> items;

  const ItemsGrid({required this.items});

  @override
  State<ItemsGrid> createState() => _ItemsGridState();
}

class _ItemsGridState extends State<ItemsGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return ItemCard(item: widget.items[index]);
      },
    );
  }
}

class ItemsList extends StatefulWidget {
  final List<Item> items = ITEMS;

  // const ItemsList({required this.items});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: ItemsGrid(items: widget.items),
      ),
    );
  }
}