import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_bloc.dart';
export 'package:news/src/blocs/comments_bloc.dart';

class CommentProvider extends InheritedWidget{
  final CommentBloc bloc;

  CommentProvider({Key key, Widget child})
    : bloc = CommentBloc(),
      super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static CommentBloc of (BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<CommentProvider>()).bloc;
  }
}