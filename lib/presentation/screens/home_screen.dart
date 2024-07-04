import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/infrastructure/model/task_model.dart';
import 'package:todo_list/presentation/screens/screens.dart';
import 'package:todo_list/presentation/todo/bloc/logic_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Se llama cuando se crea este objeto de estado.
  /// Llama a `ReadTodoEvent` para leer las tareas pendientes.

  void initState() {
    context.read<LogicalService>().add(ReadTodoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo list"),
      ),
      body: _buildBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddScreen()));
          Future.delayed(const Duration(milliseconds: 500), () {
            context.read<LogicalService>().add(ReadTodoEvent());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Este getter devuelve un widget que se construye en función del estado actual del `LogicalService`.
  ///
  /// Utiliza `BlocBuilder` para reconstruir la interfaz de usuario cada vez que cambia el estado de `LogicalService`.
  ///
  /// - Si el estado es `LogicInitializeState` o `LogicLoadingState`, muestra un indicador de progreso circular.
  /// - Si el estado es `LogicErrorState`, muestra el mensaje de error.
  /// - Si el estado es `ReadTodoState`, muestra la lista de tareas utilizando `_buildListview`.
  /// - Si el estado no es ninguno de los anteriores, devuelve un contenedor vacío.
  Widget get _buildBody {
    return BlocBuilder<LogicalService, LogicState>(builder: (context, state) {
      if (state is LogicInitializeState || state is LogicLoadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is LogicErrorState) {
        String err = state.error;
        return Center(
          child: Text(err),
        );
      } else if (state is ReadTodoState) {
        var data = state.taskModel;
        return _buildListview(data);
      } else {
        return Container();
      }
    });
  }

  /// Este método construye una lista de tareas.
  ///
  /// Recibe un `TaskModel` que contiene los datos de las tareas y devuelve un widget `RefreshIndicator`.
  ///
  /// El `RefreshIndicator` contiene una `ListView.builder` que construye la lista de tareas. Cada tarea es un `ListTile` que muestra el título y la descripción de la tarea.
  ///
  /// El `ListTile` también tiene dos botones:
  /// - Un botón de verificación que, cuando se presiona, marca la tarea como completada y actualiza la lista de tareas.
  /// - Un botón de eliminación que, cuando se presiona, elimina la tarea y actualiza la lista de tareas.
  ///
  /// Además, cada `ListTile` es envuelto en un `GestureDetector` que, cuando se presiona, navega a la pantalla `UpDateTodoScreen` para actualizar la tarea.
  Widget _buildListview(TaskModel taskModel) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<LogicalService>().add(ReadTodoEvent());
      },
      child: ListView.builder(
          itemCount: taskModel.data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return UpDateTodoScreen(
                    id: taskModel.data[index].id,
                    title: taskModel.data[index].title,
                    description: taskModel.data[index].description,
                    status: taskModel.data[index].status,
                  );
                }));
              },
              child: ListTile(
                leading: IconButton(
                    onPressed: () {
                      context.read<LogicalService>().add(CompletedTodoEvent(
                          id: taskModel.data[index].id.toString()));
                      context.read<LogicalService>().add(ReadTodoEvent());
                    },
                    icon: Icon(Icons.check_circle,
                        color: taskModel.data[index].status == 'completed'
                            ? Colors.green
                            : Colors.red)),
                title: Text("Title: ${taskModel.data[index].title}"),
                subtitle:
                    Text("Description: ${taskModel.data[index].description}"),
                trailing: IconButton(
                    onPressed: () {
                      context.read<LogicalService>().add(DeleteTodoEvent(
                          id: taskModel.data[index].id.toString()));
                      context.read<LogicalService>().add(ReadTodoEvent());
                    },
                    icon: const Icon(Icons.delete_outline)),
              ),
            );
          }),
    );
  }
}
