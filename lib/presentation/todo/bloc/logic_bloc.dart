import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/infrastructure/model/task_model.dart';
import 'package:todo_list/infrastructure/services/task_service.dart';
import 'package:todo_list/presentation/screens/widget/snackbar.dart';

part 'logic_event.dart';
part 'logic_state.dart';

class LogicalService extends Bloc<LogicEvent, LogicState> {
  final TodoRepository _service;
  LogicalService(this._service) : super(LogicInitializeState()) {
    on<AddTodoEvent>((event, emit) async {
      emit(AddTodoLoading(isLoading: true));
      await _service.addTodo(event.title, event.description).then((value) {
        emit(AddTodoLoading(isLoading: false));
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(event.context);
        });
      }).onError((error, stackTrace) {
        emit(AddTodoLoading(isLoading: false));
      });
    });

    /// Cuando se dispara el evento `ReadTodoEvent`, primero emite el estado `LogicLoadingState` para indicar que la operación de lectura está en progreso.
    ///
    /// Luego, llama al método `readTodoService` del servicio `_service`. Si la operación es exitosa, emite el estado `ReadTodoState` con el modelo de tarea devuelto por el servicio.
    ///
    /// Si ocurre un error durante la operación, emite el estado `LogicErrorState` con el mensaje de error.
    on<ReadTodoEvent>((event, emit) async {
      emit(LogicLoadingState());
      await _service.readTodoService().then((value) {
        emit(ReadTodoState(taskModel: value));
      }).onError((error, stackTrace) {
        emit(LogicErrorState(error: error.toString()));
      });
    });

    /// Cuando se dispara el evento `UpdateTodoEvent`, primero emite el estado `UpdateTodoLoading` con `isLoading` establecido en `true` para indicar que la operación de actualización está en progreso.
    ///
    /// Luego, recoge el `id` del evento y crea un mapa `data` con el `title` y la `description` del evento.
    ///
    /// Después, llama al método `updateTodoService` del servicio `_service` con el `id` y los `data`. Si la operación es exitosa, emite el estado `UpdateTodoLoading` con `isLoading` establecido en `false`, muestra una barra de notificaciones con el mensaje "Todo has been Update", y después de un retraso de 500 milisegundos, navega fuera de la pantalla actual.
    ///
    /// Si ocurre un error durante la operación, emite el estado `UpdateTodoLoading` con `isLoading` establecido en `false`.
    on<UpdateTodoEvent>((event, emit) async {
      emit(UpdateTodoLoading(isLoading: true));
      final String id = event.id;
      final Map<String, dynamic> data = {
        "title": event.title,
        "description": event.description,
      };
      await _service.updateTodoService(id, data).then((value) {
        emit(UpdateTodoLoading(isLoading: false));
        snackBar(event.context, "Todo has been Update");

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(event.context);
        });
      }).onError((error, stackTrace) {
        emit(UpdateTodoLoading(isLoading: false));
      });
    });

    /// Cuando se dispara el evento `DeleteTodoEvent`, primero emite el estado `DeleteTodoLoading` con `isLoading` establecido en `true` para indicar que la operación de eliminación está en progreso.
    ///
    /// Luego, llama al método `deleteTodoService` del servicio `_service` con el `id` del evento. Si la operación es exitosa, emite el estado `DeleteTodoLoading` con `isLoading` establecido en `false`.
    ///
    /// Si ocurre un error durante la operación, emite el estado `DeleteTodoLoading` con `isLoading` establecido en `false`.
    on<DeleteTodoEvent>((event, emit) async {
      emit(DeleteTodoLoading(isLoading: true));
      await _service.deleteTodoService(event.id).then((value) {
        emit(DeleteTodoLoading(isLoading: false));
      }).onError((error, stackTrace) {
        emit(DeleteTodoLoading(isLoading: false));
      });
    });

    /// Cuando se dispara el evento `CompletedTodoEvent`, primero emite el estado `DeleteTodoLoading` con `isLoading` establecido en `true` para indicar que la operación de completar la tarea está en progreso.
    ///
    /// Luego, llama al método `completeTodoService` del servicio `_service` con el `id` del evento. Si la operación es exitosa, emite el estado `CompletedTodoLoading` con `isLoading` establecido en `false`.
    ///
    /// Si ocurre un error durante la operación, emite el estado `CompletedTodoLoading` con `isLoading` establecido en `false`.
    on<CompletedTodoEvent>((event, emit) async {
      emit(DeleteTodoLoading(isLoading: true));
      await _service.completeTodoService(event.id).then((value) {
        emit(CompletedTodoLoading(isLoading: false));
      }).onError((error, stackTrace) {
        emit(CompletedTodoLoading(isLoading: false));
      });
    });
  }
}
