import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({
    super.key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.black,
  });

  final String title;
  final String description;
  final Color backgroundColor;
  final Color textColor;

  static void showCustomToast(BuildContext context, String title, String message, Color color) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 2),
        child: CustomToast(
          title: title,
          description: message,
          backgroundColor: color,
          textColor: Colors.white,
        ),
      ),
    );
  }

  static void showCustomToastWithDuration(BuildContext context, String title, String message, Color color, int sec) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: sec),
        child: CustomToast(
          title: title,
          description: message,
          backgroundColor: color,
          textColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: const Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(description, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 10, width: 8),
          IconButton(
            icon: Icon(Icons.close, size: 25, color: Colors.white,),
            onPressed: () => Toastify.of(context).remove(this),
          ),
        ],
      ),
    );
  }
}