import 'dart:io';

import 'package:echno_attendance/attendance/utilities/crud_exceptions.dart';
import 'package:echno_attendance/crud/services/db_user_services.dart';
import 'package:echno_attendance/crud/utilities/crud_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  // Create a mock database user service
  final mockDatabaseUserService = MockDatabaseUserService();

  // Test the open() method
  test(
      'open() should throw DatabaseAlreadyOpenException if database is already open',
      () async {
    // Open the database
    await mockDatabaseUserService.open();

    // Try to open the database again
    expect(() async => await mockDatabaseUserService.open(),
        throwsA(const TypeMatcher<DatabaseAlreadyOpenException>()));
  });

  // Test the close() method
  test('close() should throw DatabaseNotOpenException if database is not open',
      () async {
    // Try to close the database without opening it first
    expect(() async => mockDatabaseUserService.close(),
        throwsA(const TypeMatcher<DatabaseNotOpenException>()));
  });

  // Test the createUser() method
  test(
      'createUser() should throw UserAlreadyExists exception if user already exists',
      () async {
    // Create a user
    await mockDatabaseUserService.createUser(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
      phoneNumber: 1234567890,
      employeeID: '1234567890',
      employeeRole: 'Software Engineer',
      isActiveEmployee: true,
    );

    // Try to create the same user again
    expect(
        () async => await mockDatabaseUserService.createUser(
              id: 1,
              name: 'John Doe',
              email: 'john.doe@example.com',
              phoneNumber: 1234567890,
              employeeID: '1234567890',
              employeeRole: 'Software Engineer',
              isActiveEmployee: true,
            ),
        throwsA(const TypeMatcher<UserAlreadyExists>()));
  });

  // Test the deleteUser() method
  test(
      'deleteUser() should throw CouldNotDeleteUser exception if user does not exist',
      () async {
    expect(
        () async => await mockDatabaseUserService.deleteUser(
            employeeID: 'non-existent-employee-id'),
        throwsA(const TypeMatcher<CouldNotDeleteUser>()));
  });

  // Test the getUser() method
  test(
      'getUser() should throw CouldNotFindUser exception if user does not exist',
      () async {
    expect(
        () async => await mockDatabaseUserService.getUser(
            employeeID: 'non-existent-employee-id'),
        throwsA(const TypeMatcher<CouldNotFindUser>()));
  });

  // Test the updateUser() method
  // test(
  //     'updateUser() should throw CouldNotUpdateUser exception if user does not exist',
  //     () async {
  //   expect(
  //       () async => await mockDatabaseUserService.updateUser(
  //             user: DBUser(
  //               id: 1,
  //               name: 'John Doe',
  //               email: 'john.doe@example.com',
  //               phoneNumber: 1234567890,
  //               employeeID: '1234567890',
  //               employeeRole: 'Site Engineer',
  //               isActiveEmployee: true,
  //             ),
  //             employeeID: 'non-existent-employee-id',
  //             employeeRole: 'Project Engineer',
  //             isActiveEmployee: false,
  //           ),
  //       throwsA(const TypeMatcher<CouldNotUpdateUser>()));
  // });
}

class DatabaseAlreadyOpenException implements Exception {}

class MockDatabaseUserService implements DatabaseUserService {
  // A flag to indicate whether the database is open
  bool _isOpen = false;

  // A list of users in the database
  final List<DBUser> _users = [];

  // A map of employee IDs to user objects
  final Map<String, DBUser> _employeeIDToUserMap = {};

  @override
  Future<void> open() async {
    if (_isOpen) throw DatabaseAlreadyOpenException();

    // Get the documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Create the database file if it doesn't exist
    final databaseFile = File('${documentsDirectory.path}/echno_attendance.db');
    await databaseFile.create(recursive: true);

    _isOpen = true;
  }

  @override
  Future<void> close() async {
    if (!_isOpen) {
      throw DatabaseNotOpenException();
    }

    _isOpen = false;
  }

  @override
  Future<DBUser> createUser({
    required int id,
    required String name,
    required String email,
    required int phoneNumber,
    required String employeeID,
    required String employeeRole,
    required bool isActiveEmployee,
  }) async {
    if (!_isOpen) {
      throw DatabaseNotOpenException();
    }

    // Check if the user already exists
    if (_employeeIDToUserMap.containsKey(employeeID)) {
      throw UserAlreadyExists();
    }

    // Create a new user object
    final user = DBUser(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      employeeID: employeeID,
      employeeRole: employeeRole,
      isActiveEmployee: isActiveEmployee,
    );

    // Add the user to the list of users
    _users.add(user);

    // Add the user to the map of employee IDs to user objects
    _employeeIDToUserMap[employeeID] = user;

    return user;
  }

  // @override
  // Future<void> updateUser({
  //   required DBUser user,
  //   required String employeeID,
  //   required String employeeRole,
  //   required bool? isActiveEmployee,
  // }) async {
  //   if (!_isOpen) {
  //     throw DatabaseNotOpenException();
  //   }

  //   // Find the user by employee ID
  //   final originalUser = _employeeIDToUserMap[employeeID];

  //   // If the user does not exist, throw an exception
  //   if (originalUser == null) {
  //     throw CouldNotUpdateUser();
  //   }

  //   // Update the user's information
  //   originalUser.employeeRole = employeeRole;
  //   if (isActiveEmployee != null) {
  //     originalUser.isActiveEmployee = isActiveEmployee;
  //   }

  //   // Update the map of employee IDs to user objects
  //   _employeeIDToUserMap[employeeID] = originalUser;
  // }

  @override
  Future<DBUser> getUser({required String employeeID}) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<DBUser> updateUser(DBUser user, String employeeID,
      String? employeeRole, bool? isActiveEmployee) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser({required String employeeID}) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }
}