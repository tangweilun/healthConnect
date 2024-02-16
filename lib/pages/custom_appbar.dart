import 'package:flutter/material.dart';
import 'package:health_connect/theme/colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.appTitle,
    this.route,
    this.icon,
    this.actions,
  }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(60);

  final String? appTitle;
  final String? route;
  final Icon? icon;
  final List<Widget>? actions;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.appTitle!,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),

      //if icon is not set, return null
      leading: widget.icon != null
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: mediumBlueGrayColor,
              ),
              child: IconButton(
                icon: widget.icon!,
                iconSize: 16,
                color: Colors.white,
                onPressed: () {
                  //if route is given , then this icon button will navigate to
                  if (widget.route != null) {
                    Navigator.of(context).pushNamed(widget.route!);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ))
          : null,
      actions: widget.actions ?? null,
    );
  }
}
