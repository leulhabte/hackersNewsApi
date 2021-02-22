import 'package:rxdart/rxdart.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/repository.dart';

class StoriesBloc{
  final _topIds = PublishSubject<List<int>>();
  // final _items = BehaviorSubject<int>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemFetcher = PublishSubject<int>();
  final _repository = Repository();

  // Stream<Map<int, Future<ItemModel>>> item;

  // TopIds Getter Stream
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Exposing Stream with only exposing the ScanStreamTransformer one time
  StoriesBloc(){
    // item = _items.stream.transform(_itemTransformer());
      _itemFetcher.stream.transform(_itemTransformer()).pipe(_itemsOutput);
  }

  // Items Sink Getter
  Function(int) get fetchItem => _itemFetcher.sink.add;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache(){
    return _repository.clearCache();
  }

  _itemTransformer(){
    return ScanStreamTransformer(
        // cache is a reference to the map {}
        (Map<int, Future<ItemModel>>cache, int id, index){ // func that gets invoked every time it gets new value
          //key
          print(index);
          cache[id] = _repository.fetchItem(id);
          return cache;
        },
        <int, Future<ItemModel>>{}
    );
  }

  dispose(){
    _topIds.close();
    _itemsOutput.close();
    _itemFetcher.close();
  }
}