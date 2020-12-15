import 'package:flutter/material.dart';
import 'package:flutter_productos/src/model/producto_model.dart';
import 'package:flutter_productos/src/screens/add.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter_productos/src/utils/database_helper.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Producto> productos;
  TextEditingController editingController = TextEditingController();
  final List<Producto> productosDuplicado = List<Producto>();
  Set<int> ides = Set<int>();
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (productos == null) {
      productos = List<Producto>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterProductos'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _botonTexto(context),
              _lista(),
            ],
          ),
        ),
      ),
    );
  }

  _botonTexto(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: new Column(
        children: <Widget>[
          RaisedButton(
            child: Text(
              "Añadir Producto",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              _windowAddEditDetail(
                  Producto(0, '', 0.0, 0.0, ''), "Añadir Producto");
            },
            color: Colors.green,
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: TextField(
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Buscar Producto",
                  hintText: "Buscar Producto",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              onChanged: (value) {
                filterSearchResults(value);
              },
            ),
          ),
        ],
      ));

  _windowAddEditDetail(Producto p, String who) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddProduct(p, who, ides);
    }));
    if (result == true) {
      updateListView();
    }
  }

  _lista() => Expanded(
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (context, index) => new Column(
            children: <Widget>[
              new Divider(
                height: 10.0,
              ),
              new ListTile(
                leading: Container(
                  width: 50,
                  child: new Text(
                    this.productos[index].id.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                title: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new Text(
                        productos[index].nombre,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    new Row(
                      children: <Widget>[
                        new IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            _showDetail(this.productos[index], context);
                          },
                          color: Colors.blue,
                        ),
                        new IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _windowAddEditDetail(
                                this.productos[index], "Editar Producto");
                          },
                          color: Colors.yellow[700],
                        ),
                        new IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            AlertDialog alert = new AlertDialog(
                              content: new Text(
                                  "¿Realmente desea eliminar este produtcot?"),
                              actions: <Widget>[
                                new FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: new Text(
                                      "No",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    )),
                                new FlatButton(
                                    onPressed: () {
                                      _delete(context, productos[index]);
                                      ides.remove(this.productos[index].id);
                                      Navigator.pop(context);
                                    },
                                    child: new Text("Si",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)))
                              ],
                            );
                            showDialog(context: context, child: alert);
                          },
                          color: Colors.red,
                        )
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  _showDetail(this.productos[index], context);
                },
              ),
            ],
          ),
        ),
      );

  void _delete(BuildContext context, Producto prod) async {
    int result = await databaseHelper.deleteProduct(prod.id);
    if (result != 0) {
      _showSnackBar(context, 'Producto eliminado exitosamente');
      updateListView();
    }
  }

  void showDeleteDialog() {}

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showDetail(Producto p, BuildContext contexto) {
    TextStyle estilo1 = new TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    TextStyle estilo2 = new TextStyle(
        fontSize: 18, color: Colors.blue[600], fontWeight: FontWeight.bold);

    showDialog(
        context: contexto,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Detalle Producto"),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Clave: ",
                          style: estilo1,
                        ),
                        Text(
                          p.id.toString(),
                          style: estilo2,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Producto: ",
                          style: estilo1,
                        ),
                        Expanded(
                          child: Text(
                            p.nombre,
                            style: estilo2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Precio: ",
                          style: estilo1,
                        ),
                        Text(
                          p.precio.toString(),
                          style: estilo2,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Cantidad: ",
                          style: estilo1,
                        ),
                        Text(
                          p.cantidad.toString(),
                          style: estilo2,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Detalle: ",
                          style: estilo1,
                        ),
                        Expanded(
                          child: Text(
                            p.detalle,
                            style: estilo2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: RaisedButton(
                        child: Text(
                          "Cerrar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(contexto);
                        },
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  void filterSearchResults(String query) {
    List<Producto> dummySearchList = List<Producto>();
    dummySearchList.addAll(productosDuplicado);
    if (query.isNotEmpty) {
      List<Producto> dummyListData = List<Producto>();
      dummySearchList.forEach((item) {
        if (item.nombre.toLowerCase().contains(query.toLowerCase()) ||
            item.id.toString().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        productos.clear();
        productos.addAll(dummyListData);
        count = productos.length;
      });
      return;
    } else {
      setState(() {
        productos.clear();
        productos.addAll(productosDuplicado);
        count = productos.length;
      });
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Producto>> productListFuture =
          databaseHelper.getProductList();
      productListFuture.then((productos) {
        setState(() {
          this.productos = productos;
          this.productosDuplicado.clear();
          this.productosDuplicado.addAll(productos);
          this.count = productos.length;

          int i = 0;
          while (i < this.count) {
            ides.add(this.productos[i].id);
            i++;
          }
        });
      });
    });
  }
}
