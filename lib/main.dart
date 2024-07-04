import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/config/router/app_router.dart';
import 'package:todo_list/config/theme/theme.dart';
import 'package:todo_list/infrastructure/services/task_service.dart';
import 'package:todo_list/presentation/todo/bloc/logic_bloc.dart';

void main() async {
  TodoRepository service = TodoRepository();
  runApp(MultiProvider(providers: [
    BlocProvider<LogicalService>(create: (context) => LogicalService(service)),
    StreamProvider<LogicState>.value(
      value: LogicalService(service).stream,
      initialData: LogicInitializeState(),
    ),
  ], child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
    );
  }
}
