import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/note_bloc/note_cubit.dart';
import '../../business_logic/note_bloc/note_states.dart';
import '../components/note_item_builder.dart';

class FavoriteNotesScreen extends StatelessWidget {
  const FavoriteNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<NoteCubit,NoteState>(
      listener:(context,state){},
      builder: (context,state)
      {
        NoteCubit cubit=BlocProvider.of<NoteCubit>(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: cubit.favorites.isNotEmpty,
            replacement: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Favorites Yet !',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.grey),),
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    shrinkWrap:true,
                    itemBuilder: (context,index)=>NoteItemBuilder(item:cubit.favorites[index]),
                    separatorBuilder: (context,index)=>const Divider(height:10),
                    itemCount:cubit.favorites.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
