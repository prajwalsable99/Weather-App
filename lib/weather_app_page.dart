import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import './secrets.dart';


class WeatherAppPage extends StatefulWidget {

  const WeatherAppPage({super.key});

  @override
  State<WeatherAppPage> createState() => _WeatherAppPageState();
}

class _WeatherAppPageState extends State<WeatherAppPage> {


  @override
  void initState() {
    
    super.initState();
    getWeatherData();
  }


  Future<Map<String,dynamic>> getWeatherData () async {

         final res=await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=London&appid=$apiKey"));

    final  Map<String,dynamic> data=jsonDecode(res.body);
    //  print(res.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather app",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    
                  });
                },
                icon: const Icon(Icons.refresh_outlined, color: Colors.white))
          ],
          backgroundColor: const Color.fromARGB(255, 38, 38, 36),
          elevation: 10,
        ),
        body: FutureBuilder( 
          future: getWeatherData(),
          builder:(context,snapshot) {

            if(snapshot.connectionState== ConnectionState.waiting){

               return const Center(child:  CircularProgressIndicator( strokeWidth: 5,));
            }
            if(snapshot.hasError){
                
               return Center(child: Text(snapshot.error.toString()));
            }

            final data= snapshot.data!;
            // print(data);
            final ddata=data['list'][0];
           final double currtemp= ddata['main']['temp'];
           
          //  print(currtemp);
            final String currsky= ddata['weather'][0]['main'];
            // print(currsky);
            final int currhumidity= ddata['main']['humidity'];
           final int currpressure= ddata['main']['pressure'];
           final double currwindspeed= ddata['wind']['speed'];
            



            return Padding(
            padding:const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            '$currtemp K',
                            style:const TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                           Icon(
                            currsky=='Rain' || currsky=='Clouds'?Icons.cloud:Icons.sunny,
                            color: Colors.white,
                            size: 60,
                          ),
                          Text(
                            currsky,
                            style:const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Weather forecast",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //  SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [

                //       for(int i=0;i<5;i++)...{

                //        HourForecast(
                //         icon:data['list'][i+1]['weather'][0]['main']=='Clouds' || data['list'][i+1]['weather'][0]['main']=='Rains'? Icons.cloud:Icons.sunny,
                //        time: data['list'][i+1]['dt_txt'].toString().substring(11),
                //        temp:data['list'][i+1]['main']['temp'].toString(),)
                //       },
                      
                  
                //     ],
                //   ),
                // )
                
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: 5,
                    
                    scrollDirection:Axis.horizontal,
                    itemBuilder:(context,index){
                
                     return HourForecast(
                          icon:data['list'][index+1]['weather'][0]['main']=='Clouds' || data['list'][index+1]['weather'][0]['main']=='Rains'? Icons.cloud:Icons.sunny,
                         time: data['list'][index+1]['dt_txt'].toString().substring(11),
                         temp:data['list'][index+1]['main']['temp'].toString());
                    } 
                  
                  
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ExtraInfoCard(icon: Icons.water_drop,para: "Humidity",val: currhumidity.toString()),
                    ExtraInfoCard(icon: Icons.air_sharp,para: "Wind Speed",val: currwindspeed.toString()),
                    ExtraInfoCard(icon: Icons.ramp_right_rounded,para: "Pressure",val:currpressure.toString()),
                 
                  ],
                )
              ],
            ),
          );
          },
        ));
  }
}

class ExtraInfoCard extends StatelessWidget {

  final IconData icon;
  final String para;
  final String val;
  const ExtraInfoCard({super.key,
        required this.icon,
        required this.para,
        required this.val
  });

  @override
  Widget build(BuildContext context) {
    return   Column(
          children: [
            Icon(
              icon,
              size: 60,
            ),
            Text(
              para,
              style:const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              val,
              style:const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
  }
}

class HourForecast extends StatelessWidget {

  final String time;
  final String temp;
  final IconData icon;
  const HourForecast({super.key,
          required this.icon,
          required this.temp,
          required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 120,
      child: Card(
        elevation: 10,
        child: Padding(
          padding:const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style:const  TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Icon(
                icon,
                size: 36,
                color: Colors.white,
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                temp,
                style:const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
