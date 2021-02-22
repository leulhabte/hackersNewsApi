import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/comment.dart';
import 'package:news/src/widgets/loading_container.dart';
import 'dart:async';

class NewsDetail extends StatelessWidget {
  final itemId;
  NewsDetail({this.itemId});
  @override
  Widget build(BuildContext context) {
    final bloc = CommentProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('News Detail'),),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentBloc bloc){
    return StreamBuilder(
      stream: bloc.itemWithComment,
      builder: (context,AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot){
        if(!snapshot.hasData) return LoadingContainer();

        final itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot){
            if(!itemSnapshot.hasData) return LoadingContainer();

            // return Text(itemSnapshot.data.title);
            return buildList(itemSnapshot.data, snapshot.data);
          },
        );

      },
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap){
    final children = <Widget>[];
    children.add(buildTitle(item));
    final comments = item.kids.map((kidId){
      return Comment(itemId: kidId, itemMap: itemMap, depth: 0,);
    }).toList();
    children.addAll(comments);

    return ListView(
      children: children,
    );
  }

  Widget buildTitle(ItemModel item){
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(item.title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }

}
