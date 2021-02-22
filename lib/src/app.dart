import 'package:flutter/material.dart';
import 'package:news/src/screens/news_list.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/screens/news_detail.dart';
import 'package:news/src/blocs/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentProvider(
      child: StoriesProvider(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'News',
            onGenerateRoute: route
        ),
      ),
    );
  }

  Route route(RouteSettings settings){
    if(settings.name == '/'){
      return MaterialPageRoute(
        builder: (context){
          final bloc = StoriesProvider.of(context);
          bloc.fetchTopIds();
          return NewsList();
        }
      );
    }else{
      return MaterialPageRoute(
        builder: (context){
          final itemId = int.parse(settings.name.replaceFirst('/', ''));
          final commentBloc = CommentProvider.of(context);
          commentBloc.fetchItemWithComment(itemId);
          return NewsDetail(itemId: itemId,);
        }
      );
    }
  }
}
