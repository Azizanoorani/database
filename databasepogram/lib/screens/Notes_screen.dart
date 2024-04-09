import 'package:databasepogram/model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:databasepogram/service/DatabaseHelper.dart';

class Notes_Screen extends StatelessWidget {
  final Note? note;
   Notes_Screen({super.key, this.note});

  final titlecontroller = TextEditingController();

  final descriptioncontroller = TextEditingController();
    
  @override
  Widget build(BuildContext context) {
    if(note != null){
      titlecontroller.text = note!.title;
      descriptioncontroller.text =note!.description;
    }return  Scaffold(
      appBar: AppBar(
        title: Text(note == null ?"Add some new notes here":"Update your mistkae over here"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  maxLines: 1,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your note properly';
                    }else{
                      return null;
                    }
                  },
                  controller: titlecontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Please add title of your note here",
                  ),
                ),
                 TextFormField(
                  maxLength: 500,
                  maxLines: 5,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your note properly';
                    }else{
                      return null;
                    }
                  },
                  controller: descriptioncontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Please add title of your note here",
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: context.screenWidth-50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blueGrey)
                    ),
                    onPressed: () async {
                    final title = titlecontroller.text;
                    final discription = descriptioncontroller.text;
                    if (title.isEmpty||discription.isEmpty) {
                      return null;
                    }
                    final Note model = Note(id: note?.id, title: title, description: discription);
                    if (note == null) {
                     
                      await  DatabaseHelper.addNote(model);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data added Successfuly"),backgroundColor: Colors.green,));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Note_Screen()));
                    }else{
                      
                      await DatabaseHelper.updateNote(model);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Updated Successfully"),backgroundColor: Colors.amber,));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Note_Screen()));
                    }
                  }, child: Text(note==null?"Add Note":"Update Note",style: TextStyle(fontSize: 24,color: Colors.white),)),
                )
              ],
            ),
        
        ),
      ),
    );
  }
}