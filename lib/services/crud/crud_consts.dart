//some consts about db
const dbName = 'notes.db';
const userTable = 'users';
const noteTable = 'notes';
const usersTable = '''
        CREATE TABLE IF NOT EXISTS "users" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';
const notesTable = '''
            CREATE TABLE IF NOT EXISTS "notes" (
              "id"	INTEGER NOT NULL,
              "user_id"	INTEGER NOT NULL,
              "text"	TEXT,
              "is_synced_with_server"	INTEGER NOT NULL DEFAULT 0,
              PRIMARY KEY("id" AUTOINCREMENT)
            );
      ''';
