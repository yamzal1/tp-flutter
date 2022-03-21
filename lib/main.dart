import 'package:flutter/material.dart';
import 'dart:async';
import 'package:date_util/date_util.dart';

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
  DateTime _date = DateTime(2000, 01, 01); //Date de naisance - onglet 1
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
                    '${age(_date, _time)}',
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
                    '${diff(_date1, _date2)}',
                    //'La différence entre ces deux dates est de  ${diff(_date1, _date2, 1)} ans, ${diff(_date1, _date2, 2)} mois et ${diff(_date1, _date2, 3)} jours',
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

  //Calcule l'écart entre deux dates. La deuxième date peut-être plus petite que la première
  diff(DateTime d1, DateTime d2) {
    if (d1.isAfter(d2)) {
      var jours = d1.day - d2.day;
      var mois = d1.month - d2.month;
      var annees = d1.year - d2.year;

      if (jours.isNegative) {
        mois--;
        var diff = DateUtil().daysInMonth(d2.month, d2.year);
        jours += diff as int;
      }
      if (mois.isNegative) {
        annees--;
        mois += 12;
      }
      return 'La différence entre ces dates est de ${annees} ans, ${mois} mois et ${jours} jours';
    } else {
      var jours = d2.day - d1.day;
      var mois = d2.month - d1.month;
      var annees = d2.year - d1.year;

      if (jours.isNegative) {
        mois--;
        var diff = DateUtil().daysInMonth(d1.month, d1.year);
        jours += diff as int;
      }
      if (mois.isNegative) {
        annees--;
        mois += 12;
      }
      return 'La différence entre ces dates est de ${annees} ans, ${mois} mois et ${jours} jours';
    }
  }

  //Prend en param une date et une heure, renvoie un age exact
  age(DateTime d, TimeOfDay t) {
    var secondes = DateTime.now().second;
    var minutes = DateTime.now().minute - _time.minute;
    var heures = DateTime.now().hour - _time.hour;
    var jours = dateToday.day - _date.day;
    var mois = dateToday.month - _date.month;
    var annees = dateToday.year - _date.year;

    if (minutes.isNegative) {
      heures--;
      minutes += 60;
    }
    if (heures.isNegative) {
      jours--;
      heures += 24;
    }
    if (jours.isNegative) {
      mois--;
      var diff = DateUtil().daysInMonth(d.month, d.year);
      jours += diff as int;
    }
    if (mois.isNegative) {
      annees--;
      mois += 12;
    }

    return 'J\'ai ${annees} ans, ${mois} mois ${jours} jours ${heures} heures, ${minutes} minutes et ${secondes} secondes';
  }
}
