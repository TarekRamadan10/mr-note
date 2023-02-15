import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_note/features/record_note/cubit/records_cubit.dart';
import 'package:mr_note/features/record_note/cubit/records_states.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/color_generator.dart';
import '../../../records_player/presentation/screens/play_record_screen.dart';
import '../../../text_note/presentation/components/navigate.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    RecordsNotesCubit cubit=BlocProvider.of<RecordsNotesCubit>(context);
    return BlocConsumer<RecordsNotesCubit, RecordsNoteState>(
      listener: (context, state){},
      builder: (context, state){
        return  Material(
          child: Visibility(
            visible: cubit.records.isNotEmpty,
            replacement: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add Your Voice Notes',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.grey),),
              ],
            ),
            ),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Flexible(
                    child: ListView.separated(
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: width*0.015,),
                      shrinkWrap: true,
                      itemBuilder: (context, index)=>Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: ListTile(
                          tileColor: ColorGenerator.colorGenerator(cubit.records[index]['id']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            //keyboard_control
                            onPressed: ()=>showDialog<void>(
                              context: context,
                              builder: (context)=>DeleteRecordDialog(
                                fileName: cubit.records[index]['title'],
                                id: cubit.records[index]['id'],),
                            ),
                          ),
                          contentPadding: EdgeInsets.all(7.0),
                          onTap: (){
                            navigateTo(context,
                                PlayRecordScreen(audioPath: cubit.records[index]['title'],recordIndex: index,));
                          },
                          onLongPress: ()=>showDialog<void>(
                              context: context,
                              builder: (context)=>UpdateRecordDialog(
                                fileName: cubit.records[index]['title'],
                                id: cubit.records[index]['id'],),
                          ),
                          leading: Icon(Icons.mic_none),
                          title: Text(cubit.records[index]['title'],style: TextStyle(fontSize: 17),),
                        ),
                      ),
                      separatorBuilder: (context, index)=>SizedBox(height: height*0.00001,),
                      itemCount: cubit.records.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DeleteRecordDialog extends StatelessWidget {
  const DeleteRecordDialog({Key? key, required this.fileName, required this.id}) : super(key: key);
  final String fileName;
  final int id;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Record'),
      content: const Text('Do you want to delete this Record'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'YES');
            BlocProvider.of<RecordsNotesCubit>(context).deleteRecord(fileName, id);
          },
          child: const Text('YES'),
        ),
      ],
    );
  }
}

class UpdateRecordDialog extends StatelessWidget {
  UpdateRecordDialog({Key? key, required this.fileName, required this.id}) : super(key: key);
  final String fileName;
  final int id;
  final _controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Title'),
      content: const Text('Enter the new title'),
      actions: <Widget>[
        TextFormField(
          controller: _controller,
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Save');
                BlocProvider.of<RecordsNotesCubit>(context)
                    .updateRecordTitle(fileName:fileName, id:id, newTitle: _controller.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
