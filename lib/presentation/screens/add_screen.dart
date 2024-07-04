import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/presentation/screens/widget/snackbar.dart';
import 'package:todo_list/presentation/todo/bloc/logic_bloc.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  /// `title` es un controlador de texto que se utiliza para obtener y establecer el texto del campo de título.
  final title = TextEditingController();

  /// `description` es un controlador de texto que se utiliza para obtener y establecer el texto del campo de descripción.
  final description = TextEditingController();
  int indexx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title_widgets(),
            SizedBox(height: 20),
            subtite_widgets(),
            SizedBox(height: 20),
            SizedBox(height: 20),
            button()
          ],
        ),
      ),
    );
  }

//Botones de cancelar y agregar
  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(170, 48),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(170, 48),
          ),

          /// Cuando se presiona el botón, este código se ejecuta. Primero, verifica si el texto del título está vacío. Si lo está, muestra una barra de notificaciones pidiendo al usuario que introduzca una descripción.
          ///
          /// Luego, verifica si el texto de la descripción está vacío. Si lo está, muestra una barra de notificaciones pidiendo al usuario que introduzca un título.
          ///
          /// Si tanto el título como la descripción no están vacíos, entonces se crea un nuevo evento `AddTodoEvent` con el título y la descripción proporcionados, y se añade al `LogicalService`.
          onPressed: () {
            if (title.text.isEmpty) {
              snackBar(context, "Please input your description");
            } else if (description.text.isEmpty) {
              snackBar(context, "Please input your title");
            } else {
              context.read<LogicalService>().add(AddTodoEvent(
                  context: context,
                  title: title.text,
                  description: description.text));
            }
          },

          /// Este es un widget `BlocBuilder` que se reconstruye cada vez que cambia el estado de `LogicalService`.
          ///
          /// El `builder` toma el `context` y el `state` actual de `LogicalService` y devuelve un widget en función del estado.
          ///
          /// Si el estado es `AddTodoLoading`, verifica si `isLoading` es verdadero. Si lo es, muestra un `CircularProgressIndicator`. Si no lo es, muestra un widget `Text` con el texto 'Add task'.
          ///
          /// Si el estado no es `AddTodoLoading`, simplemente muestra un widget `Text` con el texto 'Add task'.
          child: BlocBuilder<LogicalService, LogicState>(
            builder: (context, state) {
              if (state is AddTodoLoading) {
                bool isLoading = state.isLoading;
                return isLoading
                    ? const CircularProgressIndicator()
                    : Text('Add task');
              } else {
                return Text('Add task');
              }
            },
          ),
        ),
      ],
    );
  }
//Contenedor donde se recibe la informacion del titulo

  Widget title_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: title,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: 'title',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color(0xffc5c5c5),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              )),
        ),
      ),
    );
  }

//Contenedor donde se recibe la informacion de la descripción
  Padding subtite_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          maxLines: 3,
          controller: description,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'Description',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blueGrey,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
