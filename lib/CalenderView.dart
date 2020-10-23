import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
//import 'misc/calendar_views/lib/day_view.dart';
import 'package:calendar_views/day_view.dart';
import 'EventView.dart';

@immutable
class Event {
  Event({
    @required this.startMinuteOfDay,
    @required this.duration,
    @required this.title,
  });

  int startMinuteOfDay;
  int duration;
  String title;
}

List<String> Resources = ["Resource A", "Resource B"];

List<Event> eventsOfDay0 = <Event>[
  new Event(startMinuteOfDay: 0, duration: 240, title: "Midnight Party"),
  new Event(startMinuteOfDay: 6 * 60, duration: 2 * 60, title: "Morning Routine"),
  new Event(startMinuteOfDay: 6 * 60, duration: 60, title: "Eat Breakfast"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Get Dressed"),
  new Event(startMinuteOfDay: 18 * 60, duration: 60, title: "Take Dog For A Walk"),
];

List<Event> eventsOfDay1 = <Event>[
  new Event(startMinuteOfDay: 1 * 60, duration: 60, title: "Sleep Walking"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Drive To Work"),
  new Event(startMinuteOfDay: 8 * 60, duration: 120, title: "A"),
  new Event(startMinuteOfDay: 8 * 60, duration: 120, title: "B"),
  new Event(startMinuteOfDay: 8 * 60, duration: 60, title: "C"),
  new Event(startMinuteOfDay: 8 * 60, duration: 120, title: "D"),
  new Event(startMinuteOfDay: 8 * 60, duration: 60, title: "E"),
  new Event(startMinuteOfDay: 23 * 60, duration: 60, title: "Midnight Snack"),
];

class DayViewExample extends StatefulWidget {
  @override
  State createState() => new _DayViewExampleState();
}

class _DayViewExampleState extends State<DayViewExample> {
  DateTime _day0;
  DateTime _day1;

  TextEditingController subjectController = TextEditingController();
  TextEditingController FromTimeController = TextEditingController();
  TextEditingController ToTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _day0 = new DateTime.now();
    _day1 = _day0.toUtc().add(new Duration(days: 1)).toLocal();
  }

  String _minuteOfDayToHourMinuteString(int minuteOfDay) {
    return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
        ":"
        "${(minuteOfDay % 60).toString().padLeft(2, "0")}";
  }

  List<StartDurationItem> _getEventsOfDay(DateTime day, String str) {
    List<Event> events;
    int resourceID = 0;
    if (day.year == _day0.year && day.month == _day0.month && day.day == _day0.day) {
      events = eventsOfDay0;
      resourceID = 0;
    } else {
      events = eventsOfDay1;
      resourceID = 1;
    }

    return events
        .asMap()
        .entries
        .map(
          (event) => new StartDurationItem(
            startMinuteOfDay: event.value.startMinuteOfDay,
            duration: event.value.duration,
            builder: (context, itemPosition, itemSize) =>
                _eventBuilder(context, itemPosition, itemSize, event.value, event.key, resourceID),
          ),
        )
        .toList();
  }

  showAlertDialog(BuildContext context, int minuteoftheDay, String title, int interval,int index,int resID) {
    String subject = title;
    int fromTime = (minuteoftheDay / 60).round(), toTime = (minuteoftheDay / 60).round() + 1;
    int duration = interval,resourceID=resID;

    FromTimeController.text = (minuteoftheDay / 60).round().toString();
    ToTimeController.text = ((minuteoftheDay / 60).round() + duration ~/ 60).toString();
    subjectController.text = subject;

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
       if(subject!=""){
         if (title != "") {
           eventsOfDay0[index].title = subject;
           eventsOfDay0[index].startMinuteOfDay = fromTime * 60;
           eventsOfDay0[index].duration = (toTime - fromTime) * 60;
         } else
           eventsOfDay0
               .add(new Event(startMinuteOfDay: fromTime * 60, duration: (toTime - fromTime) * 60, title: subject));
         Navigator.of(context).pop();
       }
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Resources[resourceID]),
          TextField(
            controller: subjectController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
            onChanged: (text) {
              subject = text;
            },
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("From : "),
                Container(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: FromTimeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'From',
                    ),
                    onChanged: (text) {
                      fromTime = int.parse(text);
                    },
                  ),
                  width: 100,
                )
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 30),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("To : "),
              Container(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: ToTimeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'To',
                  ),
                  onChanged: (text) {
                    toTime = int.parse(text);
                  },
                ),
                width: 100,
              )
            ],
          )
        ],
      ),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Scheduler"),
      ),
      body: new DayViewEssentials(
        properties: new DayViewProperties(
          days: <DateTime>[
            _day0,
            _day1,
          ],
        ),
        child: new Column(
          children: <Widget>[
            new Container(
              color: Colors.grey[200],
              child: new DayViewDaysHeader(
                headerItemBuilder: _headerItemBuilder,
              ),
            ),
            new Expanded(
              child: new SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: new DayViewSchedule(
                  heightPerMinute: 1.0,
                  components: <ScheduleComponent>[
                    new TimeIndicationComponent.intervalGenerated(
                      generatedTimeIndicatorBuilder: _generatedTimeIndicatorBuilder,
                    ),
                    new SupportLineComponent.intervalGenerated(
                      generatedSupportLineBuilder: _generatedSupportLineBuilder,
                    ),
                    new DaySeparationComponent(
                      generatedDaySeparatorBuilder: _generatedDaySeparatorBuilder,
                    ),
                    new EventViewComponent(
                      getEventsOfDay: _getEventsOfDay,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerItemBuilder(BuildContext context, DateTime day, String str) {

    return new Container(
      color: Colors.grey[300],
      padding: new EdgeInsets.symmetric(vertical: 4.0),
      child: new Column(
        children: <Widget>[
          new Text(
            "${Resources[day.day - new DateTime.now().day]}",
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          //   new Text("${day.day}"),
        ],
      ),
    );
  }

  Positioned _generatedTimeIndicatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Container(
        child: new Center(
          child: new Text(_minuteOfDayToHourMinuteString(minuteOfDay)),
        ),
      ),
    );
  }

  Positioned _generatedSupportLineBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    double itemWidth,
    int minuteOfDay,
  ) {   //print();
    return Positioned(
        top: itemPosition.top,
        left: itemPosition.left,
        width: itemWidth,
        child: GestureDetector(
          onTap: () => {showAlertDialog(context, minuteOfDay, "", 60, 0,0)},
          child: Container(
            width: .1,

            padding: EdgeInsets.only(bottom: 60),
            color: Colors.green[100],

            child: new Container(
              height: 0.7,
              color: Colors.blue[700],
            ),
          ),
        ));
  }

  Positioned _generatedDaySeparatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int daySeparatorNumber,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Center(
        child: new Container(
          width: 0.7,
          color: Colors.green,
        ),
      ),
    );
  }

  Positioned _eventBuilder(
      BuildContext context, ItemPosition itemPosition, ItemSize itemSize, Event event, int index, int resID) {
    double _x = itemPosition.top, _y = itemPosition.left;

    return new Positioned(
      top: _x,
      left: _y,
      width: itemSize.width,
      height: itemSize.height,
      child: Draggable(
        child: GestureDetector(
            onLongPress: () {
              showAlertDialog(context, event.startMinuteOfDay, event.title, event.duration, index,resID);
            },
            child: Container(
                padding: EdgeInsets.all(3),
                color: Colors.red[200],
                margin: EdgeInsets.all(1),
                child: Text(("${event.title}")))),
        feedback: FlutterLogo(size: 30),
        childWhenDragging: Container(),
        onDragEnd: (dragDetails) {
          setState(() {

            _x = dragDetails.offset.dx;
            // if applicable, don't forget offsets like app/status bar
            _y = dragDetails.offset.dy;

            /* double yOffest = 0;
            yOffest = 0;

            print(dragDetails.offset.dy.toString() + "drag");
            print(dragDetails.offset.dy.round().toString() + "rounded");*/
            print((itemPosition.top - dragDetails.offset.dy.round()).toString() + "itemPos");

            print(round((dragDetails.offset.dy).round()).toString() + "rounded to nearest");

            if (dragDetails.velocity.pixelsPerSecond.dy < 0) {
              print(event.startMinuteOfDay.toString() + "before UP");
              if (event.startMinuteOfDay + round((dragDetails.offset.dy).round()) > 0) {
                event.startMinuteOfDay = event.startMinuteOfDay - round((dragDetails.offset.dy).round());
                print(event.startMinuteOfDay.toString() + "after");
              } else
                print("NOP");
            } else {
              print(event.startMinuteOfDay.toString() + "before DOWN");
              if (event.startMinuteOfDay + round((dragDetails.offset.dy).round()) < 1381) {
                event.startMinuteOfDay = event.startMinuteOfDay + round((dragDetails.offset.dy).round());
                print(event.startMinuteOfDay.toString() + "after");
              }
            }
          });
        },
      ),
    );
  }
}

int round(int tnum) {
  int num = (tnum / 6).round();
  int temp = num % 60;

  print(num.toString() + "is drag");
  print(temp.toString() + "is modulus");
  print((num - temp).toString() + "is offset");
  if (temp < 15)
    return (num - temp);
  else
    return num + 60 - temp;
}
