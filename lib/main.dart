import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'GetLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(weather_app());
}

class weather_app extends StatefulWidget {

  @override
  _weather_appState createState() => _weather_appState();
}

class _weather_appState extends State<weather_app> {

//Enter your API instead of X's
  String apiKey = 'XXXXXXXXXXXXXXXX';
  var description;
  var temp;
  String city;



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Container(
              child: displayImage(),//Image.asset('images/Day_time.jpg'),
            ),
            Container(
              margin: EdgeInsets.only(top: 40.0),
              child: Text("You are in",style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[500],
              ),),
            ),
            Container(
           margin: EdgeInsets.only(top: 30.0,left: 70.0,),

           child: Row(
             children: [
               Container(
                 child: Text(city.toString(),style: TextStyle(
                   fontSize: 35.0,
                   fontWeight: FontWeight.bold,
                   color: Colors.blue[500],
                 ),),
               ),
               SizedBox(width: 30.0,),
               Container(
                 child: Icon(
                   Icons.location_on,
                   color: Colors.red,
                   size: 30.0,
                 ),
               ),
             ],
           ),
         ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 25.0),
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.wb_sunny,
                  color: Colors.amber,
                ),
                title: Text('Temperature: ${temp.toString()} C',),
                subtitle: Text('Status: ${description.toString()}'),
              ),
            ),
            Container( child: Center(
              child: FlatButton(
                child: Text('Get weather info'),
                color: Colors.blue[500],
                textColor: Colors.white,
                onPressed: (){
                  setState(() {
                    getLocation();
                  });
                },
              ),
            ),
            )
          ],
        ),
      ),
    );
  }

  //show image based on time
  displayImage()
  {
    var date= DateTime.now();
    //final currentTime=DateFormat.H().format(now);
    if((date.hour <= 6) || (date.hour >=18))
      {
        return Image.asset('images/Night_time.jpg');
      }
    else if((date.hour>6) || (date.hour <18))
    {

      return Image.asset('images/Day_time.jpg');
    }
  }

  //getLocation
  void getLocation() async{
    GetLocation getlocation = GetLocation();
    await getlocation.getCurrentLocation();

    print(getlocation.latitude);
    print(getlocation.longitude);
    print(getlocation.city);
    city = getlocation.city;
    getTemp(getlocation.latitude, getlocation.longitude);
  }


  //Get current temp
  Future<void> getTemp(double lat, double lon) async{
    http.Response response = await http.get('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    print(response.body);

    var dataDecoded = jsonDecode(response.body);
    description = dataDecoded['weather'][0]['description'];
    temp = dataDecoded['main']['temp'];
    print(temp);


  }
}

