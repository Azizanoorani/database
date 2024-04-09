import 'package:databasepogram/model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:databasepogram/service/DatabaseHelper.dart';


class Note_Screen extends StatefulWidget {
  const Note_Screen({super.key});

  @override
  State<Note_Screen> createState() => _Note_ScreenState();
}

class _Note_ScreenState extends State<Note_Screen> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Note"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Notes_Screen()));
      } ,child: Icon(Icons.add,size: 30,),),
        body: Note != null ? FutureBuilder<List<Note>?>(future: DatabaseHelper.getallNotes(), builder: (context,AsyncSnapshot<List<Note>?> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()),);
          }else if(snapshot.hasData){
            return ListView.builder(itemBuilder: (context, int index)=>NoteWidget(
              index: index,
              note: snapshot.data![index], onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Notes_Screen(note: snapshot.data![index],)));
            }, onLongPress: () async {
              await showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("Are you sure that you want to delete this ?"),
                  actions: [
                    TextButton(onPressed: () async {
                        await DatabaseHelper.deleteNote(snapshot.data![index]);
                        Navigator.pop(context);
                        setState(() {
                          
                        });
                    }, child: Text("Yes")),
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("No"))
                  ],
                );
              });
            }),
            itemCount:snapshot.data!.length ,
            );
          }
          return SizedBox.shrink();
        }):Center(child: Text("There is nothing here yet",style: TextStyle(
          fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white
        ),),)
    );
  }
}