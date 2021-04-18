import 'dart:async';

import 'package:my_flutter_app/functionalities/sql_service.dart';
import 'package:my_flutter_app/models/userModel.dart';

class UsersBloc {
  String userId;
  UsersBloc({this.userId}) {
    getUsers(userId);
  }

  final _userController = StreamController<List<User>>.broadcast();

  get users => _userController.stream;

  getUsers(String userId) async {
    _userController.sink.add(await DBProvider.db.getUser(userId));
  }

  // Future<void> blockUnblock(User user) async {
  //   await DBProvider.db.blockOrUnblock(user);
  //   await getUsers();
  // }

  // Future<void> delete(int id) async {
  //   await DBProvider.db.deleteUser(id);
  //   await getUsers();
  // }

  // Future<void> add(User user) async {
  //   await DBProvider.db.newUser(user);
  //   await getUsers();
  // }

  dispose() {
    _userController.close();
  }
}
