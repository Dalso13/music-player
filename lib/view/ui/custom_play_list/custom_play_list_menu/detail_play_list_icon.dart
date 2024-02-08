import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui/custom_play_list/custom_play_list_menu/play_lists_dialog.dart';
import 'package:provider/provider.dart';

import '../../../view_model/play_list_view_model.dart';
import 'only_one_play_list_menu.dart';

class DetailPlayListIcon extends StatelessWidget {
  final String _title;
  final int _modelKey;

  const DetailPlayListIcon({
    super.key,
    required String title,
    required int modelKey,
  })  : _title = title,
        _modelKey = modelKey;

  @override
  Widget build(BuildContext context) {
    final PlayListViewModel playListViewModel =
        context.watch<PlayListViewModel>();
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
                playListViewModel.textEditingController.text = _title;
                final viewModel =
                    Provider.of<PlayListViewModel>(context, listen: false);
                showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                        value: viewModel,
                        child: PlayListsDialog(
                          modalKey: _modelKey,
                        ));
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
              final viewModel =
                  Provider.of<PlayListViewModel>(context, listen: false);
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
                    builder: (context, scrollController) =>
                        ChangeNotifierProvider.value(
                            value: viewModel,
                            child: OnlyOnePlayListMenu(modelKey: _modelKey)),
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
