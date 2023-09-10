import 'package:bookdoc/Services/Firebase/FireStore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Sign up
Future<String?> signUp(String email, String password,String role,String userName) async {
  try {
    UserCredential newuser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await newuser.user!.updateDisplayName(userName);
    await newuser.user!.reload(); // Reload the user to apply the changes
    CreateUser(newuser,role,userName);
  } catch (e) {
    print(e);
    return e.toString();
  }
}

// Sign in
Future<String?> signIn(String email, String password) async {
  try {
    UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    print(e);
    return e.toString();
  }
}

// Sign out
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
