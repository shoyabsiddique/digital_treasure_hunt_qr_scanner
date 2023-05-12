import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrtest/scan.dart';
class Display extends StatefulWidget {
  Display({Key? key}) : super(key: key);
  static const encryptionChannel = const MethodChannel('enc/dec');

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  String pass="";
  String railfenceEncrypt(String text, int key) {
    int row = key, col = text.length, x = 0, y = 0;
    String result = '';
    bool dir = false;
    var matrix = List.generate(row, (i) => List.generate(col, (j)=>""));
    for (var i = 0; i < text.length; i++) {
      if (x == 0 || x == row - 1) dir = !dir;
      matrix[x][y++] = text[i];
      dir ? x++ : x--;
    }
    for (var i = 0; i < row; i++) {
      for (var j = 0; j < col; j++) {
        if (matrix[i][j] != null) result += matrix[i][j];
      }
    }
    return result;
  }

  String railfenceDecrypt(String text, int key) {
    String result = '';
    int row = 0, col = 0, index = 0;
    bool dir = true;
    var matrix = List.generate(key, (i) => List.generate(text.length, (j) => ""));

    for (var i = 0; i < text.length; i++) {
      if (row == 0) dir = true;
      if (row == key - 1) dir = false;
      matrix[row][col++] = '*';
      dir ? row++ : row--;
    }

    for (var i = 0; i < key; i++) {
      for (var j = 0; j < text.length; j++) {
        if (matrix[i][j] == '*' && index < text.length)
          matrix[i][j] = text[index++];
      }
    }

    row = 0;
    col = 0;

    for (var i = 0; i < text.length; i++) {
      if (row == 0) dir = true;
      if (row == key - 1) dir = false;
      if (matrix[row][col] != '*') result += matrix[row][col++];
      dir ? row++ : row--;
    }

    return result;
  }
  String hint="";
  @override
  Widget build(BuildContext context) {
    String data = Scan.data;
    return Scaffold(
      appBar: AppBar(title: Text("Decode"),),
      body: Column(
        children: [
          Text(data.toString(),style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.07),),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (val){
              setState(() {
                this.pass = val;
              });
            },
            decoration: InputDecoration(
                hintText: "Enter the key",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width:10)
                )
            ),
          ),
          ElevatedButton(onPressed: (){
            String dec = railfenceDecrypt(data, int.parse(pass));
            print(dec);
            setState(() {
              hint = dec;
            });
          }, child: Text("Decode")),
          Text(hint, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.07),)
        ],
      ),
    );
  }
}
