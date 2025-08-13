// REFACTORED GROUP CHAT WITH TIMESTAMPS AND ALIGNMENT + MAP LOCATION PICKER + RADIUS FILTER + SQLITE PERSISTENCE + SWIPE CARDS + USER PROFILE SETUP + PROFILE PERSISTENCE
import 'package:flutter/material.dart'hide Context;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_lib;
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.initDB();
  runApp(const LifeAvenueApp());
}

class DBHelper {
  static final DBHelper instance = DBHelper._();
  DBHelper._();

  Database? _database;

  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final fullPath = path_lib.join(dbPath, 'events.db');
    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            dateTime TEXT,
            latitude REAL,
            longitude REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE profile(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            tag TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertEvent(Event event) async {
    final database = await db;
    await database.insert('events', {
      'title': event.title,
      'dateTime': event.dateTime.toIso8601String(),
      'latitude': event.latitude,
      'longitude': event.longitude,
    });
  }

  Future<List<Event>> getEvents() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query('events');
    return List.generate(maps.length, (i) {
      return Event(
        title: maps[i]['title'] as String,
        dateTime: DateTime.parse(maps[i]['dateTime'] as String),
        latitude: maps[i]['latitude'] as double,
        longitude: maps[i]['longitude'] as double,
      );
    });
  }

  Future<void> saveProfile(String name, String tag, String image) async {
    final database = await db;
    await database.delete('profile');
    await database.insert('profile', {
      'name': name,
      'tag': tag,
      'image': image,
    });
  }

  Future<Map<String, dynamic>?> loadProfile() async {
    final database = await db;
    final result = await database.query('profile');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}

class LifeAvenueApp extends StatelessWidget {
  const LifeAvenueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Avenue',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 208, 58, 44),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 208, 58, 44),
          secondary: const Color.fromARGB(255, 207, 57, 43),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 208, 58, 44),
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 208, 58, 44),
          foregroundColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 208, 58, 44),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 208, 58, 44),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/pick_location': (context) => const LocationPickerScreen(),
        '/discover': (context) => const DiscoverScreen(),
        '/eventDetail': (context) => const EventDetailScreen(),
        '/groupChat': (context) => const GroupChatScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/membership': (context) => const MembershipScreen(),
        '/checkin': (context) => const CheckInScreen(),
        '/myProfile': (context) => const MyProfileScreen(),
        '/dashboard': (context) => const UserDashboardScreen(),
        '/myEvents': (context) => const MyEventsScreen(),
        '/myRsvps': (context) => const MyRsvpsScreen(),
        '/register': (context) => const RegistrationScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showMainLogo = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _showMainLogo = true);
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFD03A2C), // Rojo de la app
    body: Center(
      child: _showMainLogo
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Imagen1.png',  width: 400, height: 400),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFD03A2C), // texto rojo
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/welcome'),
                  child: const Text('Iniciar', style: TextStyle(fontSize: 18)),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 300),
                const SizedBox(height: 40),
              ],
            ),
    ),
  );
}
}

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: const Center(child: Text('Formulario de registro próximamente')),
    );
  }
}

class MyRsvpsScreen extends StatelessWidget {
  const MyRsvpsScreen({super.key});

