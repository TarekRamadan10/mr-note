import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/colors.dart';
import '../../business_logic/note_bloc/note_cubit.dart';
import '../../business_logic/note_bloc/note_states.dart';
import '../components/default_form_field.dart';

class AddNoteScreen extends StatelessWidget {
    AddNoteScreen({Key? key,this.isOpened=false,required this.title,required this.body,this.id}) : super(key: key);

   bool isOpened;
   String title='';
   String body='';
   int? id;
   static final TextEditingController _titleController=TextEditingController();
   static final TextEditingController _noteController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(isOpened)
      {
        _titleController.text=title;
        _noteController.text=body;
      }
    else
      {
        _titleController.text='';
        _noteController.text='';
      }
    return Scaffold(
      appBar:AppBar(
        title:const Text('Add Note',style:TextStyle(
        fontSize:18.0,),),
        centerTitle: true,
        actions: [
          BlocBuilder<NoteCubit,NoteState>(
            builder:(context,state){
              return IconButton(
                  onPressed:(){
                    if(isOpened)
                      {
                        BlocProvider.of<NoteCubit>(context).updateData(id:id!,title:_titleController.text,body:_noteController.text);
                        Navigator.pop(context);
                      }
                    else
                      {
                        if(_titleController.text.isNotEmpty&& _noteController.text.isNotEmpty)
                        {
                          BlocProvider.of<NoteCubit>(context).insertToDatabase(_titleController.text, _noteController.text, 'note','no');
                          _titleController.text='';
                          _noteController.text='';
                          Navigator.pop(context);
                        }
                      }
                  },
                  icon:const Icon(Icons.check));
            },
          )
        ],
      ),
      backgroundColor:defaultWhite,
      body:SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            DefaultFormField(
              border: InputBorder.none,
              cursorColor: defaultColor,
              style:const TextStyle(
                fontSize:20,
              ),
              cursorHeight:30.0,
              cursorWidth:3.0,
              maxLines:1,
              controller: _titleController,
              hintText:"Note Title",
              hintStyle:const TextStyle(
                fontSize:18.0,
                fontWeight: FontWeight.w300
              ),
            ),
            const SizedBox(height: 5,),
            DefaultFormField(
              fillColor:defaultWhite,
              cursorHeight:25.0,
              cursorWidth:1.8,
              maxLines:null,
              controller: _noteController,
              keyboardType:TextInputType.multiline,
              enabledBorder:UnderlineInputBorder(
                borderSide: BorderSide(
                  color:defaultWhite!,
                )
              ),
              focusedBorder:UnderlineInputBorder(
                  borderSide: BorderSide(
                    color:defaultWhite!,
                  )
              ),
            ),
          ],
            ),
        ),
      ),
    );
  }
}
