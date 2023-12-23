import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/provider/locationprovider.dart';
import 'package:weather/provider/weatherservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<LocationProvider>(context, listen: false).determinePosition();
    // Provider.of<WeatherServiceProvider>(context, listen: false).fetchWeatherDataByCity("dubai");
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentPosition != null) {
        var lat = locationProvider.currentPosition!.latitude;
        var lon = locationProvider.currentPosition!.longitude;

        //var city = locationProvider.currentLocationName!.locality;

        Provider.of<WeatherServiceProvider>(context, listen: false)
            .fetchWeatherDataByCity(lat.toString(), lon.toString());
      }
    });
    super.initState();
  }

  bool _clicked = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //final locationprovider = Provider.of<LocationProvider>(context);
    final weatherprovider = Provider.of<WeatherServiceProvider>(context);
    int sunriseTimestamp = weatherprovider.weather?.sys?.sunrise ?? 0; // Replace 0 with a default timestamp if needed
    int sunsetTimestamp = weatherprovider.weather?.sys?.sunset ?? 0; // Replace 0 with a default timestamp if needed

// Convert the timestamp to a DateTime object
    DateTime sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

// Format the sunrise time as a string
    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Container(
        padding:
            const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("assets/img/clouds.jpg"))),
        child: Stack(
          children: [
            _clicked == true
                ? Positioned(
                    top: 55,
                    left: 20,
                    right: 20,
                    child: SizedBox(
                      height: 40,
                      //color: Colors.red,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: 50,
              child: Consumer<LocationProvider>(
                  builder: (context, locationprovider, child) {
                var city;
                if (locationprovider.currentLocationName != null) {
                  city = locationprovider.currentLocationName!.locality;
                } else {
                  city = "Unknown Location";
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              city,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _clicked = !_clicked;
                          });
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 30,
                        ))
                  ],
                );
              }),
            ),
            Align(
                alignment: const Alignment(0, -0.7),
                child: Image.asset("assets/img/clouds.png")),
            Align(
              alignment: const Alignment(0, 0),
              child: SizedBox(
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${weatherprovider.weather!.main!.temp?.toStringAsFixed(0)}\u00B0C",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                    Text(
                      weatherprovider.weather!.weather![0].main.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 20),
                    ),
                    Text(
                      weatherprovider.weather!.name.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 25),
                    ),
                   
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.75),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.4)),
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/temperature-high.png",
                              height: 50,
                            ),
                             Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Temp Max",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "${weatherprovider.weather!.main!.tempMax!.toStringAsFixed(0)}\u00B0C",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/temperature-low.png",
                              height: 50,
                            ),
                             Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Temp min",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "${weatherprovider.weather!.main!.tempMin!.toStringAsFixed(0)}\u00B0C",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/sun.png",
                              height: 50,
                            ),
                             Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sun Rise",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  formattedSunrise,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/moon.png",
                              height: 50,
                            ),
                             Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sun Set",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  formattedSunset,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
