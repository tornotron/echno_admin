import 'package:firebase_auth/firebase_auth.dart';

class InterfaceUserReading {
  Future userProfileReading({bool? name, bool? email}) async {}
}

class EmUserReading implements InterfaceUserReading {
  @override
  Future userProfileReading({bool? name, bool? email}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    try {
      if (name == true) {
        final getName = user.displayName;
      }
      if (email == true) {
        final getEmail = user.email;
      }

      if (name == null && email == null) {
        // Code for the case when both name and email are null
      } else {}
    } catch (e) {
      print(e);
    }
  }
}