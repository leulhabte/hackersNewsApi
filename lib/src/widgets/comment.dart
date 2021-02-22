import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/loading_container.dart';
import 'dart:async';

class Comment extends StatelessWidget {
  final int itemId;
  final int depth;
  final Map<int, Future<ItemModel>> itemMap;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot){
        if(!snapshot.hasData) return LoadingContainer();

        final item = snapshot.data;

        final children = <Widget>[
          ListTile(
            title: buildText(item),
            subtitle: item.by == "" ? Text('Deleted') : Text(item.by),
            contentPadding: EdgeInsets.only(right: 16.0, left: (depth + 1) * 16.0),
          ),
          Divider()
        ];

        item.kids.forEach((kidId) {
          children.add(Comment(itemId: kidId, itemMap: itemMap, depth: depth + 1,));
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(ItemModel item){
    final text = item.text
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(text);
  }
}
