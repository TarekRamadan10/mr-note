import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_note/constants/colors.dart';
import 'package:mr_note/features/record_note/cubit/records_cubit.dart';
import 'package:mr_note/features/record_note/cubit/records_states.dart';


class AddRecordScreen extends StatelessWidget {
  const AddRecordScreen({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return BlocConsumer<RecordsNotesCubit, RecordsNoteState>(
      listener: (context, state){},
      builder: (context, state){
        RecordsNotesCubit cubit=BlocProvider.of<RecordsNotesCubit>(context);
        return Scaffold(
          backgroundColor: defaultWhite,
          appBar: AppBar(
            title: Text('New Record',style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w600),),
          ),
          body: Padding(
            padding: EdgeInsets.only(bottom: height*0.1/2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.settings_voice_outlined,size: 200.0, color: Colors.grey,),
                SizedBox(height: height*0.2,),
                Text(cubit.timeProgress, style: TextStyle(fontSize: 22),),
                Divider(height:height*0.05,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundColor: defaultColor,
                      child: IconButton(
                        onPressed: ()async{
                          if(cubit.isRecording)
                          {
                            if(cubit.isPaused)
                              {
                                await cubit.resumeRecorder();
                              }
                            else
                              {
                                await cubit.pauseRecorder();
                              }
                          }
                          else
                          {
                            await cubit.record();
                            cubit.onTimeProgress();
                          }
                        },
                        icon: cubit.recordingButtonIcon(),
                      ),
                    ),
                    SizedBox(width: 20,),
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                      child: IconButton(
                        onPressed: ()async{
                          if(cubit.isRecording)
                            {
                              await cubit.stop();
                            }
                        },
                        icon: Icon(Icons.stop,color: Colors.red.shade700,),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

/// '/data/user/0/com.example.mr_note/cache/54'
/// '/data/user/0/com.example.mr_note/cache/55'


