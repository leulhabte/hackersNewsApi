import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/repository.dart';

class NewsDbProvider implements Source, Cache{
  Database db;

  // Todo
  @override
  Future<List<int>> fetchTopIds() {
    // TODO: implement fetchTopIds
    throw UnimplementedError();
  }

  NewsDbProvider(){
    init();
  }

  // initialize the database
  void init() async{
    // reference to a directory inside our mobile device
    Directory documents = await getApplicationDocumentsDirectory();
    final path = join(documents.path, 'items2.db'); // reference to a db directory

    // attempts to create db or open an existing db
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version){
        newDb.execute("""
          CREATE TABLE Items(
            id INTEGER PRIMARY KEY,
            type TEXT,
            deleted INTEGER,
            by TEXT,
            time INTEGER,
            text TEXT,
            dead INTEGER,
            parent INTEGER,
            kids BLOB,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        """);
      }
    );
  }

  Future<ItemModel> fetchItem(int id) async {
    final map = await db.query(
        'Items',
        columns: null,
        where: "id = ?",
        whereArgs: [id]
    );

    if(map.length > 0){
      return ItemModel.fromDb(map.first);
    }

    return null;
  }

  // add item to db
  Future<int> addItem(ItemModel item){
    return db.insert('Items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  clear(){
    return db.delete('Items');
  }
}

final newsDbProvider = NewsDbProvider();