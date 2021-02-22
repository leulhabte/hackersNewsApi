import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc.dart';
export 'package:news/src/blocs/stories_bloc.dart';

class StoriesProvider extends InheritedWidget{
  final StoriesBloc bloc;

  StoriesProvider({Key key, Widget child})
  : bloc = StoriesBloc(),
    super(child: child);

  bool updateShouldNotify(_) => true;

  static StoriesBloc of (BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<StoriesProvider>()).bloc;
  }
}