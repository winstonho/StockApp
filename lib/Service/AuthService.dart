import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/model/MasterData.dart';
import 'package:flutter_app/model/Myuser.dart';

class AuthServiceDesktop
{

  final FirebaseAuth auth = FirebaseAuth.instance;

  MyUser firebaseUserToUser(User user)
  {
    if(user != null)
    {
      print("testing");
      print(user.email);
      print(user.emailVerified);
      MyUser temp =  new  MyUser(uid:user.id);
      temp.name = user.displayName != null ? user.displayName :"temp";
      return temp;
    }

    return  null;
  }




  //sign in email &password
  //register with email & password
  Future registerWithEmail(String email,String password, String name)async
  {
    try
    {
      var result =  await auth.signUp(email, password);
      if(result != null)
      {
        print("new email create");

        //await DatabaseService().uploadImageToFirebase(MasterData.instance.user.imageUrl);
        //await DatabaseService().updateUserData(MasterData.instance.user);
        MasterData.instance.user = firebaseUserToUser(result);
        MasterData.instance.user.uid = result.id;
        MasterData.instance.user.name = name;
        MasterData.instance.user.email = email;

        return MasterData.instance.user;
      }
    }
    catch(e)
    {

      String temp = e.toString();
      temp = temp.substring(temp.indexOf(',') +1);
      temp = temp.substring(1,temp.indexOf(','));

      return temp;
    }
  }

  Future signInWithEmail(String email,String password)async
  {
    try
    {
      User result =  await auth.signIn(email,password);
      if(result != null)
      {
        dynamic temp = await DatabaseService().getUserDataFromFireBase(result.id);
        if(temp != null)
        {
          MasterData.instance.user = temp;
          return temp;
        }

      }
      //this cause should never be reach
      return "SomeTing it wrong please contact IT support";
    }
    catch(e)
    {
      print(e.toString());
      String temp = e.toString();
      temp = temp.substring(temp.indexOf(':')+2);
      return temp;
    }
  }

  //sign out
  Future signOut() async
  {
    try
    {
      auth.signOut();
    }
    catch(e)
    {
      print(e.toString());
    }
  }



  Future<void> changePassword(String newPassword) async
  {
    try {

      return auth.changePassword(newPassword);
    }
    catch (e)
    {
      print("error update password");
      print(e.toString());
      return null;
    }
  }

  void forgetPassword(String email) async
  {
    await auth.resetPassword(email);
  }

}