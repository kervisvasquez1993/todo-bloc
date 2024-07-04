import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:todo_list/config/global/environment.dart';
import 'package:todo_list/infrastructure/model/task_model.dart';

class TodoRepository {
  TaskModel _TaskModel = TaskModel();

  Future<List<TaskModel>> getTodo() async {
    Response response = await get(Uri.parse(Environment.apiUrl));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => TaskModel.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  /// Primero, hace una solicitud `GET` a la URL `${Environment.apiUrl}/to-do`. Esta URL es un endpoint de una API que devuelve una tarea.
  ///
  /// Si el código de estado de la respuesta es 200, lo que generalmente indica una operación exitosa, procesa el cuerpo de la respuesta con la función `_parseJson` en un aislamiento separado utilizando `compute`. El resultado se asigna a `_TaskModel`.
  Future<TaskModel> readTodoService() async {
    Response response = await get(Uri.parse('${Environment.apiUrl}/to-do'));
    try {
      if (response.statusCode == 200) {
        _TaskModel = await compute(_pareJson, response.body);
      }
    } catch (err) {
      debugPrint("Error: $err");
      throw Exception(err);
    }
    return _TaskModel;
  }

  /// Primero, crea un mapa con `title` y `description`.
  ///
  /// Luego, intenta hacer una solicitud `POST` a la URL `${Environment.apiUrl}/to-do` con el mapa como cuerpo de la solicitud. Esta URL es un endpoint de una API que agrega una nueva tarea.
  Future<bool> addTodo(String title, String description) async {
    try {
      final Map<String, dynamic> map = {
        "title": title,
        "description": description
      };
      final Response response =
          await post(Uri.parse('${Environment.apiUrl}/to-do'), body: map);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<bool> updateTodoService(
    String id,
    dynamic data,
  ) async {
    final Response response =
        await put(Uri.parse('${Environment.apiUrl}/to-do/$id'), body: data);

    try {
      debugPrint("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<bool> deleteTodoService(String id) async {
    try {
      final Response response =
          await delete(Uri.parse('${Environment.apiUrl}/to-do/$id'));
      debugPrint("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      debugPrint("error: $err");
      throw Exception(err);
    }
  }

  Future<bool> completeTodoService(String id) async {
    try {
      final Response response = await patch(
          Uri.parse('${Environment.apiUrl}/to-do/$id/change-status'));
      debugPrint("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      debugPrint("error: $err");
      throw Exception(err);
    }
  }
}

TaskModel _pareJson(String json) => TaskModel.fromJson(jsonDecode(json));
