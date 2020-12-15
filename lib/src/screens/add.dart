import 'package:flutter/material.dart';
import 'package:flutter_productos/src/model/producto_model.dart';
import 'package:flutter_productos/src/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'dart:async';

DatabaseHelper helper = DatabaseHelper();

class AddProduct extends StatefulWidget {
  final String title;
  final Producto producto;
  Set<int> ides = Set<int>();
  AddProduct(this.producto, this.title, this.ides);
  @override
  _AddProductState createState() =>
      _AddProductState(this.producto, this.title, this.ides);
}

class _AddProductState extends State<AddProduct> {
  _AddProductState(this.producto, this.titulo, this.ide);
  String titulo;
  Set<int> ide = Set<int>();
  Producto producto;
  final _formKey = GlobalKey<FormState>();
  int clave;
  String nombre, detalle;
  double precio, cantidad;
  String opcion = "Agregar";
  Color color = Colors.green;
  //focos
  FocusNode f1, f2, f3, f4, f5;

  //iniciales actualizar
  String id = "", nom = "", pre = "", can = "", det = "";
  bool operation = true;
  @override
  Widget build(BuildContext context) {
    if (producto.id != 0) {
      opcion = "Actualizar";
      color = Colors.yellow[700];
      id = producto.id.toString();
      nom = producto.nombre;
      pre = producto.precio.toString();
      can = producto.cantidad.toString();
      det = producto.detalle;
      operation = false;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(titulo),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: new Center(
          child: _formulario(),
        ),
      ),
    );
  }

  Widget _formulario() {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              enabled: operation,
              initialValue: id,
              decoration: new InputDecoration(labelText: "clave"),
              keyboardType: TextInputType.number,
              onSaved: (val) => setState(() => clave = int.parse(val)),
              validator: (val) {
                if (val.length == 0) {
                  return "Rellene este campo";
                } else {
                  if (ide.contains(int.parse(val))) {
                    if (producto.id != 0)
                      return null;
                    else
                      return "Clave repetida, ingrese una diferente por favor";
                  } else {
                    return null;
                  }
                }
              },
              focusNode: f1,
              onEditingComplete: () {
                requestFocus(context, f2);
              },
            ),
            TextFormField(
                initialValue: nom,
                decoration:
                    new InputDecoration(labelText: "Nombre del producto"),
                onSaved: (val) => setState(() => nombre = val),
                validator: (val) =>
                    (val.length == 0 ? "Rellene este campo" : null),
                focusNode: f2,
                onEditingComplete: () {
                  requestFocus(context, f3);
                }),
            TextFormField(
                initialValue: pre,
                decoration: new InputDecoration(labelText: "Precio"),
                keyboardType: TextInputType.number,
                onSaved: (val) => setState(() => precio = double.parse(val)),
                validator: (val) =>
                    (val.length == 0 ? "Rellene este campo" : null),
                focusNode: f3,
                onEditingComplete: () {
                  requestFocus(context, f4);
                }),
            TextFormField(
                initialValue: can,
                decoration: new InputDecoration(labelText: "Cantidad"),
                keyboardType: TextInputType.number,
                onSaved: (val) => setState(() => cantidad = double.parse(val)),
                validator: (val) =>
                    (val.length == 0 ? "Rellene este campo" : null),
                focusNode: f4,
                onEditingComplete: () {
                  requestFocus(context, f5);
                }),
            TextFormField(
              initialValue: det,
              decoration: new InputDecoration(labelText: "Detalle"),
              keyboardType: TextInputType.multiline,
              onSaved: (val) => setState(() => detalle = val),
              validator: (val) =>
                  (val.length == 0 ? "Rellene este campo" : null),
              focusNode: f5,
              minLines: 2,
              maxLines: 5,
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text(
                  opcion,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                color: color,
                onPressed: () => _onSubmit(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _save();
      });
    }
  }

  void _save() async {
    Navigator.pop(context, true);
    int result;
    String accion = "guardado";
    if (producto.id != 0) {
      // Case 1: Update operation
      producto = new Producto(clave, nombre, precio, cantidad, detalle);
      accion = "actualizado";
      result = await helper.updateNote(producto);
    } else {
      // Case 2: Insert Operation
      producto = new Producto(clave, nombre, precio, cantidad, detalle);
      result = await helper.insertProduct(producto);
    }
    if (result != 0) {
      // Success
      _showAlertDialog('Mensaje', 'Producto $accion exitosamente');
    } else {
      // Failure
      _showAlertDialog('Status', 'Error al guardar producto');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    f1.dispose();
    f2.dispose();
    f3.dispose();
    f4.dispose();
    f5.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    f1 = new FocusNode();
    f2 = new FocusNode();
    f3 = new FocusNode();
    f4 = new FocusNode();
    f5 = new FocusNode();
  }

  void requestFocus(BuildContext c, FocusNode f) {
    FocusScope.of(c).requestFocus(f);
  }
}
