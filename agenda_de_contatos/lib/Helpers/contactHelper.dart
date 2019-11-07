import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';
final String imgColumn = 'imgColumn';
final String contactTable = 'contactTable';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
    }

    return _db;
  }

  Future<Database> initDB() async {
    final String sql = 'CREATE TABLE $contactTable(' +
        '$idColumn  INTEGER PRIMARY KEY,' +
        '$nameColumn Text,' +
        '$phoneColumn Text,' +
        '$emailColumn Text,' +
        '$imgColumn Text' +
        ')';

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contacts3.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(sql);
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    final Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.topMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    final Database dbContact = await db;
    //'$idColumn = $id'
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, phoneColumn, emailColumn, imgColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    }
  }

  Future<int> deleteContact(int id) async {
    final Database dbContact = await db;

    return await dbContact
        .delete(contactTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    final Database dbContact = await db;

    return await dbContact.update(contactTable, contact.topMap(),
        where: '$idColumn = ?', whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async{
    final Database dbContact = await db;
  
    List listMap = await dbContact.rawQuery('SELECT * FROM $contactTable');

    List<Contact> listContact = List();

    for(Map map in listMap){
      listContact.add(Contact.fromMap(map));
    }

    return listContact;
  }

  Future<int> getNumber() async{
    final Database dbContact = await db;
    
    return Sqflite.firstIntValue(await dbContact.rawQuery('SELECT COUNT(1) FROM $contactTable'));
  }

  Future<Null>close() async{
    final Database dbContact = await db;
    await dbContact.close();
  }

}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  @override
  String toString(){
    return 'Nome: $name e Telefoooone: $phone';
  }

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map topMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

}
