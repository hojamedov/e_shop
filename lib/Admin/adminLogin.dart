import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.blue, Colors.purpleAccent],
              begin: const FractionalOffset (0.0, 0.0),
              end: const FractionalOffset (1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Salam Market",
          style: TextStyle(fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIdTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.blue, Colors.purpleAccent],
            begin: const FractionalOffset (0.0, 0.0),
            end: const FractionalOffset (1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "images/admin.png",
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Admin",
                style: TextStyle(color: Colors.white, fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIdTextEditingController,
                    data: Icons.person,
                    hintText: "id",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: "Parolyňyz",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            RaisedButton(
              onPressed: () {
                _adminIdTextEditingController.text.isNotEmpty
                    && _passwordTextEditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                    context: context,
                    builder: (c)
                    {
                      return ErrorAlertDialog(message: "Email bilen parolyňyzy ýazyň",);
                    }
                );
              },
              color: Colors.pink,
              child: Text("Login bilen girmek", style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.white,
            ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton.icon(
              onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthenticScreen())),
              icon: (Icon(Icons.emoji_people, color: Colors.white,)),
              label: Text("Men Admin däl", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin()
  {
    FirebaseFirestore.instance.collection("admins").get().then((snapshot){
      snapshot.docs.forEach((result) {
        if(result.data()["id"] != _adminIdTextEditingController.text.trim())
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Loginyňyz nädogry"),));
        }
        else if(result.data()["password"] != _passwordTextEditingController.text.trim())
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Parolyňyz nädogry"),));
        }
        else
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hoş Geldiňiz" + result.data()["name"]),));

            setState(() {
              _adminIdTextEditingController.text = "";
              _passwordTextEditingController.text = "";
            });

            Route route = MaterialPageRoute(builder: (c) => UploadPage());
            Navigator.pushReplacement(context, route);
          }
      });
    });
  }
}
