import 'package:news/src/resources/repository.dart';
import 'package:news/src/models/item_model.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class CommentBloc{
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Stream
  Stream<Map<int, Future<ItemModel>>> get itemWithComment => _commentOutput.stream;

  // Sink
  Function(int) get fetchItemWithComment => _commentsFetcher.sink.add;
  
  CommentBloc(){
    _commentsFetcher.stream.transform(_commentTransformer()).pipe(_commentOutput);
  }
  
  _commentTransformer(){
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
        (cache, int id, index){
          cache[id] = _repository.fetchItem(id);
          cache[id].then((ItemModel item) => {
            item.kids.forEach((element) {fetchItemWithComment(element);}) // recursion
          });
          return cache;
        },
        <int, Future<ItemModel>>{}
    );
  }

  dispose(){
    _commentOutput.close();
    _commentsFetcher.close();
  }
}