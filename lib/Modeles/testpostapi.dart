import 'dart:convert';

import 'package:http/http.dart' as http;
/*


_sendBuyBtnReq(
      {required BuildContext context,
      required String Amount,
      required String ScoreAmount}) async {           //async permet d'executer en parallele
    final prefs = await SharedPreferences.getInstance();         //SharedPreferences.getInstance() : donné récupérer
    var toke = prefs.getString('mykey');
    var ide = prefs.getString('mykey');

    final url = Uri.parse('my url');          //cacher l'url donné
    var body = Map<String, dynamic>();        // dynamic est un object ou on dit au systeme trust me

    body["CustomerId"] = '$ide';
    body["Amount"] = '$Amount';
    body["Credit"] = '$ScoreAmount';
    body["Description"] = '2';

    http.Response response = await http.post(
      url,
      body: json.encode(body),
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer $toke'
      },
    );

    if (response.statusCode == 200) {
      print(await response.body.toString());
    } else {
      print(response.reasonPhrase);
      var messageM = jsonDecode(utf8.decode(response.bodyBytes));
      var MessageModel = messageModel(messageM['message']);
      // print(MessageModel._message);
      showSnackBar7(context, MessageModel.message);
    }
}

test() async {
    final response = await http.post(
        Uri.parse('https://projets.iut-orsay.fr/prj-as-2022/api/'),
        headers:<String,String>{
            'Content-type':'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String,String>{'controleurPartie':controleur,'getAllParties':action,}),
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      print(response.reasonPhrase);
     var messageM = jsonDecode(utf8.decode(response.bodyBytes));
     print(messageM);

    } else {
      print(response.reasonPhrase);
     var messageM = jsonDecode(utf8.decode(response.bodyBytes));
     print(messageM);
    }
   
}



//import 'package:http/http.dart' as http;

static ocr(File image) async {
    var url = '${API_URL}ocr';
    var bytes = image.readAsBytesSync();

    var response = await http.post(
        url,
        headers:{ "Content-Type":"multipart/form-data" } ,
        body: { "lang":"fas" , "image":bytes},
        encoding: Encoding.getByName("utf-8")
    );

    return response.body;

  }
*/
testConnection() async {
var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getAllParties");
    final response = await http.get(url, headers: {
      //'Authorization' : 'basic $cred',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      print(response.body.toString());
      print(response.reasonPhrase);
     var messageM = jsonDecode(utf8.decode(response.bodyBytes));
     print(messageM);
     
    } else {
      print(response.reasonPhrase);
     var messageM = jsonDecode(utf8.decode(response.bodyBytes));
     print(messageM);
    }
}
    
 testConnection2() async {
var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getAllParties");
    final response = await http.get(url, headers: {
      //'Authorization' : 'basic $cred',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      print(response.body.toString());
      print(response.reasonPhrase);
     var messageM = jsonDecode(utf8.decode(response.bodyBytes));
     print(messageM);
     return messageM;
    } else {
      print(response.reasonPhrase);
     var messageM = jsonDecode(utf8.decode(response.bodyBytes));
     print(messageM);
     return -1;
    }
}

/*
import 'dart:convert';

Decode : JsonDecoder().convert("$response");

Encode : JsonEncoder().convert(object);
*/
/*
final jsonData = {
  "name": "John",
  "age": 20
}
*/
/*
import 'dart:convert';

void testParseJsonDirect() {
  var name = parsedJson['name'];
  var age = parsedJson['age'];
  print('$name is $age');
}
*/

/*
class Student {
  final String name;
  final int age;

  Student({this.name, this.age});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(name: json['name'], age: json['age']);
  }

  // Override toString to have a beautiful log of student object
  @override
  String toString() {
    return 'Student: {name = $name, age = $age}';
  }
}


void testParseJsonObject() {
  final jsonString = r'''
      {
        "name": "John",
        "age": 20
      }
  ''';

  // Use jsonDecode function to decode the JSON string
  // I assume the JSON format is correct 
  final json = jsonDecode(jsonString);
  final student = Student.fromJson(json);

  print(student);
}



void main(List<String> args) {
  testParseJsonObject();
}

// Output
Student: {name = John, age = 20}

*/

/*
{
"id":"xx888as88",
"timestamp":"2020-08-18 12:05:40",
"sensors":[
    {
     "name":"Gyroscope",
     "values":[
         {
          "type":"X",
          "value":-3.752716,
          "unit":"r/s"
         },
         {
           "type":"Y",
           "value":1.369709,
           "unit":"r/s"
         },
         {
           "type":"Z",
           "value":-13.085,
           "unit":"r/s"
         }
       ]
    }
  ]
}

void setReceivedText(String text) {
    Map<String, dynamic> jsonInput = jsonDecode(text);
    
    _receivedText = 'ID: ' + jsonInput['id'] + '\n';
    _receivedText += 'Date: ' +jsonInput['timestamp']+ '\n';
    _receivedText += 'Device: ' +jsonInput['sensors'][0]['name'] + '\n';
    _receivedText += 'Type: ' +jsonInput['sensors'][0]['values'][0]['type'] + '\n';
    _receivedText += 'Value: ' +jsonInput['sensors'][0]['values'][0]['value'].toString() + '\n';
    _receivedText += 'Type: ' +jsonInput['sensors'][0]['values'][1]['type'] + '\n';
    _receivedText += 'Value: ' +jsonInput['sensors'][0]['values'][1]['value'].toString() + '\n';
    _receivedText += 'Type: ' +jsonInput['sensors'][0]['values'][2]['type'] + '\n';
    _receivedText += 'Value: ' +jsonInput['sensors'][0]['values'][2]['value'].toString();
     _historyText = '\n' + _receivedText;
}

*/


/*
String rawJson = '{"name":"Mary","age":30}';

Map<String, dynamic> map = jsonDecode(rawJson); // import 'dart:convert';

String name = map['name'];
int age = map['age'];

Person person = Person(name, age);
*/