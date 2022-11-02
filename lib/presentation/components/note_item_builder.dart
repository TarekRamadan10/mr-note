import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_note/presentation/components/navigate.dart';
import '../../business_logic/note_bloc/note_cubit.dart';
import '../screens/add_note_screen.dart';

class NoteItemBuilder extends StatelessWidget {
   NoteItemBuilder({Key? key,required this.item,required this.isFav}) : super(key: key);

   Map<String,dynamic> item={};
   bool isFav;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
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
            color:colorGenerator(item['id']),
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





Color? colorGenerator(int index)
{
  Color? color;
  String stIndex=index.toString();
  if(stIndex.length==1)
  {
    if(index.isEven)
    {
      if(stIndex=='0'||stIndex=='4'||stIndex=='8')
      {
        color=Colors.cyan.shade100.withOpacity(0.3);
      }
      else
      {
        color=Colors.lightGreen.shade100.withOpacity(0.5);
      }

    }
    else
    {
      if(stIndex=='1'||stIndex=='5'||stIndex=='9')
      {
        color=Colors.amberAccent.shade100.withOpacity(0.5);
      }
      else if(stIndex=='3'||stIndex=='7')
      {
        color=Colors.pinkAccent[100]?.withOpacity(0.5);
      }
    }
  }
  else if(stIndex.length==2)
  {
    if(index.isEven)
    {
      if(stIndex[1]=='4'||stIndex[1]=='8')
      {
        color=Colors.cyan.shade100.withOpacity(0.3);
      }
      else
      {
        color=Colors.lightGreen.shade100.withOpacity(0.5);
      }

    }
    else
    {
      if(stIndex[1]=='5'||stIndex[1]=='9')
      {
        color=Colors.amberAccent.shade100.withOpacity(0.5);
      }
      else
      {
        color=Colors.pinkAccent.withOpacity(0.5);
      }
    }
  }

  return color;
}

