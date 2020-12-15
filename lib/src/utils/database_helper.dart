import 'package:flutter_productos/src/model/producto_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  DatabaseHelper._createInstance();
  static Database _database;

  String productTable = 'productos';
  String colId = 'id';
  String colName = 'nombre';
  String colPrice = 'precio';
  String colQuantity = 'cantidad';
  String colDetail = 'detalle';

  factory DatabaseHelper() {
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'products.db';

    // Open/create the database at a given path
    var productDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return productDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $productTable($colId INTEGER PRIMARY KEY, $colName TEXT, '
        '$colPrice DOUBLE, $colQuantity DOUBLE, $colDetail TEXT)');
  }

  Future<int> insertProduct(Producto prod) async {
    Database db = await this.database;
    var result = await db.insert(productTable, prod.toMap());
    return result;
  }

  Future<int> updateNote(Producto prod) async {
    var db = await this.database;
    var result = await db.update(productTable, prod.toMap(),
        where: '$colId = ?', whereArgs: [prod.id]);
    return result;
  }

  Future<int> deleteProduct(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $productTable WHERE $colId = $id');
    return result;
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getProductMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $productTable');
    //var result = await db.query(productTable);
    return result;
  }

  // Get number of Product objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $productTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Producto>> getProductList() async {
    var productMapList =
        await getProductMapList(); // Get 'Map List' from database
    int count =
        productMapList.length; // Count the number of map entries in db table

    List<Producto> productList = List<Producto>();
    // For loop to create a 'Product List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      productList.add(Producto.fromMapObject(productMapList[i]));
    }

    return productList;
  }
}
