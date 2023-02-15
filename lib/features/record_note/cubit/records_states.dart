abstract class RecordsNoteState{}

class RecordsNotesInitialState extends RecordsNoteState{}

class StartRecordState extends RecordsNoteState{}

class PauseRecorderState extends RecordsNoteState{}

class ResumeRecorderState extends RecordsNoteState{}

class StopRecordState extends RecordsNoteState{}

class InsertRecordToDatabaseSuccessState extends RecordsNoteState{}

class InsertRecordToDatabaseErrorState extends RecordsNoteState{}

class DeleteRecordFromDatabaseSuccessState extends RecordsNoteState{}

class DeleteRecordFromDatabaseErrorState extends RecordsNoteState{}

class GetRecordsFromDatabaseSuccessState extends RecordsNoteState{}

class GetRecordsFromDatabaseErrorState extends RecordsNoteState{}

class UpdateRecordTitleSuccessState extends RecordsNoteState{}

class UpdateRecordTitleErrorState extends RecordsNoteState{}

class StopRecorderTimerState extends RecordsNoteState{}

class PauseRecorderTimerState extends RecordsNoteState{}

class ResumeRecorderTimerState extends RecordsNoteState{}

class OnTimeProgressState extends RecordsNoteState{}

class ChangeItemSelectionState extends RecordsNoteState{}



