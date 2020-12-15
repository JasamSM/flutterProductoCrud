class Producto {
  int _id;
  String _nombre;
  double _precio;
  double _cantidad;
  String _detalle;

  Producto(this._id, this._nombre, this._precio, this._cantidad, this._detalle);

  int get id => _id;
  String get nombre => _nombre;
  double get precio => _precio;
  double get cantidad => _cantidad;
  String get detalle => _detalle;

  set clave(int key) {
    this._id = key;
  }

  set nombre(String name) {
    this._nombre = name;
  }

  set precio(double pre) {
    this._precio = pre;
  }

  set cantidad(double can) {
    this._cantidad = can;
  }

  set detalle(String detail) {
    this._detalle = detail;
  }

  //Convert Producto to MapObject
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //if (id != null) {
    map['id'] = _id;
    //}
    map['nombre'] = _nombre;
    map['precio'] = _precio;
    map['cantidad'] = _cantidad;
    map['detalle'] = _detalle;

    return map;
  }

  //Extrar Producto from MapObjecto
  Producto.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nombre = map['nombre'];
    this._precio = map['precio'];
    this._cantidad = map['cantidad'];
    this._detalle = map['detalle'];
  }
}
