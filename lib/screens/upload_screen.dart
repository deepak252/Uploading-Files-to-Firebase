
import 'dart:io';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:upload_files/api/firebase_api.dart';
import 'package:upload_files/widgets/button_widget.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  UploadTask task;

  File file;

  @override
  Widget build(BuildContext context) {
    // String filePath=file.path;
    final  fileName= file==null ? 'No file selected': basename(file.path);
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Firebase'),
      ),
      body: Container(
        padding: EdgeInsets.all(34),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if(file!=null)
                Image.file(
                  file,
                ),
              const SizedBox(height: 30,),
              ButtonWidget(
                icon:Icon(Icons.attach_file),
                label: 'Select File',
                onPressed: selectFile,
                color: Colors.green,
              ),
              const SizedBox(height: 16,),
              Text(
                fileName,

              ),
              const SizedBox(height: 48,),
              ButtonWidget(
                icon:Icon(Icons.upload_file),
                label: 'Upload File',
                onPressed: uploadFile,
              ),
              const SizedBox(height: 18,),

              task!=null? buildUploadStatus(task) : Container(),
            ],
          ),
        ),
      ),
    );
  }
  Future selectFile() async{
    final result=await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result==null) return;
    final path=result.files.single.path;
    setState(() {
     file=File(path); 
    });
  }

  Future uploadFile() async{
    if(file==null) return ;
    
    final fileName=basename(file.path);
    final destination='files/$fileName';
    
    task = FirebaseApi.uploadFile(destination,file);
    setState(() {});
    //-----------------------
    //getting download url of uploaded file
    if(task==null) return;

    final snapshot=await task.whenComplete((){});
    final urlDownload=await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task){
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context,snapshot){
        if(snapshot.hasData){
          final snap=snapshot.data;
          final progress=snap.bytesTransferred/snap.totalBytes;
          final percentage=(progress * 100).toStringAsFixed(2);
          return Text(
            '$percentage %',
            style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold) ,
          );
        }else{
          return Container();
        }
      },
    );
  }
}