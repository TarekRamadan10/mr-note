import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:mr_note/constants/colors.dart';
import 'package:mr_note/features/record_note/cubit/records_states.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/records_path.dart';
import '../data/records_repo.dart';

class RecordsNotesCubit extends Cubit<RecordsNoteState>
{
  RecordsNotesCubit() : super(RecordsNotesInitialState())
  {
    RecordsRepository();

  }
  final recorder = FlutterSoundRecorder();
  bool isRecordInitialized = false;
  final audioPlayer=AudioPlayer();
  bool isRecording=false;
  bool isPlaying=false;
  bool isPaused=false;
  List<Map<String,dynamic>> records=[];
  StreamSubscription<RecordingDisposition>? _subscription;

  Future initRecorder() async
  {
    final micStatus = await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    if (micStatus != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecordInitialized = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future record()async
  {
    if(!isRecordInitialized)return;
    int year=DateTime.now().year;
    int month=DateTime.now().month;
    int day=DateTime.now().day;
    int hour=DateTime.now().hour;
    int minute=DateTime.now().minute;
    String fileName='$hour${minute}_$day-$month-$year';
    await recorder.startRecorder(toFile:fileName);
    isRecording=true;
    emit(StartRecordState());
  }

  Future stop()async
  {
    if(!isRecordInitialized)return;
    final path = await recorder.stopRecorder();
    isRecording=false;
    final audioPath=File(path!);
    print(audioPath);
    await insertRecordNameToDatabase(audioPath);

    timeProgress='00:00:00';
    emit(StopRecordState());
    getRecordsFromDatabase();
  }

  Future pauseRecorder()async
  {
    await recorder.pauseRecorder();
    isPaused=true;
    pauseTimer();
    emit(PauseRecorderState());
  }

  Future resumeRecorder()async
  {
     await recorder.resumeRecorder();
     isPaused=false;
     resumeTimer();
     emit(ResumeRecorderState());
   }

  Icon recordingButtonIcon()
  {
    if(isRecording&&isPaused)
      {
        return Icon(Icons.mic,color: defaultWhite,);
      }
    else if(!isRecording&& !isPaused)
      {
        return Icon(Icons.mic,color: defaultWhite,);
      }
    else if(isRecording&& !isPaused)
      {
        return Icon(Icons.pause,color: defaultWhite,);
      }
    else if(!isRecording&& isPaused)
      {
        return Icon(Icons.mic,color: defaultWhite,);
      }
    return Icon(Icons.mic);
  }

  Future<void> insertRecordNameToDatabase(File file)async
  {
    await RecordsRepository.insertToDatabase(recordTitle: Uri.file(file.path).pathSegments.last)
        .then((value){
           emit(InsertRecordToDatabaseSuccessState());
         })
        .catchError((error){
          print(error.toString());
          emit(InsertRecordToDatabaseErrorState());
         });
  }

  Future<void> getRecordsFromDatabase()async
  {
    records=[];
    await RecordsRepository.getRecordsData()
        .then((value) {
           value?.forEach((element) {
             if(element['title']=='record1')
               print('exist');
             records.add(element);
           });
           emit(GetRecordsFromDatabaseSuccessState());
         })
        .catchError((error){
           print(error.toString());
           emit(GetRecordsFromDatabaseErrorState());
         });
  }

  void deleteRecord(String fileName, int id)async
  {
    File filePath=File('$RECORDS_PATH/$fileName');
    if(await filePath.exists())
      {
        await filePath.delete();
        await RecordsRepository.deleteRecord(id: id);
        print('deleted successfully');
      }
    else
      {
        if(records.contains(fileName));
         await RecordsRepository.deleteRecord(id: id);
         print('deleted from records map');
      }
    emit(DeleteRecordFromDatabaseSuccessState());
    await getRecordsFromDatabase();

  }

  void updateRecordTitle({required String fileName, required int id, required String newTitle})async
  {
    File filePath=File('$RECORDS_PATH/$fileName');
    await filePath.rename('$RECORDS_PATH/$newTitle')
        .then((value) {
          RecordsRepository.updateRecordTitle(id: id, title: newTitle)
              .then((value) {
                getRecordsFromDatabase();
                emit(UpdateRecordTitleSuccessState());
              });
        })
        .catchError((e){
          print('from file path ${e.toString()}');
          emit(UpdateRecordTitleErrorState());
        });
  }

  String timeProgress='00:00:00';
  void onTimeProgress()
  {
    _subscription=recorder.onProgress!.listen((e) {
      Duration duration=e.duration;
      String hours=towDigits(duration.inHours);
      String minutes=towDigits(duration.inMinutes.remainder(60));
      String seconds=towDigits(duration.inSeconds.remainder(60));
      timeProgress=duration==Duration.zero?'00:00:00':'$hours:$minutes:$seconds';
      emit(OnTimeProgressState());
    });
    // recorder.onProgress?.listen((e) {
    //   Duration duration=e.duration;
    //   print(e.duration.inSeconds);
    //   final String hours=towDigits(duration.inHours);
    //   final String minutes=towDigits(duration.inMinutes.remainder(60));
    //   final String seconds=towDigits(duration.inSeconds.remainder(60));
    //   time='$hours:$minutes:$seconds';
    //   emit(OnTimeProgressState());
    // });

  }

  void stopTimer()
  {
    _subscription?.cancel();
    emit(StopRecorderTimerState());
  }

  void pauseTimer()
  {
    _subscription?.pause();
    emit(PauseRecorderTimerState());
  }

  void resumeTimer()
  {
    _subscription?.resume();
    emit(ResumeRecorderTimerState());
  }

  bool isSelected=false;
  void changeSelectedValue()
  {
    isSelected =! isSelected;
    emit(ChangeItemSelectionState());
  }
  String towDigits(int n)=>n.toString().padLeft(2,'0');

}