import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_note/constants/colors.dart';
import 'package:mr_note/features/record_note/cubit/records_cubit.dart';
import '../../../../constants/records_path.dart';

class PlayRecordScreen extends StatefulWidget {
  late String audioPath;
  int recordIndex;
  PlayRecordScreen({Key? key, required this.audioPath, required this.recordIndex}) : super(key: key);

  @override
  State<PlayRecordScreen> createState() => _PlayRecordScreenState();
}

class _PlayRecordScreenState extends State<PlayRecordScreen> {
  final audioPlayer=AudioPlayer();
  bool isPlaying=false;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying=event==PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration=event;
      });
    });

    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position=event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final RecordsNotesCubit cubit=BlocProvider.of<RecordsNotesCubit>(context);
    return Scaffold(
      backgroundColor: defaultWhite,
      appBar: AppBar(
        leading: IconButton(
            onPressed: ()async{
              Navigator.pop(context);
              await stopAudio();
            },
            icon: Icon(Icons.arrow_back_outlined)),
        title: Text('Records Player',style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: height*0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.multitrack_audio_sharp, size: 100.0,),
                Icon(Icons.multitrack_audio_sharp, size: 100.0,),
                Icon(Icons.multitrack_audio_sharp, size: 100.0,),
              ],
            ),
            SizedBox(height: height*0.2,),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value)async{
                final positionChange=Duration(seconds: value.toInt());
                await audioPlayer.seek(positionChange);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration)),
                ],
              ),
            ),
            const SizedBox(height: 7.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  child: IconButton(
                    icon: const Icon(Icons.skip_previous_sharp),
                    onPressed: ()async{
                      if(position!=Duration.zero)
                      {
                        await stopAudio();
                        setState(() {
                          position=Duration.zero;
                        });
                      }
                      else
                      {
                        ///back to the previous audio in the playlist
                        if(widget.audioPath==cubit.records[0]['title'])
                          {
                            widget.audioPath=cubit.records[cubit.records.length-1]['title'];
                          }
                        else
                          {
                          widget.audioPath=BlocProvider.of<RecordsNotesCubit>(context).records[widget.recordIndex-1]['title'];
                        }
                      }
                    },
                  ),
                ),
                CircleAvatar(
                  radius: 26.0,
                  child: IconButton(
                    icon: Icon(isPlaying? Icons.pause:Icons.play_arrow),
                    onPressed: ()async{
                      if(isPlaying)
                      {
                        await pauseAudio();
                      }
                      else
                      {
                        await playAudio();
                      }
                    },
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  child: IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: ()async{
                      if(widget.audioPath==cubit.records[cubit.records.length-1]['title'])
                        {
                          widget.audioPath=cubit.records[0]['title'];
                        }
                      else
                        {
                          widget.audioPath=cubit.records[widget.recordIndex+1]['title'];
                        }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> playAudio()async
  {
    try{
      await audioPlayer.play(
        UrlSource('$RECORDS_PATH/${widget.audioPath}'),
      );
      setState(() {
        isPlaying=true;
      });
    }catch(e){
      print('this is exception${e.toString()}');
    }

  }

  Future<void> stopAudio()async
  {
    await audioPlayer.stop();
    setState(() {
      isPlaying=false;
    });

  }

  Future<void> pauseAudio()async
  {
    await audioPlayer.pause();
    setState(() {
      isPlaying=false;
    });

  }

}

String formatTime(Duration duration)
{
  String towDigits(int n)=>n.toString().padLeft(2,'0');
  final hours=towDigits(duration.inHours);
  final minutes=towDigits(duration.inMinutes.remainder(60));
  final seconds=towDigits(duration.inSeconds.remainder(60));

  return [
    if(duration.inHours>0) hours,
    minutes,
    seconds
  ].join(':');
}
