import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_note/constants/colors.dart';
import 'package:mr_note/features/text_note/presentation/components/navigate.dart';
import '../../../../utils/color_generator.dart';
import '../../business_logic/note_bloc/note_cubit.dart';
import '../screens/add_note_screen.dart';

class NoteItemBuilder extends StatelessWidget {
   NoteItemBuilder({Key? key,required this.item}) : super(key: key);

   Map<String,dynamic> item={};


  @override
  Widget build(BuildContext context) {
    bool isFav;
    if(item['fav']== 'yes')
      {
        isFav=true;
      }
    else
      {
        isFav=false;
      }
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete,size: 40.0,color: defaultWhite,),
      ),
      onDismissed:(direction) {
       BlocProvider.of<NoteCubit>(context).deleteDataFromDatabase(item['id']);
      } ,
      key:  Key(item['id'].toString()),
      child: InkWell(
        onTap:()
        {
          navigateTo(context, AddNoteScreen(isOpened:true,title:item['title'],body:item['body'],id:item['id'],));
        },
        child: Container(
          width: double.infinity,
          height:MediaQuery.of(context).size.height*0.3/2,
          decoration:BoxDecoration(
            color:ColorGenerator.colorGenerator(item['id']),
            borderRadius:BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item['title'],
                      style:const TextStyle(
                      fontSize:21,
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed:(){
                          if(isFav)
                            {
                              BlocProvider.of<NoteCubit>(context).updateFavoritesInDatabase(item['id'],'no');
                            }
                          else
                            {
                              BlocProvider.of<NoteCubit>(context).updateFavoritesInDatabase(item['id'],'yes');
                            }
                        },
                        icon:Icon(isFav?Icons.favorite: Icons.favorite_outline_sharp,
                          color:isFav?Colors.blue:Colors.grey[350],size:33,),
                    ),
                  ],
                ),
                Text(item['body'],
                  maxLines:2,
                  overflow:TextOverflow.ellipsis,
                  style:const TextStyle(
                    fontSize:17,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }
}


