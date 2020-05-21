import 'dart:async';
import 'dart:io';
import 'package:connect/screens/pdfreader.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  Future<Directory> _tempDirectory;
  Future<Directory> _appSupportDirectory;
  Future<Directory> _appLibraryDirectory;
  Future<Directory> _appDocumentsDirectory;
  Future<Directory> _externalDocumentsDirectory;
  Future<List<Directory>> _externalStorageDirectories;
  Future<List<Directory>> _externalCacheDirectories;
  List books = [];
  Future<void> _requestTempDirectory() async {
    if (await Permission.storage.request().isGranted) {
      direct();
      setState(() {
        _tempDirectory = getTemporaryDirectory();
      }); 
    }
  }

void direct()async{
  if (await Permission.storage.request().isGranted) {
var dir = Directory('/sdcard');
  try {
    var dirList = dir.list(recursive: true, followLinks: false);
    await for (FileSystemEntity f in dirList) {
      if (f is File) {
        if (p.extension(f.path) == '.pdf') {
          books.add(f.path);
          print('Found file ${f.path}'); 
        }
      } 
    }
  } catch (e) {
    print(e.toString());
  }
}
}

   void initState(){
      super.initState();
      direct();
      setState(() { });
    }
  
  Widget _buildDirectory(
      BuildContext context, AsyncSnapshot<Directory> snapshot) {
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        text = Text('path: ${snapshot.data.path} ${p.basename(snapshot.data.path)} ${p.rootPrefix(snapshot.data.path)} ${p.current}');
      } else {
        text = const Text('path unavailable');
      }
    }
    return Padding(padding: const EdgeInsets.all(16.0), child: text);
  }

  Widget _buildDirectories(
      BuildContext context, AsyncSnapshot<List<Directory>> snapshot) {
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        final String combined =
            snapshot.data.map((Directory d) => d.path).join(', ');
        text = Text('paths: $combined');
      } else {
        text = const Text('path unavailable');
      }
    }
    return Padding(padding: const EdgeInsets.all(16.0), child: text);
  }

  void _requestAppDocumentsDirectory() {
    setState(() {
      _appDocumentsDirectory = getApplicationDocumentsDirectory();
    });
  }

  void _requestAppSupportDirectory() {
    setState(() {
      _appSupportDirectory = getApplicationSupportDirectory();
    });
  }

  void _requestAppLibraryDirectory() {
    setState(() {
      _appLibraryDirectory = getLibraryDirectory();
    });
  }

  void _requestExternalStorageDirectory() {
    setState(() {
      _externalDocumentsDirectory = getExternalStorageDirectory();
    });
  }

  void _requestExternalStorageDirectories(StorageDirectory type) {
    setState(() {
      _externalStorageDirectories = getExternalStorageDirectories(type: type);
    });
  }

  void _requestExternalCacheDirectories() {
    setState(() {
      _externalCacheDirectories = getExternalCacheDirectories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reader'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, index){
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, style: BorderStyle.solid),
          ),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PDFScreen(books[index])),
            ),
            child: Text(books[index])
            )
        );
      },
      itemCount: books.length,
      )
    );
  }
}
