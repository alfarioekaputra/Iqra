import 'package:flutter/material.dart';
import 'package:quran_apps/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BottomNavPage(title: 'Al Quran'),
    );
  }
}

class BottomNavPage extends StatefulWidget {
  BottomNavPage({Key key, this.title}) : super(key:key);

  final String title;
  @override
  _BottomNavPageState createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _selectedTabIndex = 0;

  void _onNavbarTapped(int index){
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = <Widget> [
      Home(),
      Text('Jadwal Sholat')
    ];

    final _bottomNavbarItems = <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(Icons.library_books),
        title: Text('Al Quran'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.access_time),
        title: Text('Jadwal Sholat')
      )
    ];

    final _bottomNavbar = BottomNavigationBar(
      items: _bottomNavbarItems,
      currentIndex: _selectedTabIndex,
      onTap: _onNavbarTapped,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _listPage[_selectedTabIndex],
      ),
      bottomNavigationBar: _bottomNavbar,
    );
  }
}
