import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../weather_provider.dart';
import '../theme_provider.dart';
import '../weather_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    provider.loadLastCityWeather().then((_) {
      setState(() {
        _searchHistory = provider.history;
      });
    });
  }

  void _searchCity(String city) {
    if (city.isEmpty) return;
    Provider.of<WeatherProvider>(context, listen: false).fetchWeather(city);
    if (!_searchHistory.contains(city)) {
      setState(() {
        _searchHistory.insert(0, city);
        if (_searchHistory.length > 5) {
          _searchHistory = _searchHistory.sublist(0, 5);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("🌤️ Weather Wizard"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 113, 184),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.cloud, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text('Weather Wizard',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Toggle Dark/Light Mode'),
              onTap: () {
                themeProvider.toggleTheme();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Weather Wizard',
                  applicationVersion: '1.0.0',
                  children: const [Text('Made by Sanskar Koserwal')],
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownSearch<String>(
              items: _searchHistory,
              selectedItem: null,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Enter city',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              popupProps: const PopupProps.menu(showSearchBox: true),
              onChanged: (city) {
                if (city != null) {
                  _controller.text = city;
                  _searchCity(city);
                }
              },
              dropdownBuilder: (context, selectedItem) {
                return TextField(
                  controller: _controller,
                  onSubmitted: (value) => _searchCity(value),
                  decoration: InputDecoration(
                    hintText: 'Search City',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _searchCity(_controller.text),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            if (_searchHistory.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Recent Searches:",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _searchHistory
                    .map((city) => ActionChip(
                          label: Text(city),
                          onPressed: () {
                            _controller.text = city;
                            _searchCity(city);
                          },
                        ))
                    .toList(),
              ).animate().fade(duration: 600.ms),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: weatherProvider.isLoading
                    ? const CircularProgressIndicator()
                        .animate()
                        .scale(duration: 500.ms)
                    : weatherProvider.error != null
                        ? Text(weatherProvider.error!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 18))
                        : weatherProvider.weather != null
                            ? WeatherDisplay(weather: weatherProvider.weather!)
                                .animate()
                                .slideY(duration: 600.ms)
                            : const Text("Search for a city 🌍")
                                .animate()
                                .fade(duration: 800.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
