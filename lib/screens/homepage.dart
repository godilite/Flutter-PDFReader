import 'dart:io';
import 'dart:math';
import 'package:connect/constants.dart';
import 'package:connect/screens/pdfreader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List books = [];

void direct()async{
if (await Permission.storage.request().isGranted) {
var dir = Directory('/sdcard');
  try {
    var dirList = dir.list(recursive: true, followLinks: false);
    await for (FileSystemEntity f in dirList) {
      if (f is File) {
        if (p.extension(f.path) == '.pdf') {
          books.add({'path': f.path, 'stats': await f.stat()});
          print('Found file ${f.path}'); 
        }
      }
      setState(() {
        
      }); 
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

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
          showCupertinoDialog(context: (context), 
          builder: (_)=>CupertinoAlertDialog(
                    title: Text("Closing Reader"),
                    content: Text("Are you sure?"),
                    insetAnimationCurve: Curves.bounceIn,
                    insetAnimationDuration: Duration(milliseconds: 1000),
                    actions: <Widget>[
                      FlatButton(child: Text('No'), onPressed: (){Navigator.pop(context);},),
                      FlatButton(child: Text("Yes"), onPressed: (){
                        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                      },
                    )
                  ],
                )
              );
          return false;
        },
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: kBlue,
        title: Icon(Icons.local_library, size: 30,),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[IconButton(icon: Icon(Icons.search), onPressed: (){
          showSearch(context: context, delegate: DataSearch(books));
          })],
      ),
      body: Padding(
        padding: EdgeInsets.only(top:8.0),
        child: books.isEmpty ? Center(child: CircularProgressIndicator()): ListView.builder(
          itemBuilder: (BuildContext context, index){
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade100, style: BorderStyle.solid),
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PDFScreen(books[index]['path'])),
              ),
              onLongPress: (){
                showCupertinoDialog(
                  context: context,
                  builder: (_)=> CupertinoAlertDialog(
                    title: Text("Deleting file"),
                    content: Text("Do you want to delete ${books[index]['path'].toString().split('/').last}?"),
                    insetAnimationCurve: Curves.bounceIn,
                    insetAnimationDuration: Duration(milliseconds: 1000),
                    actions: <Widget>[
                      FlatButton(child: Text('No'), onPressed: (){Navigator.pop(context);},),
                      FlatButton(child: Text("Yes"), onPressed: (){
                        var file = File(books[index]['path']);
                          file.delete();
                          Navigator.pop(context);
                          books.removeAt(index);
                          setState(() {
                          });                         
                        },
                      )
                    ],
                  )
                  );
              },
              child: ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 40,), 
                title: Text(books[index]['path'].toString().split('/').last, style: 
                TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                subtitle: Text("${books[index]['stats'].changed.day} - ${books[index]['stats'].changed.month} - ${books[index]['stats'].changed.year}" "   " "${formatBytes(books[index]['stats'].size, 2)}"),
                ),
              )
            );
          },
          itemCount: books.length,
          ),
        )
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String>{

  final books;
  final recentSearch = [];
  DataSearch(this.books);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [ IconButton(icon: 
    Icon(Icons.clear), 
    onPressed: (){
      query = "";
    }),];
  }

  @override
  Widget buildLeading(BuildContext context) {
      return IconButton(icon: 
        AnimatedIcon(icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation, ), 
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    
    return Card(
      child: Text(query)
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
     final searchList = query.isEmpty?
     recentSearch:books;
     return ListView.builder(itemBuilder: (context, index)=>ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 40,), 
                title: Text(searchList[index]['path'].toString().split('/').last, style: 
                TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                subtitle: Text("${searchList[index]['stats'].changed.day} - ${searchList[index]['stats'].changed.month} - ${searchList[index]['stats'].changed.year}"),
        ),
     itemCount: searchList.length,
     );
  }

}