import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/presentation/screens/widget/snackbar.dart';
import 'package:todo_list/presentation/todo/bloc/logic_bloc.dart';

/// `UpDateTodoScreen` es una clase que extiende `StatefulWidget`. Representa la pantalla donde se actualiza una tarea.
///
/// Tiene cuatro campos finales: `id`, `description`, `title` y `status`, que representan respectivamente el identificador, la descripción, el título y el estado de la tarea. Estos campos son requeridos y se pasan al constructor de la clase.
///
/// El método `createState` se sobrescribe para devolver una nueva instancia de `_UpDateTodoViewState`, que es la clase que contiene la lógica de estado de este widget.
class UpDateTodoScreen extends StatefulWidget {
  final int id;
  final String description;
  final String title;
  final String status;
  const UpDateTodoScreen(
      {super.key,
      required this.id,
      required this.description,
      required this.title,
      required this.status});

  @override
  State<UpDateTodoScreen> createState() => _UpDateTodoViewState();
}

class _UpDateTodoViewState extends State<UpDateTodoScreen> {
  /// `_description` es un controlador de texto que se utiliza para obtener y establecer el texto del campo de descripción en la pantalla de actualización de tareas.
  late final TextEditingController _description;

  /// `_title` es un controlador de texto que se utiliza para obtener y establecer el texto del campo de título en la pantalla de actualización de tareas.
  late final TextEditingController _title;

  /// `_status` es un controlador de texto que se utiliza para obtener y establecer el texto del campo de estado en la pantalla de actualización de tareas.
  late final TextEditingController _status;

  /// Se llama una vez cuando se crea el objeto `State`. En este método, se inicializan los controladores de texto `_title`, `_description` y `_status` con los valores de `title`, `description` y `status` del widget, respectivamente.
  ///
  /// Finalmente, se llama al método `super.initState()` para completar el proceso de inicialización.
  @override
  void initState() {
    _title = TextEditingController(text: widget.title);
    _description = TextEditingController(text: widget.description);
    _status = TextEditingController(text: widget.status);
    super.initState();
  }

  /// Se llama cuando este objeto `State` se elimina de forma permanente.
  ///
  /// En este método, se liberan los recursos utilizados por los controladores de texto `_title` y `_description` llamando a su método `dispose`.
  ///
  /// Finalmente, se llama al método `super.dispose()` para completar el proceso de eliminación.
  @override
  void dispose() {
    _title.dispose();
    _description.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Task"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _title,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Title"),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _description,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Description"),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            /// Cuando se presiona el botón, este código se ejecuta. Primero, verifica si el texto del título está vacío. Si lo está, muestra una barra de notificaciones con el mensaje "Title can't null".
            ///
            /// Luego, verifica si el texto de la descripción está vacío. Si lo está, muestra una barra de notificaciones con el mensaje "description can't null".
            ///
            /// Si tanto el título como la descripción no están vacíos, entonces se crea un nuevo evento `UpdateTodoEvent` con el id, el título y la descripción proporcionados, y se añade al `LogicalService`. Después, se crea un nuevo evento `ReadTodoEvent` y también se añade al `LogicalService`.
            onPressed: () {
              if (_title.text.isEmpty) {
                snackBar(context, "Title can't null");
              } else if (_description.text.isEmpty) {
                snackBar(context, "description can't null");
              } else {
                context.read<LogicalService>().add(UpdateTodoEvent(
                      context,
                      id: widget.id.toString(),
                      title: _title.text,
                      description: _description.text,
                      status: '',
                    ));
                context.read<LogicalService>().add(ReadTodoEvent());
              }
            },

            /// Si el estado es `UpdateTodoLoading`, verifica si `isLoading` es verdadero. Si lo es, muestra un `CircularProgressIndicator` con color blanco. Si no lo es, muestra un widget `Text` con el texto 'Update Task'.
            ///
            /// Si el estado no es `UpdateTodoLoading`, simplemente muestra un widget `Text` con el texto 'Update Task'.
            child: BlocBuilder<LogicalService, LogicState>(
              builder: (context, state) {
                if (state is UpdateTodoLoading) {
                  bool isLoading = state.isLoading;
                  return isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Update Task");
                } else {
                  return const Text("Update Task");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
