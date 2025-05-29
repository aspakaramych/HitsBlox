part of 'widgets.dart';

void showDeleteConfirmationDialog(BuildContext context, String fileName, Future<void> Function(String) delete ) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Подтверждение удаления'),
        content: Text('Вы уверены, что хотите удалить файл "$fileName"? Это действие нельзя будет отменить.'),
        actions: <Widget>[
          TextButton(
            child: Text('Отмена'),
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Удалить'),
            onPressed: () async {
              Navigator.of(dialogContext).pop(true);
              await delete(fileName);
            },
          ),
        ],
      );
    },
  ).then((confirmed) {
    if (confirmed != null && confirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Файл удалён!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Удаление отменено.')),
      );
    }
  });
}
