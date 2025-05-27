part of 'widgets.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'О нас',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Это приложение создано командой [Оперативно придумываем название]. Мы очень старались.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Версия: 1.0.0',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () => _launchURL('https://github.com/aspakaramych/HitsBlox'),
                  icon: const Icon(Icons.web),
                  label: const Text('Наш github'),
                ),
                TextButton.icon(
                  onPressed: () => _launchURL('pomogite@stud.tsu.ru'),
                  icon: const Icon(Icons.email),
                  label: const Text('Связаться с нами'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Не удалось открыть $url';
    }
  }
}