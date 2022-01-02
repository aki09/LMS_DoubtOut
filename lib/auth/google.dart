import 'package:doubt_out/model/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
Future<bool> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuth =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuth.accessToken,
    idToken: googleSignInAuth.idToken,
  );
  print(googleSignInAuth.accessToken);

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  var name = user.displayName;
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  //UserConfig.uid=user.uid;
  print(user.photoUrl);
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  UserData().setUserLoggedIn(user.email, user.uid, name,user.photoUrl);

  return true;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}
