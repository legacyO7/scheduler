import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:calendar_views/day_view.dart';

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

int resID = 0;

List<List> EventList = <List>[ <Event>[
  new Event(startMinuteOfDay: 0, duration: 60, title: "Midnight Party", boCompleted: true),
  new Event(startMinuteOfDay: 6 * 60, duration: 2 * 60, title: "Morning Routine"),
  new Event(startMinuteOfDay: 6 * 60, duration: 60, title: "Eat Breakfast"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Get Dressed"),
  new Event(startMinuteOfDay: 18 * 60, duration: 60, title: "Take Dog For A Walk"),
], <Event>[
  new Event(startMinuteOfDay: 1 * 60, duration: 90, title: "Sleep Walking"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Drive To Work"),
  new Event(startMinuteOfDay: 8 * 60, duration: 20, title: "A"),
  new Event(startMinuteOfDay: 8 * 60, duration: 30, title: "B"),
  new Event(startMinuteOfDay: 8 * 60, duration: 60, title: "C"),
  new Event(startMinuteOfDay: 8 * 60 + 10, duration: 20, title: "D"),
  new Event(startMinuteOfDay: 8 * 60 + 30, duration: 30, title: "E"),
  new Event(startMinuteOfDay: 23 * 60, duration: 60, title: "Midnight Snack"),
],
  <Event>[
    Event(startMinuteOfDay: 10 * 60, duration: 30, title: "Pic Up"),
    Event(startMinuteOfDay: 12 * 60, duration: 30, title: "Delivery"),
    Event(startMinuteOfDay: 15 * 60, duration: 30, title: "Delivery"),
    Event(startMinuteOfDay: 17 * 60, duration: 30, title: "Delivery"),
  ],
  <Event>[
    Event(startMinuteOfDay: 8 * 60 + 30, duration: 90, title: "Universe through a"),
    Event(startMinuteOfDay: 15 * 60, duration: 90, title: "Top 3 reasons why"),
    Event(startMinuteOfDay: 11 * 60, duration: 30, title: "Weekly Groceries"),
    Event(startMinuteOfDay: 13 * 60, duration: 30, title: "Dealing with "),
  ]

];

List<String> Resources = ["Resource A", "Resource B", "Resource C", "Resource D"];

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

  TextEditingController subjectController = TextEditingController();
  TextEditingController FromTimeController = TextEditingController();
  TextEditingController ToTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _day0 = new DateTime.now();
    dayList = [_day0];
    for (int i = 1; i < EventList.length; i++) {
      dayList.add(_day0.toUtc().add(new Duration(days: i)).toLocal());
    }

    startTime = DateTime.now();
  }

  void dispose() {
    super.dispose();
  }

  showAlertDialog(BuildContext context, int minuteoftheDay, String title, int interval, int index, int resID) {
    String subject = title;

    double fromTime = (minuteoftheDay / 60),
        toTime = (minuteoftheDay / 60) + 1;
    int duration = interval;

    FromTimeController.text = (minuteoftheDay / 60).toString();
    ToTimeController.text = ((minuteoftheDay / 60) + duration/ 60).toString();
    subjectController.text = subject;

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        if (subject != "") {
          setState(() {
            if (title != "") {
              EventList[resID][index].title = subject;
              EventList[resID][index].startMinuteOfDay = (fromTime * 60).round();
              EventList[resID][index].duration = ((toTime - fromTime) * 60).round();
            } else
              EventList[resID]
                  .add(new Event(startMinuteOfDay: (fromTime * 60).round(),
                  duration: ((toTime - fromTime) * 60).round(),
                  title: subject));
          });
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

    AlertDialog alert = AlertDialog(
      title: Text("Add"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Resources[resID]),
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
                      fromTime = double.parse(text);
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
                    toTime = double.parse(text);
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
    return "${((minuteOfDay < 60) ? (minuteOfDay ~/ 60 + 12) : (minuteOfDay <= 60 * 12)
        ? (minuteOfDay ~/ 60)
        : (minuteOfDay ~/ 60 - 12)).toString()}"
        "${(minuteOfDay < 60 * 12) ? " AM" : (minuteOfDay == 60 * 24) ? " AM" : " PM"}";
  }

  List<StartDurationItem> _getEventsOfDay(DateTime day) {
    int resID;
    List<Event> events;
    resID = day.day - DateTime
        .now()
        .day;
    events = EventList[resID];

    return events
        .asMap()
        .entries
        .map(
          (event) =>
      new StartDurationItem(
        startMinuteOfDay: event.value.startMinuteOfDay,
        duration: event.value.duration,
        builder: (context, itemPosition, itemSize) =>
            _eventBuilder(context, itemPosition, itemSize, event.value, event.key, resID),
      ),
    )
        .toList();
  }

  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;

    print("Resourse number= ${(x / 254).floor()}");
    setState(() {
      resID = (x / 254).floor();
    });
    //print("tap down " + x.toString() + ", " + y.toString());
    // print("Vertical scroll offset = ${_mycontroller1.offset}" );
    // double minutes = (y + _mycontroller1.offset - 184) / 1.5;
    // print("Minutes of day = $minutes");
    // print("Event Day index = ${((x + _mycontroller3.offset - 64) / 140 % userIds.length).round()}");
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
        body:
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: ((EventList.length)*250.0),
            child: DayViewEssentials(
              //widths: DayViewWidths(separationAreaWidth: 10,),
                properties: new DayViewProperties(days: dayList),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: <Widget>[
                              NotificationListener<ScrollNotification>(
                                child: Expanded(
                                  flex: 10,
                                  child: SingleChildScrollView(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => print("tapped"),
                                      onTapDown: (TapDownDetails details) => _onTapDown(details),
                                      //   onTapUp: (TapUpDetails details) => _onTapUp(details),
                                      child: DayViewSchedule(
                                        heightPerMinute: 1,
                                        topExtensionHeight: 0,
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
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                )),
          ),)


    );
  }

  Widget _getUserOfDay(DateTime day) {
    Widget userName;
    userName = Text(
      Resources[DateTime
          .now()
          .day - day.day],
      maxLines: 1,
      overflow: TextOverflow.clip,
    );
    return userName;
  }

  Widget _headerItemBuilder(BuildContext context, DateTime day) {
    return new Container(
      color: Colors.grey[300],
      padding: new EdgeInsets.symmetric(vertical: 4.0),
      child: Column(children: <Widget>[
        Flexible(
          flex: 1,
          child: _getUserOfDay(day),
        ),
        // Flexible(flex:3, child:SingleChildScrollView(child:_getListOfAnytimeEvents(day),))
      ]),
    );
  }

  Positioned _generatedTimeIndicatorBuilder(BuildContext context,
      ItemPosition itemPosition,
      ItemSize itemSize,
      int minuteOfDay,) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
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

  Positioned _generatedSupportLineBuilder(BuildContext context,
      ItemPosition itemPosition,
      double itemWidth,
      int minuteOfDay,) {
    return Positioned(
        top: itemPosition.top,
        left: itemPosition.left,
        width: itemWidth,
        child:

        Container(width: itemWidth, height: 60, child: Column(
          children: [
            Expanded(flex: 0, child: new Container(
              height: 0.7,
              color: (minuteOfDay % 60 == 0) ? Colors.grey[700] : Colors.grey[400],
            )),
            Expanded(
              flex: 1,
              child: DragTarget(
                builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => {showAlertDialog(context, minuteOfDay, "", 60, 0, resID)},
                    //  onTapDown: _onTapDown,
                    child: Container(
                        padding: EdgeInsets.only(bottom: 30),
                        color: Colors.blue[100],

                    ),
                  );
                },
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (Event event) {
                  print("OA");
                  print(event.title);
                  event.startMinuteOfDay = minuteOfDay;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: DragTarget(
                builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => {showAlertDialog(context, minuteOfDay, "", 60, 0, resID)},
                    //  onTapDown: _onTapDown,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 30),
                      color: Colors.green[100],

                    ),
                  );
                },
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (Event event) {
                  print("OA");
                  print(event.title);
                  event.startMinuteOfDay = minuteOfDay+30;
                },
              ),
            )
          ],
        ),));
  }

  Positioned _generatedDaySeparatorBuilder(BuildContext context,
      ItemPosition itemPosition,
      ItemSize itemSize,
      int daySeparatorNumber,) {
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

  Positioned _eventBuilder(BuildContext context, ItemPosition itemPosition, ItemSize itemSize, Event event, int index,
      int resID) {
    double _x = itemPosition.top,
        _y = itemPosition.left;

    return new Positioned(
        top: _x,
        left: _y,
        width: itemSize.width,
        height: itemSize.height,
        child: Container(
          child: Draggable(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 0,
                  child: GestureDetector(
                      onTap: () {
                        print("SWIPE TOP TAP");
                      },
                      onVerticalDragUpdate: (details) {
                        if (details.delta.dy < -3) {
                          print("swipe top up");
                          if (event.startMinuteOfDay > 0)
                            setState(() {
                              event.startMinuteOfDay = event.startMinuteOfDay - 30;
                              event.duration = event.duration + 30;
                            });
                        } else if (details.delta.dy > 3) {
                          print("swipe top down");
                          if (event.duration > 30)
                            setState(() {
                              event.startMinuteOfDay = event.startMinuteOfDay + 30;
                              event.duration = event.duration - 30;
                            });
                        }
                      },
                      child: Container(
                        height: 10,
                        width: itemSize.width,
                        color: Colors.green,
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onLongPress: () {
                        showAlertDialog(context, event.startMinuteOfDay, event.title, event.duration, index, resID);
                      },
                      child: Container(
                          padding: EdgeInsets.all(3),
                          color: Colors.red[200],
                          margin: EdgeInsets.all(1),
                          child: Text(("${event.title}")))),
                  flex: 1,
                ),
                Expanded(
                    flex: 0,
                    child: Draggable(
                      child: GestureDetector(
                          onTap: () {
                            print("swipe bottom tap");
                          },
                          onVerticalDragUpdate: (details) {
                            print(details.delta.dx);
                            if (details.delta.dy < -3) {
                              print("swipe bottom up");
                              if (event.duration > 30)
                                setState(() {
                                  event.duration = event.duration - 30;
                                });
                            } else if (details.delta.dy > 3) {
                              print("swipe bottom down");
                              if (event.startMinuteOfDay + event.duration <= 1380)
                                setState(() {
                                  event.duration = event.duration + 30;
                                });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            width: itemSize.width,
                            color: Colors.green,
                          )),
                      feedback: Container(),
                    )),
              ],
            ),
            feedback: Container(
              height: itemSize.height,
              width: itemSize.width,
              padding: EdgeInsets.all(3),
              color: Colors.red[200],
              margin: EdgeInsets.all(1),
            ),
            data: event,
            childWhenDragging: Container(),
            onDragEnd: (dragDetails) {
              setState(() {
                _x = dragDetails.offset.dx;
                //   _y = dragDetails.offset.dy+appBar.preferredSize.height+MediaQuery.of(context).padding.top;
                _y = dragDetails.offset.dy;
                horizontalAction(event, dragDetails, index, itemPosition, resID);
                // double dragDirection = dragDetails.offset.direction;
                //  print(dragDirection);
                //   directionHandler(dragDetails.offset.direction, dragDetails.offset.dx-itemPosition.left,dragDetails.offset.dy-itemPosition.top);
                // print("( "+dragDetails.offset.dx.toString()+", "+dragDetails.offset.dy.toString() +")");
                //  print(itemPosition.top.toString()+"item position");
                //  print(dragDetails.offset.dy.toString()+"dx position");
                //    print(event.startMinuteOfDay.toString()+"startminite");
                /*  if (dragDetails.velocity.pixelsPerSecond.dy<0) {
                          print("UP");
                          if (round( event.startMinuteOfDay-(_y)) >=0) {
                            event.startMinuteOfDay = round( event.startMinuteOfDay-(_y));
                            print(event.startMinuteOfDay);
                          //  horizontalAction(event, dragDetails, index,itemPosition);
                          } else{
                            event.startMinuteOfDay = 0;
                          }
                        } else {
                          print("Down");
                          if (round(event.startMinuteOfDay+(_y)) <= 1380) {
                            print("still here");
                            event.startMinuteOfDay =   round(event.startMinuteOfDay+(_y));
                            //  print(event.startMinuteOfDay.toString() + "after");
                        //  horizontalAction(event, dragDetails, index,itemPosition);
                          }else
                            {
                              print((1440-event.duration).toString()+"=====");
                              event.startMinuteOfDay=1440-event.duration;
                            }
                        }*/
              });
            },
          ),
        ));
  }
}

