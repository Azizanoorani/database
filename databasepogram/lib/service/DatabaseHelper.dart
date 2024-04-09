import 'package:databasepogram/model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Databaseheleper{
static const int _version=1;
static const String _dbname ="notes.db";

static Future <Database> _getDb() async{
  return openDatabase(join(await getDatabasesPath(),_dbname),
  onCreate: (db,_version) async=> await db.execute("""
        CREATE TABLE Note(
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          descripition TEXT NOT NULL,
               );
               """
  ),
  version: _version);
}
  static Future<int> addNote(Note note) async{
    final db = await _getDb();
      return await db.insert("Note", note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace
      );
  }
  static Future<int> updateNote(Note note) async{
    final db =  await _getDb();
    return db.update("Note", note.toJson(),
    where: 'id = ?',
    whereArgs: [note.id],
    conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<int> deleteNote(Note note) async{
     final db =await _getDb();
    return db.delete("Note",
      where: 'id = ?',
      whereArgs:  [note.id],
    );
  }
}