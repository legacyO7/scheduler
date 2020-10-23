import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:calendar_views/day_view.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

@immutable
class Event {
  Event({
    this.startMinuteOfDay,
    this.duration,
    this.boCompleted = false,
    @required this.title,
  });

  int startMinuteOfDay;
  int duration;
  bool boCompleted;
  String title;
}

List<Event> eventsOfDay0 = <Event>[
  new Event(startMinuteOfDay: 0, duration: 60, title: "Midnight Party", boCompleted: true),
  new Event(startMinuteOfDay: 6 * 60, duration: 2 * 60, title: "Morning Routine"),
  new Event(startMinuteOfDay: 6 * 60, duration: 60, title: "Eat Breakfast"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Get Dressed"),
  new Event(startMinuteOfDay: 18 * 60, duration: 60, title: "Take Dog For A Walk"),
];
List<String> Resources = ["Resource A", "Resource B"];
List<Event> eventsOfDay1 = <Event>[
  new Event(startMinuteOfDay: 1 * 60, duration: 90, title: "Sleep Walking"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Drive To Work"),
  new Event(startMinuteOfDay: 8 * 60, duration: 20, title: "A"),
  new Event(startMinuteOfDay: 8 * 60, duration: 30, title: "B"),
  new Event(startMinuteOfDay: 8 * 60, duration: 60, title: "C"),
  new Event(startMinuteOfDay: 8 * 60 + 10, duration: 20, title: "D"),
  new Event(startMinuteOfDay: 8 * 60 + 30, duration: 30, title: "E"),
  new Event(startMinuteOfDay: 23 * 60, duration: 60, title: "Midnight Snack"),
];

class DayViewExample extends StatefulWidget {
  @override
  State createState() => new _DayViewExampleState();
}

class _DayViewExampleState extends State<DayViewExample> {
  DateTime _day0;
  DateTime _day1;
  DateTime startTime;
  List<DateTime> dayList;
  List<String> userIds;
  ScrollController _mycontroller1 = new ScrollController(); // make seperate controllers
  ScrollController _mycontroller2 = new ScrollController(); // for each scrollables
  ScrollController _mycontroller3 = new ScrollController(); // for each scrollables
  SyncScrollController _syncScroller;

  TextEditingController subjectController = TextEditingController();
  TextEditingController FromTimeController = TextEditingController();
  TextEditingController ToTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncScroller = new SyncScrollController([_mycontroller1, _mycontroller2]);

    _day0 = new DateTime.now();
    _day1 = _day0.toUtc().add(new Duration(days: 1)).toLocal();
    dayList = [_day0, _day1, _day0, _day0];
    userIds = ["Resource A", "Resource B", "Resource C", "Resource D"];
    startTime = DateTime.now();
  }

  void dispose() {
    _mycontroller1.dispose();
    _mycontroller2.dispose();
    _mycontroller3.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context, int minuteoftheDay, String title, int interval, int index, String resID) {
    String subject = title;
    int fromTime = (minuteoftheDay / 60).round(), toTime = (minuteoftheDay / 60).round() + 1;
    int duration = interval;

    FromTimeController.text = (minuteoftheDay / 60).round().toString();
    ToTimeController.text = ((minuteoftheDay / 60).round() + duration ~/ 60).toString();
    subjectController.text = subject;

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        if (subject != "") {
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
          Text(resID),
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

  String _minuteOfDayToHourMinuteString(int minuteOfDay) {
    return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
        ":"
        "${(minuteOfDay % 60).toString().padLeft(2, "0")}";
  }

  String _minuteOfDayToHourMinuteAmPmString(int minuteOfDay) {
    return "${((minuteOfDay < 60) ? (minuteOfDay ~/ 60 + 12) : (minuteOfDay <= 60 * 12) ? (minuteOfDay ~/ 60) : (minuteOfDay ~/ 60 - 12)).toString()}"
        "${(minuteOfDay < 60 * 12) ? " AM" : (minuteOfDay == 60 * 24) ? " AM" : " PM"}";
  }

  List<StartDurationItem> _getEventsOfDay(DateTime day, String str) {
    List<Event> events;
    if (day.year == _day0.year && day.month == _day0.month && day.day == _day0.day) {
      events = eventsOfDay0;
    } else {
      events = eventsOfDay1;
    }

    return events
        .asMap()
        .entries
        .map(
          (event) => new StartDurationItem(
            startMinuteOfDay: event.value.startMinuteOfDay,
            duration: event.value.duration,
            builder: (context, itemPosition, itemSize) =>
                _eventBuilder(context, itemPosition, itemSize, event.value, event.key, str),
          ),
        )
        .toList();
  }

  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    //print("tap down " + x.toString() + ", " + y.toString());
    // print("Vertical scroll offset = ${_mycontroller1.offset}" );
    // double minutes = (y + _mycontroller1.offset - 184) / 1.5;
    // print("Minutes of day = $minutes");
    print("Event Day index = ${((x + _mycontroller3.offset - 64) / 140 % userIds.length).round()}");
  }

  _onTapUp(TapUpDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("tap up " + x.toString() + ", " + y.toString());
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context, initialDate: startTime, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    DateTime pickedTime = picked.add(Duration(hours: startTime.hour, minutes: startTime.minute));
    if (picked != null && pickedTime != startTime)
      setState(() {
        startTime = pickedTime;
      });
  }

  _getHeight() {
//int maxLength = [anytimeEventsOfDay0.length, anytimeEventsOfDay1.length].reduce(max);
    return 72.0;
  }

  AppBar appBar = AppBar(
    title: new Text("Scheduler"),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar,
      body: new DayViewEssentials(
          //widths: DayViewWidths(separationAreaWidth: 10,),
          properties: new DayViewProperties(days: dayList, userIds: userIds),
          child: Row(
            children: <Widget>[
              NotificationListener<ScrollNotification>(
                child: SizedBox(
                  width: 60.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30.0, child: Container()),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _mycontroller2,
                          child: new DayViewSchedule(
                              topExtensionHeight: 1,
                              heightPerMinute: 1,
                              components: <ScheduleComponent>[
                                new TimeIndicationComponent.intervalGenerated(
                                  generatedTimeIndicatorBuilder: _generatedTimeIndicatorBuilder,
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
                onNotification: (ScrollNotification scrollInfo) {
                  _syncScroller.processNotification(scrollInfo, _mycontroller2);
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _mycontroller3,
                    child: Column(
                      children: <Widget>[
                        //Flex(direction: Axis.vertical, children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.grey[200],
                            child: new DayViewDaysHeader(
                              headerItemBuilder: _headerItemBuilder,
                            ),
                          ),
                        ),
                        NotificationListener<ScrollNotification>(
                            child: Expanded(
                              flex: 10,
                              child: SingleChildScrollView(
                                controller: _mycontroller1,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () => print("tapped"),
                                  onTapDown: (TapDownDetails details) => _onTapDown(details),
                                  //  onTapUp: (TapUpDetails details) => _onTapUp(details),
                                  child: DayViewSchedule(
                                    heightPerMinute: 1,
                                    topExtensionHeight: 0,
                                    components: <ScheduleComponent>[
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
                            ),
                            onNotification: (ScrollNotification scrollInfo) {
                              _syncScroller.processNotification(scrollInfo, _mycontroller1);
                            })
                      ],
                    )),
              ),
            ],
          )),
    );
  }

  Widget _getUserOfDay(String userId) {
    Widget userName;
    userName = Text(
      userId,
      maxLines: 1,
      overflow: TextOverflow.clip,
    );
    return userName;
  }

  Widget _headerItemBuilder(BuildContext context, DateTime day, String userId) {
    return new Container(
      color: Colors.grey[300],
      padding: new EdgeInsets.symmetric(vertical: 4.0),
      child: Column(children: <Widget>[
        Flexible(
          flex: 1,
          child: _getUserOfDay(userId),
        ),
        // Flexible(flex:3, child:SingleChildScrollView(child:_getListOfAnytimeEvents(day),))
      ]),
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
      width: itemSize.width + 60,
      height: itemSize.height,
      child: new Container(
        child: new Center(
          child: new Text(
            _minuteOfDayToHourMinuteString(minuteOfDay),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Positioned _generatedSupportLineBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    double itemWidth,
    int minuteOfDay,
  ) {
    //print();
    return Positioned(
        top: itemPosition.top,
        left: itemPosition.left,
        width: itemWidth * 2,
        child: GestureDetector(
          onTap: () => {showAlertDialog(context, minuteOfDay, "", 60, 0, "0")},
          child: Container(
            padding: EdgeInsets.only(bottom: 60),
            color: Colors.green[100],
            child: new Container(
              height: 0.7,
              color: (minuteOfDay % 60 == 0) ? Colors.grey[700] : Colors.grey[400],
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
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned _eventBuilder(
      BuildContext context, ItemPosition itemPosition, ItemSize itemSize, Event event, int index, String resID) {
    double _x = itemPosition.top, _y = itemPosition.left;

    return new Positioned(
      top: _x,
      left: _y,
      width: itemSize.width,
      height: itemSize.height,
      child: GestureDetector(
          onLongPress: () {
            showAlertDialog(context, event.startMinuteOfDay, event.title, event.duration, index, resID);
          },
          child: Container(
            child: Draggable(
              child: Container(
                  padding: EdgeInsets.all(3),
                  color: Colors.red[200],
                  margin: EdgeInsets.all(1),
                  child: Text(("${event.title}"))),
              feedback: Container(
                height: itemSize.height,
                width: itemSize.width,
                padding: EdgeInsets.all(3),
                color: Colors.red[200],
                margin: EdgeInsets.all(1),
              ),
              childWhenDragging: Container(),
              onDragEnd: (dragDetails) {
                setState(() {
                  _x = dragDetails.offset.dx;
                  //   _y = dragDetails.offset.dy+appBar.preferredSize.height+MediaQuery.of(context).padding.top;
                  _y = dragDetails.offset.dy;

                  if (dragDetails.velocity.pixelsPerSecond.dy < 0) {
                    print("UP");
                    if (event.startMinuteOfDay - round((_y).round()) > 0) {
                      event.startMinuteOfDay = event.startMinuteOfDay - round((_y).round());
                      horizontalAction(event, dragDetails, index);
                    } else
                      print("NOP");
                  } else {
                    print("Down");
                    if (event.startMinuteOfDay + round((_y).round()) < 1381) {
                      event.startMinuteOfDay = event.startMinuteOfDay + round((_y).round());
                      //  print(event.startMinuteOfDay.toString() + "after");
                      horizontalAction(event, dragDetails, index);
                    }
                  }
                });
              },
            ),
          )),
    );
  }
}

void horizontalAction(Event event, DraggableDetails dragDetails, int index) {
  print(dragDetails.velocity.pixelsPerSecond.dx);
  if (dragDetails.velocity.pixelsPerSecond.dx > 100) {
    print("Right");
    if (dragDetails.offset.dx / 100 > DayViewWidths().daySeparationAreaWidth / 2) {
      eventsOfDay1
          .add(new Event(startMinuteOfDay: event.startMinuteOfDay, duration: event.duration, title: event.title));
      eventsOfDay0.removeAt(index);
    }
  } else if (dragDetails.velocity.pixelsPerSecond.dx < -40) {
    print("left");
    print("${dragDetails.offset.dx / 100} > ${DayViewWidths().daySeparationAreaWidth / 2}");
    if (dragDetails.offset.dx / 100 > DayViewWidths().daySeparationAreaWidth) {
      eventsOfDay0
          .add(new Event(startMinuteOfDay: event.startMinuteOfDay, duration: event.duration, title: event.title));
      eventsOfDay1.removeAt(index);
    }
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, String title) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$title'),
        content: Text('$title selected.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

class SyncScrollController {
  List<ScrollController> _registeredScrollControllers = new List<ScrollController>();

  ScrollController _scrollingController;
  bool _scrollingActive = false;

  SyncScrollController(List<ScrollController> controllers) {
    controllers.forEach((controller) => registerScrollController(controller));
  }

  void registerScrollController(ScrollController controller) {
    _registeredScrollControllers.add(controller);
  }

  void processNotification(ScrollNotification notification, ScrollController sender) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = sender;
      _scrollingActive = true;
      return;
    }

    if (identical(sender, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return;
      }

      if (notification is ScrollUpdateNotification) {
        _registeredScrollControllers.forEach((controller) =>
            {if (!identical(_scrollingController, controller)) controller..jumpTo(_scrollingController.offset)});
        return;
      }
    }
  }
}

int round(int tnum) {
  int num = (tnum / 3).round();
  int temp = num % 60;
  // print(num.toString() + "is drag");
  //print(temp.toString() + "is modulus");
  //print((num - temp).toString() + "is offset");
  if (temp < 15)
    return (num - temp);
  else
    return num + 60 - temp;
}