  Future<List<Event>> _loadRsvpEvents() async {
    final allEvents = await DBHelper.instance.getEvents();
    return allEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis RSVP')),
      body: FutureBuilder<List<Event>>(
        future: _loadRsvpEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar eventos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes eventos RSVP'));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                leading: const Icon(Icons.event_available),
                title: Text(event.title),
                subtitle: Text(
                  '${event.dateTime.day}/${event.dateTime.month}/${event.dateTime.year} - (${event.latitude.toStringAsFixed(2)}, ${event.longitude.toStringAsFixed(2)})',
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}


class Event {
  final String title;
  final DateTime dateTime;
  final double latitude;
  final double longitude;

  Event({
    required this.title,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  });
}
class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  Map<String, dynamic>? _profile;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await DBHelper.instance.loadProfile();
    final events = await DBHelper.instance.getEvents();
    setState(() {
      _profile = profile;
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Dashboard')),
      body: _profile == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_profile!['image'] ?? ''),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _profile!['name'] ?? 'Sin nombre',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _profile!['tag'] ?? '',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 40),
                const Text('Mis eventos creados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                if (_events.isEmpty)
                  const Text('No hay eventos.')
                else
                  ..._events.map((e) => ListTile(
                        title: Text(e.title),
                        subtitle: Text('${DateFormat.yMMMd().format(e.dateTime)} • ${DateFormat.jm().format(e.dateTime)}'),
                        trailing: Text('(${e.latitude.toStringAsFixed(2)}, ${e.longitude.toStringAsFixed(2)})'),
                      ))
              ],
            ),
    );
  }
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  String _selectedImage = 'https://via.placeholder.com/150';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await DBHelper.instance.loadProfile();
    if (data != null) {
      setState(() {
        _nameController.text = data['name'] as String;
        _tagController.text = data['tag'] as String;
        _selectedImage = data['image'] as String? ?? _selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_selectedImage),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() => _selectedImage = 'https://via.placeholder.com/150?text=New');
              },
              child: const Text('Change Image'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(labelText: 'Your Interest (e.g., Music)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final tag = _tagController.text;
                if (name.isNotEmpty && tag.isNotEmpty) {
                  await DBHelper.instance.saveProfile(name, tag, _selectedImage);
                  if (!mounted) return;
                  Navigator.pop(context, {
                    'name': name,
                    'tag': tag,
                    'image': _selectedImage,
                  });
                }
              },
              child: const Text('Save Profile'),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _user = {
    'name': 'Unknown',
    'tag': '',
    'image': 'https://via.placeholder.com/150',
  };

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await DBHelper.instance.loadProfile();
    if (data != null) {
      setState(() => _user = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_user['name'] as String),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/myProfile');
              if (result is Map<String, dynamic>) {
                setState(() => _user = result);
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            backgroundImage: NetworkImage(_user['image'] as String),
            radius: 50,
          ),
          const SizedBox(height: 12),
          Text(
            _user['name'] as String,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _user['tag'] as String,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.dashboard),
            label: const Text('Mi Dashboard'),
            onPressed: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.stars),
            label: const Text('Upgrade Membership'),
            onPressed: () {
              Navigator.pushNamed(context, '/membership');
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.event),
            label: const Text('Mis Eventos'),
            onPressed: () {
              Navigator.pushNamed(context, '/myEvents');
            },
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _quickAction(Icons.calendar_today, 'Calendar', () {
                  Navigator.pushNamed(context, '/calendar');
                }),
                _quickAction(Icons.check_circle, 'Check-in', () {
                  Navigator.pushNamed(context, '/checkin');
                }),
                _quickAction(Icons.group, 'Group', () {
                  Navigator.pushNamed(context, '/groupChat');
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30, color: Colors.indigo),
          onPressed: onTap,
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Eventos')),
      body: FutureBuilder<List<Event>>(
        future: DBHelper.instance.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar eventos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes eventos registrados'));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                leading: const Icon(Icons.event),
                title: Text(event.title),
                subtitle: Text(
                  '${event.dateTime.day}/${event.dateTime.month}/${event.dateTime.year} - ${event.dateTime.hour}:${event.dateTime.minute.toString().padLeft(2, '0')}\nUbicación: ${event.latitude.toStringAsFixed(3)}, ${event.longitude.toStringAsFixed(3)}'
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> people = [
    {'name': 'Ana', 'tag': 'Fitness', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Luis', 'tag': 'Tech', 'image': 'https://via.placeholder.com/150'},
  ];

  final List<Map<String, String>> events = [
    {'title': 'Yoga in the Park', 'tag': 'Fitness', 'image': 'https://via.placeholder.com/150'},
    {'title': 'Startup Meetup', 'tag': 'Entrepreneurship', 'image': 'https://via.placeholder.com/150'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'People'),
            Tab(text: 'Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSwiper(people, true),
          _buildSwiper(events, false),
        ],
      ),
    );
  }
  
  Widget _buildSwiper(List<Map<String, String>> items, bool isPerson) {
  return CardSwiper(
    cardsCount: items.length,
    cardBuilder: (context, index) {
      final item = items[index];
      return GestureDetector(
        onTap: () {
          if (isPerson) {
            Navigator.pushNamed(context, '/profile', arguments: item);
          } else {
            Navigator.pushNamed(context, '/eventDetail', arguments: item);
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(item['image'] ?? 'https://via.placeholder.com/150'),
                radius: 60,
              ),
              const SizedBox(height: 20),
              Text(
                item['name'] ?? item['title'] ?? '',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                item['tag'] ?? '',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              )
            ],
          ),
        ),
      );
    },
  );
}
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> _tags = [
    'Fitness',
    'Poetry',
    'Entrepreneurship',
    'Music',
    'Tech',
    'Travel'
  ];

  final Set<String> _selectedTags = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your interests:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _tags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      isSelected 
                          ? _selectedTags.remove(tag)
                          : _selectedTags.add(tag);
                    });
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _selectedTags.isEmpty
                    ? null
                    : () {
                        Navigator.pushNamed(context, '/discover');
                      },
                child: const Text('Continue to Discover'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    return Scaffold(
      appBar: AppBar(title: Text(event?['title'] ?? 'Event Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(event?['image'] ?? 'https://via.placeholder.com/150'),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(
              event?['title'] ?? 'Unknown Event',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              event?['tag'] ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/groupChat');
                  },
                  child: const Text('RSVP'),
                ),
                OutlinedButton(
                  onPressed: () {}, 
                  child: const Text('Maybe')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final List<Map<String, String>> _messages = [
    {'sender': 'Ana', 'text': 'Excited for the event!', 'time': '10:30 AM'},
    {'sender': 'Luis', 'text': 'Me too! What time will you arrive?', 'time': '10:32 AM'},
    {'sender': 'You', 'text': 'I plan to be there by 5 PM.', 'time': '10:35 AM'},
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({
          'sender': 'You',
          'text': text,
          'time': DateFormat.jm().format(DateTime.now()),
        });
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Chat')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Icebreaker: Share your favorite event experience!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('No messages yet.'))
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['sender'] == 'You';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.indigo[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(msg['text']!, style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(
                                msg['time'] ?? '',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  double _radiusKm = 5.0;
  Position? _userPosition;
  final Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _determinePosition();
  }

  Future<void> _loadEvents() async {
    final loadedEvents = await DBHelper.instance.getEvents();
    setState(() {
      for (final event in loadedEvents) {
        final date = DateTime(event.dateTime.year, event.dateTime.month, event.dateTime.day);
        if (_events[date] != null) {
          _events[date]!.add(event);
        } else {
          _events[date] = [event];
        }
      }
    });
  }

  Future<void> _determinePosition() async {
    try {
      final hasPermission = await Geolocator.requestPermission();
      if (hasPermission == LocationPermission.denied) return;
      final position = await Geolocator.getCurrentPosition();
      setState(() => _userPosition = position);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get current location')),
      );
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    final baseEvents = _events[DateTime(day.year, day.month, day.day)] ?? [];
    if (_userPosition == null) return baseEvents;
    return baseEvents.where((event) {
      final distance = Geolocator.distanceBetween(
        _userPosition!.latitude,
        _userPosition!.longitude,
        event.latitude,
        event.longitude,
      );
      return distance <= _radiusKm * 1000;
    }).toList();
  }

  Future<void> _addEvent(Event event) async {
    final selectedDate = DateTime(event.dateTime.year, event.dateTime.month, event.dateTime.day);
    setState(() {
      if (_events[selectedDate] != null) {
        _events[selectedDate]!.add(event);
      } else {
        _events[selectedDate] = [event];
      }
    });
    await DBHelper.instance.insertEvent(event);
  }

  void _showAddEventDialog() {
    final _titleController = TextEditingController();
    LatLng? pickedCoords;
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event title'),
            ),
            TextButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/pick_location');
                if (result != null && result is String) {
                  final parts = result.split(',');
                  pickedCoords = LatLng(double.parse(parts[0]), double.parse(parts[1]));
                }
              },
              child: const Text('Pick Location'),
            ),
            TextButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null) selectedTime = picked;
              },
              child: const Text('Select Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty && _selectedDay != null && pickedCoords != null) {
                final fullDate = DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                _addEvent(Event(
                  title: _titleController.text,
                  dateTime: fullDate,
                  latitude: pickedCoords!.latitude,
                  longitude: pickedCoords!.longitude,
                ));
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () async => await _determinePosition(),
            tooltip: 'Update Location',
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.indigoAccent, shape: BoxShape.circle),
            ),
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Radius: ${_radiusKm.toStringAsFixed(1)} km'),
                Slider(
                  value: _radiusKm,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: '${_radiusKm.round()} km',
                  onChanged: (value) => setState(() => _radiusKm = value),
                ),
              ],
            ),
          ),
          ..._getEventsForDay(_selectedDay ?? _focusedDay).map(
            (event) => ListTile(
              key: ValueKey(event.dateTime),
              title: Text(event.title),
              subtitle: Text('${DateFormat.jm().format(event.dateTime)} @ (${event.latitude.toStringAsFixed(3)}, ${event.longitude.toStringAsFixed(3)})'),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedDay == null ? null : _showAddEventDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _pickedLocation = const LatLng(4.7110, -74.0721); // Bogotá por defecto

  void _onMapTap(LatLng pos) {
    setState(() => _pickedLocation = pos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(4.7110, -74.0721), zoom: 14),
        onMapCreated: (controller) => _mapController = controller,
        onTap: _onMapTap,
        markers: {
          Marker(
            markerId: const MarkerId('picked-location'),
            position: _pickedLocation,
          )
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.check),
        label: const Text('Confirm'),
        onPressed: () => Navigator.pop(context, '${_pickedLocation.latitude},${_pickedLocation.longitude}'),
      ),
    );
  }
}

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upgrade Membership')),
      body: const Center(child: Text('Tier Benefits + Pricing')),
    );
  }
}

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check In')),
      body: const Center(child: Text('Location Verification UI')),
    );
  }
}