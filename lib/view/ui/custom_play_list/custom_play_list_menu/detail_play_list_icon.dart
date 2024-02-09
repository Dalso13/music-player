import 'package:flutter/material.dart';

class DetailPlayListIcon extends StatelessWidget {
  final Function() _changeTitle;
  final Function() _viewMenu;

  const DetailPlayListIcon({
    super.key,
    required Function() changeTitle,
    required Function() viewMenu,
  })  : _changeTitle = changeTitle,
        _viewMenu = viewMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Ink(
          decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).disabledColor, width: 1.0),
            shape: BoxShape.circle,
          ),
          child: IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return _changeTitle();
                  },
                );
              },
              icon: const Icon(Icons.border_color)),
        ),
        Ink(
          decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).disabledColor, width: 1.0),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                builder: (context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.3,
                    builder: (context, scrollController) {
                      return _viewMenu();
                    }
                  );
                },
              );
            },
            icon: const Icon(
              Icons.more_horiz,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

}
