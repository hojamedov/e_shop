
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen()
  {
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
        leading: IconButton(
          icon: Icon(Icons.border_color, color: Colors.white,),
          onPressed: ()
          {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            child: Text("Çykmak", style: TextStyle(color: Colors.pink, fontSize: 16.0, fontWeight: FontWeight.bold,),),
            onPressed: ()
            {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody()
  {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.blue, Colors.purpleAccent],
          begin: const FractionalOffset (0.0, 0.0),
          end: const FractionalOffset (1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two, color: Colors.white, size: 150.0,),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                child: Text("Täze haryt goşmak", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                color: Colors.green,
                onPressed: ()=> takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext)
  {
    return showDialog(
      context: mContext,
      builder: (con)
        {
          return SimpleDialog(
            title: Text("Harydyň surady", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                child: Text("Kameradan almak", style: TextStyle(color: Colors.green)),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Galereýadan almak", style: TextStyle(color: Colors.green)),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Colors.green)),
                onPressed: ()
                {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  capturePhotoWithCamera() async
  {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }

  pickPhotoFromGallery() async
  {
    Navigator.pop(context);
    File imagePicker = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = imagePicker;
    });
  }

  displayAdminUploadFormScreen()
  {
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
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: clearFormInfo),
        title: Text("Täze haryt", style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold,),),
        actions: [
          FlatButton(
            onPressed: uploading ? null : ()=> uploadImageAndSaveItemInfo(),
            child: Text("Ýüklemek", style: TextStyle(color: Colors.pink, fontSize: 16.0, fontWeight: FontWeight.bold,),),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "Gysga maglumaty",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: "Ady",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Doly maglumaty",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: "Bahasy",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,)

        ],
      ),
    );
  }

  clearFormInfo()
  {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async
  {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);

  }

  Future<String> uploadItemImage(mFileImage) async
  {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("product_$productId.jpg");
    UploadTask uploadTask = ref.putFile(mFileImage);
    uploadTask.then((urlImage) {
      urlImage.ref.getDownloadURL();
    });
  }

  saveItemInfo(String downloadUrl)
  {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(productId).set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEditingController.text.trim(),
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }
}

