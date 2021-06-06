
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask uploadFile(String destination,File file){
    try{
      final ref=FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);

    }on FirebaseException catch(e){
      return null;
    }
  }
  // method for Upload BYTES instead of FILES     
  static UploadTask uploadBytes(String destination,Uint8List data){
    try{                                         //^ list of bytes
      final ref=FirebaseStorage.instance.ref(destination);
      return ref.putData(data);

    }on FirebaseException catch(e){
      return null;
    }
  }
}