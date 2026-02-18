import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/features/authentication/models/user.dart';
import 'package:production/src/features/authentication/screens/more_options.dart';
import 'package:production/src/features/employees/screens/empList.dart';
import 'package:production/src/features/machines/screens/machineList.dart';
import 'package:production/src/features/shiftProgram/screens/newShiftForm.dart';


import '../../production/screens/productionView.dart';

import '../../shiftPlanView/screens/shiftPlanToday.dart';
import '../controllers/login_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  var user = User(id: "", name: "name", role: "role");

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BottomNavigationBarExample());
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  final loginController = Get.put(LoginController());

  late User user = loginController.user.value;
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static final List<Widget> _widgetOptions = <Widget>[
   EmpListScreen(),
    MachineListScreen(),
    ViewProduction(),
    TodayShiftPage (),
    MoreOptionsPage(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.run_circle_sharp),
            label: 'Running Orders',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending Orders',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Production',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
            backgroundColor: Colors.grey,
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
