part of 'logic_bloc.dart';

abstract class LogicState extends Equatable {}

class LogicInitializeState extends LogicState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LogicErrorState extends LogicState {
  final String error;
  LogicErrorState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LogicLoadingState extends LogicState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ReadTodoState extends LogicState {
  final TaskModel taskModel;
  ReadTodoState({required this.taskModel});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
