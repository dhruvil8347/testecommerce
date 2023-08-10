import 'package:flutter/cupertino.dart';

class AppConatainer extends StatelessWidget {
  const AppConatainer({
    Key? key, this.child,
    required this.title,

  }) : super(key: key);

  final Widget? child;
  final String title;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,


    );
  }
}