void directionHandler(double dragDirection, x, y) {
  if (x > 0 && y > 0)
    print("lies in First quadrant");
  else if (x < 0 && y > 0)
    print("lies in Second quadrant");
  else if (x < 0 && y < 0)
    print("lies in Third quadrant");
  else if (x > 0 && y < 0)
    print("lies in Fourth quadrant");
  else if (x == 0 && y > 0)
    print("lies at positive y axis");
  else if (x == 0 && y < 0)
    print("lies at negative y axis");
  else if (y == 0 && x < 0)
    print("lies at negative x axis");
  else if (y == 0 && x > 0)
    print("lies at positive x axis");
  else
    print("lies at origin");
}

void horizontalAction(Event event, DraggableDetails dragDetails, int index, ItemPosition itemPosition, int resID) {
  int startEventIndex = resID,
      endEventIndex;

  print(dragDetails.offset.dx - itemPosition.left);
  if (dragDetails.offset.dx - itemPosition.left > 200) {
    print("Right");
    if (dragDetails.offset.dx - itemPosition.left > 200) {
      endEventIndex = ((dragDetails.offset.dx - itemPosition.left) / 254).round() + resID;

      if(endEventIndex>=EventList.length)
        endEventIndex=EventList.length-1;

      print("start $startEventIndex || end $endEventIndex");

      EventList[endEventIndex]
          .add(new Event(startMinuteOfDay: event.startMinuteOfDay, duration: event.duration, title: event.title));
      EventList[startEventIndex].removeAt(index);
    }
  } else {
    print("left");
    if (dragDetails.offset.dx - itemPosition.left < -200 ) {
      endEventIndex = resID - (((dragDetails.offset.dx - itemPosition.left).abs()) / 254).round();

      print("start $startEventIndex || end $endEventIndex");

      if(endEventIndex<0)
        endEventIndex=0;

      EventList[endEventIndex]
          .add(new Event(startMinuteOfDay: event.startMinuteOfDay, duration: event.duration, title: event.title));
      EventList[startEventIndex].removeAt(index);
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


int round(double tnum) {
  int num = (tnum / 1).round();
  int temp = num % 60;
  // print(num.toString() + "is drag");
  //print(temp.toString() + "is modulus");
  //print((num - temp).toString() + "is offset");
  //if (temp < 30)
  return (num - temp);
  //else
  //  return (num +60 - temp);
}
