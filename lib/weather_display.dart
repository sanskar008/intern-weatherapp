import 'package:flutter/material.dart';
import '../weather_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WeatherDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Add this to the build method of WeatherDisplay
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weather.city,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Image.network(
                    "https://openweathermap.org/img/wn/${weather.icon}@2x.png")
                .animate()
                .fade(duration: 500.ms)
                .scale(delay: 200.ms),
            Text(
              "${weather.temperature}°C - ${weather.description}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  const Icon(Icons.water_drop_outlined),
                  Text("Humidity: ${weather.humidity}%"),
                ]),
                Column(children: [
                  const Icon(Icons.air),
                  Text("Wind: ${weather.windSpeed} m/s"),
                ]),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(curve: Curves.easeInOut);
  }
}
