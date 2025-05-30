part of "widgets.dart";

class CustomIconButton extends StatelessWidget {
  final String pic;
  final VoidCallback function;
  final Color color;
  late double width = 40;
  late double height = 40;

  CustomIconButton({
    super.key,
    required this.pic,
    required this.function,
    required this.color,
    this.width = 40,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        pic,
        width: width,
        height: height,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
      onPressed: function,
    );
  }
}
