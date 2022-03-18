import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Picker Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.light()),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Les dates par défaut quand l'utilisateur n'a rien saisi
  DateTime _date = DateTime(2000, 01, 01); //Date de naisance
  DateTime _date1 = DateTime(1995, 01, 01); //onglet 2
  DateTime _date2 = DateTime(2005, 01, 01); //onglet 2
  TimeOfDay _time = TimeOfDay(hour: 00, minute: 00); //heure de naissance
  late String _timeString;

  //Se met à jour chaque seconde pour afficher l'heure actuelle
  @override
  void initState() {
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

//Permet de choisir sa date de naissance
  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(), //La date ne peut pas être dans le futur
      helpText: 'Votre date de naissance',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  //Permet de choisir son heure de naissance
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00),
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  //Ces deux méthodes servent a choisir les deux dates dans l'onglet 2
  void _dateC1() async {
    final DateTime? newDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDate: _date1,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2100, 12),
      helpText: 'Date 1',
    );
    if (newDate != null) {
      setState(() {
        _date1 = newDate;
      });
    }
  }

  void _dateC2() async {
    final DateTime? newDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDate: _date2,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2100, 12),
      helpText: 'Date 1',
    );
    if (newDate != null) {
      setState(() {
        _date2 = newDate;
      });
    }
  }

//La date d'aujourd'hui
  DateTime dateToday =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Exercice 2'),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff5808e5),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Calculer votre age', icon: Icon(Icons.cake)),
              Tab(
                  text: 'Combien de temps entre deux dates',
                  icon: Icon(Icons.calculate)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //ONGLET 1
            Column(
              children: [
                Center(
                  child: TextButton(
                    child: Text('Date de naissance'),
                    onPressed: _selectDate,
                  ),
                ),
                Center(
                  child: TextButton(
                    child: Text('Heure de naissance'),
                    onPressed: _selectTime,
                  ),
                ),
                Center(
                  child: Text(
                    'Je suis né le ${_date.toString().substring(0, 10)} à ${_time.hour} h ${_time.minute}',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Center(
                  child: Text(
                    'Nous sommes le ${dateToday.toString().substring(0, 10)}, il est $_timeString',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Center(
                  child: Text(
                    'J\'ai ${dateToday.year - _date.year} ans, ${dateToday.month - _date.month} mois ${dateToday.day - _date.day} jours ${DateTime.now().hour - _time.hour} heures, ${DateTime.now().minute - _time.minute} minutes et ${DateTime.now().second} secondes',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),

            //ONGLET 2
            Column(
              children: [
                Center(
                  child: TextButton(
                    child: Text('Date1'),
                    onPressed: _dateC1,
                  ),
                ),
                Center(
                  child: TextButton(
                    child: Text('Date2'),
                    onPressed: _dateC2,
                  ),
                ),
                Center(
                  child: Text(
                    'Date 1 : ${_date1.toString().substring(0, 10)} Date 2 : ${_date2.toString().substring(0, 10)}',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Center(
                  child: Text(
                    'La différence entre ces deux dates est de  ${diff(_date1, _date2, 1)} ans, ${diff(_date1, _date2, 2)} mois et ${diff(_date1, _date2, 3)} jours',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  void _getCurrentTime() {
    setState(() {
      _timeString =
          "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    });
  }

  //Calcule la difference entre deux dates.
  //TODO : ecrire une meilleure fonction
  diff(DateTime d1, DateTime d2, int i) {
    switch (i) {
      case 1:
        if (d1.isAfter(d2)) {
          return d1.year - d2.year;
        } else {
          return d2.year - d1.year;
        }
      case 2:
        if (d1.isAfter(d2)) {
          return d1.month - d2.month;
        } else {
          return d2.month - d1.month;
        }
      case 3:
        if (d1.isAfter(d2)) {
          return d1.day - d2.day;
        } else {
          return d2.day - d1.day;
        }
      default:
        return 0;
    }
  }
}
