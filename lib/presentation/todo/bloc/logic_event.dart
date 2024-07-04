part of 'logic_bloc.dart';

abstract class LogicEvent extends Equatable {}

class ReadTodoEvent extends LogicEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AddTodoEvent extends LogicEvent {
  final String description;
  final String title;
  final BuildContext context;
  AddTodoEvent(
      {required this.description, required this.title, required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AddTodoLoading extends LogicState {
  final bool isLoading;
  AddTodoLoading({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class UpdateTodoEvent extends LogicEvent {
  final String id;
  final String title;
  final String description;
  final String status;
  final BuildContext context;
  UpdateTodoEvent(this.context,
      {required this.id,
      required this.description,
      required this.title,
      required this.status});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class UpdateTodoLoading extends LogicState {
  bool isLoading;
  UpdateTodoLoading({required this.isLoading});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DeleteTodoEvent extends LogicEvent {
  final String id;
  DeleteTodoEvent({required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DeleteTodoLoading extends LogicState {
  bool isLoading;
  DeleteTodoLoading({required this.isLoading});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CompletedTodoEvent extends LogicEvent {
  final String id;
  CompletedTodoEvent({required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CompletedTodoLoading extends LogicState {
  bool isLoading;
  CompletedTodoLoading({required this.isLoading});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
