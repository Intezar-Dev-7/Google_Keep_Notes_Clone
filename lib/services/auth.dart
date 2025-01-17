import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServicesI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;

  Stream<User?> get authState => _auth.authStateChanges();

  final GoogleSignIn googleSignIn = GoogleSignIn();

/*  Future<void> signInGoogle()async {
    try{
      print("--------------------------------- 0 ");
      final GoogleSignInAccount? getUser = await GoogleSignIn().signIn();
      print("--------------------------------- 1 ");
      final GoogleSignInAuthentication? googleAuth = await getUser?.authentication;
      print("--------------------------------- 2 ");
      print("${googleAuth?.idToken}");

      if(googleAuth?.accessToken != null && googleAuth?.idToken != null){
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await _auth.signInWithCredential(credential);
      }else{
        print("google auth is null ---------------------------------- id token is null ");
      }
    }catch(error){
      print("there is some issue while sign in ------------------------------------ $error");
    }
  }*/

//SIGN IN KA Function
  Future<User?> signInWithGoogle() async {
    try {
      print("========1======");
      //SIGNING IN WITH GOOGLE
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      print("=======2=======");
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      print('User: --------------------------------------${googleSignInAccount
          .email}');

      //CREATING CREDENTIAL FOR FIREBASE
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      //SIGNING IN WITH CREDENTIAL & MAKING A USER IN FIREBASE  AND GETTING USER CLASS
      final userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      //CHECKING IS ON
      assert(!user!.isAnonymous);
      assert(await user!.getIdToken() != null);

      final User? currentUser = _auth.currentUser;
      assert(currentUser!.uid == user!.uid);
      print(user);
      return user;
    } catch (e) {
      print('there is problem while sign in with google $e');
    }
    return null;
  }

  void signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
