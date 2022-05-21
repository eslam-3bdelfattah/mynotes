//created this file to deal with local database crud operations
import 'package:mynotes/services/crud/crud_consts.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';

//create a class that deals with users from database
class Users {
  final int id;
  final String email;

  const Users({
    required this.id,
    required this.email,
  });

  Users.fromRow(Map<String, Object?> map)
      : id = map['id'] as int,
        email = map['email'] as String;
  @override
  String toString() => 'id=$id , email=$email';

  bool operator(covariant Users other) => id == other.id;
}

//create a class for notes
class NotesFromDatabase {
  final int id;
  final String text;
  final int userId;
  final bool isSyncedWithServer;

  const NotesFromDatabase({
    required this.id,
    required this.text,
    required this.userId,
    required this.isSyncedWithServer,
  });

  NotesFromDatabase.rowFromDatabase(Map<String, Object?> map)
      : id = map['id'] as int,
        userId = map['user_id'] as int,
        text = map['text'] as String,
        isSyncedWithServer = map['is_synced_with_server'] as bool;

  @override
  String toString() => 'Notes, id=$id,text=$text,userId=$userId';

  bool operator(covariant NotesFromDatabase other) => id == other.id;
}

//create class note service
class NotesService {
  //create instance from database
  Database? _db;
  //check if there is db or no
  Database _getDBOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpened();
    } else {
      return db;
    }
  }

  //get all notes from the database
  Future<Iterable<NotesFromDatabase>> getAllNotes() async {
    final db = _getDBOrThrow();
    final allNotes = await db.query(notesTable);
    final result = allNotes.map((notes) {
      return NotesFromDatabase.rowFromDatabase(notes);
    });
    if (allNotes.isEmpty) {
      throw CouldNotFindNotes();
    }
    return result;
  }

  //update notes
  Future<NotesFromDatabase> updateNotes({
    required NotesFromDatabase note,
    required String text,
  }) async {
    final db = _getDBOrThrow();
    await getNote(id: note.id);
    final updateCount = await db.update(
      notesTable,
      {
        'text': text,
        'is_synced_with_server': 0,
      },
    );
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }

  //get specifc note
  Future<NotesFromDatabase> getNote({required int id}) async {
    final db = _getDBOrThrow();
    final getNote = await db.query(
      notesTable,
      where: 'id = ?',
      limit: 1,
      whereArgs: [id],
    );
    if (getNote.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return NotesFromDatabase.rowFromDatabase(getNote.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDBOrThrow();
    return await db.delete(notesTable);
  }

  //delete note
  Future<void> deleteNote({required int id}) async {
    final db = _getDBOrThrow();
    final deleteCount = await db.delete(
      notesTable,
      where: 'id= ?',
      whereArgs: [id],
    );
    if (deleteCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  //create note
  Future<NotesFromDatabase> createNote({required Users owner}) async {
    final db = _getDBOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = '';
    final noteId = await db.insert(
      notesTable,
      {
        'user_id': owner.id,
        'text': text,
        'is_synced_with_server': 1,
      },
    );
    final note = NotesFromDatabase(
      id: noteId,
      text: text,
      userId: owner.id,
      isSyncedWithServer: true,
    );
    return note;
  }

  //get a user
  Future<Users> getUser({required String email}) async {
    final db = _getDBOrThrow();
    final getUser = await db.query(
      userTable,
      where: 'email = ?',
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );
    if (getUser.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return Users.fromRow(getUser.first);
    }
  }

  //delete a user
  Future<void> deleteUser({required String email}) async {
    final db = _getDBOrThrow();
    final deleteCount = await db.delete(
      userTable,
      where: 'email= ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleteCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  //create user
  Future<Users> createUser({required String email}) async {
    final db = _getDBOrThrow();
    final createUserResult = await db.query(
      userTable,
      where: 'email = ?',
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );
    if (createUserResult.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(
      userTable,
      {
        'email': email.toLowerCase(),
      },
    );
    return Users(
      id: userId,
      email: email,
    );
  }

  //close db
  Future<void> closeDb() async {
    final db = _db;
    _getDBOrThrow();
    await db!.close();
  }

  //create the open function to open database or create new one.
  Future<void> createDatabase() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenedException();
    }
    try {
      final docPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docPath.path, dbName);
      final database = await openDatabase(dbPath);
      _db = database;
      //create table for users and notes

      await _db!.execute(notesTable);

      await _db!.execute(usersTable);
    } catch (e) {}
  }
}
