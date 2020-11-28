
import 'package:falty/src/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthProvider {

  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  
  //constructor de auth provider
  AuthProvider(){
    _iniciarFirebase();
  }

  //inicializaciones al crearlo
  _iniciarFirebase() async{
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
  }

  //login google
  Future<UserModel> loginGoogle() async {
    try{
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken, 
        accessToken: googleSignInAuthentication.accessToken
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User _user = result.user;

      return _userFromFirebaseUser(_user);
    }catch (e){
      print('el error: ' + e.toString());
      return null;
    }    
  }

  //sing out google
  Future<void> googleSignout() async {
    await _auth.signOut().then((value) {
      _googleSignIn.signOut();

    });
  }

  //crea un nuevo usuario
  UserModel _userFromFirebaseUser(User user){
    //TODO crear que al iniciar session se haga información nueva de un usuario en 
    return user != null 
            ? UserModel(
              uid: user.uid, 
              nick: 'a', 
              email: user.email, 
              name: 'a', 
              surname: 'b', 
              color: 'yellow',
              photo: user.photoURL, 
              seguidos: [], 
              bloqueados: [], 
              logros: [], 
              colecciones: []) 
            : null;
  }

}

