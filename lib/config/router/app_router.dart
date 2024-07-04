import 'package:go_router/go_router.dart';
import 'package:todo_list/presentation/screens/screens.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => HomeScreen(),
  ),
  GoRoute(path: '/add', builder: (context, state) => AddScreen())
]);
