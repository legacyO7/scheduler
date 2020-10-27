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

List<List> eventList = <List>[
  <Event>[
    new Event(startMinuteOfDay: 0, duration: 60, title: "Midnight Party", boCompleted: true),
    new Event(startMinuteOfDay: 6 * 60, duration: 2 * 60, title: "Morning Routine"),
    new Event(startMinuteOfDay: 6 * 60, duration: 60, title: "Eat Breakfast"),
    new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Get Dressed"),
    new Event(startMinuteOfDay: 18 * 60, duration: 60, title: "Take Dog For A Walk"),
  ],
  <Event>[
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

List<String> resources = ["Resource A", "Resource B", "Resource C", "Resource D"];

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
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();

  ScrollController scrollcontroller = new ScrollController();

  @override
  void initState() {
    super.initState();

    _day0 = new DateTime.now();
    dayList = [_day0];
    for (int i = 1; i < eventList.length; i++) {
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

    fromTimeController.text = (minuteoftheDay / 60).toString();
    toTimeController.text = ((minuteoftheDay / 60) + duration / 60).toString();
    subjectController.text = subject;

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        if (subject != "") {
          setState(() {
            if (title != "") {
              eventList[resID][index].title = subject;
              eventList[resID][index].startMinuteOfDay = (fromTime * 60).round();
              eventList[resID][index].duration = ((toTime - fromTime) * 60).round();
            } else
              eventList[resID].add(new Event(
                  startMinuteOfDay: (fromTime * 60).round(),
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
          Text(resources[resID]),
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
                    controller: fromTimeController,
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
                  controller: toTimeController,
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

  List<StartDurationItem> _getEventsOfDay(DateTime day) {
    int resID;
    List<Event> events;
    resID = day.day - DateTime
        .now()
        .day;
    events = eventList[resID];

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
    var x = details.localPosition.dx;
    print("Resourse number= ${(x / 1)}");
    print("Resourse number= ${((details.localPosition.dx - 60) / 230)}");
    setState(() {
      resID = ((x -
          (DayViewEssentials().widths.timeIndicationAreaWidth + DayViewEssentials().widths.mainAreaStartPadding)) / 230)
          .floor();
    });
  }

  AppBar appBar = AppBar(
    title: new Text("Scheduler"),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: appBar,
        body:


        Row(mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 240,),
            Expanded(child:
            SingleChildScrollView(
              controller: scrollcontroller,
              scrollDirection: Axis.horizontal,
              child: Container(
                width: ((eventList.length) * 250.0),
                child: DayViewEssentials(
                    widths: DayViewWidths(totalAreaStartPadding: 0),
                    properties: new DayViewProperties(days: dayList),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: DayViewDaysHeader(
                                      headerItemBuilder: _headerItemBuilder,
                                    ),
                                  ),
                                  NotificationListener<ScrollNotification>(
                                    child: Expanded(
                                      flex: 10,
                                      child: SingleChildScrollView(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () => print("tapped"),
                                          onTapDown: (TapDownDetails details) => _onTapDown(details),
                                          child: DayViewSchedule(
                                            heightPerMinute: 1,
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
              ),
            ),)

          ],));
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

  Widget _getUserOfDay(DateTime day) {
    Widget userName;
    userName = Text(
      resources[day.day - DateTime
          .now()
          .day],
      maxLines: 1,
      overflow: TextOverflow.clip,
    );
    return userName;
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
        child: Container(
          width: itemWidth,
          height: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                  flex: 0,
                  child: new Container(
                    height: 0.7,
                    color: (minuteOfDay % 60 == 0) ? Colors.grey[700] : Colors.grey[400],
                  )),
              Expanded(
                flex: 1,
                child: DragTarget(
                  builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
                    // print(itemWidth);
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
                    event.startMinuteOfDay = minuteOfDay + 30;
                  },
                ),
              )
            ],
          ),
        ));
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
                _y = dragDetails.offset.dy;
                horizontalAction(event, dragDetails, index, itemPosition, resID);
              });
            },
          ),
        ));
  }


  void horizontalAction(Event event, DraggableDetails dragDetails, int index, ItemPosition itemPosition, int resID) {
    int oldEventIndex = resID,
        newEventIndex;

    print(dragDetails.offset.dx.toString() + " - " + itemPosition.left.toString());
    if (dragDetails.offset.dx - itemPosition.left + scrollcontroller.offset > 200) {
      print("Right");
      if (dragDetails.offset.dx - itemPosition.left + scrollcontroller.offset > 200) {
        newEventIndex =
            ((dragDetails.offset.dx - 240 - itemPosition.left + scrollcontroller.offset) / 230).round() + resID;

        if (newEventIndex >= eventList.length) newEventIndex = eventList.length - 1;
        print("start $oldEventIndex || end $newEventIndex");

        eventList[newEventIndex]
            .add(new Event(startMinuteOfDay: event.startMinuteOfDay, duration: event.duration, title: event.title));
        eventList[oldEventIndex].removeAt(index);
      }
    } else {
      print(dragDetails.offset.dx - scrollcontroller.offset - itemPosition.left);
      print("=-=-=-=-=");
      if (dragDetails.offset.dx - scrollcontroller.offset - itemPosition.left < -200 + 240) {
        print("left");
        newEventIndex =
            resID - (((dragDetails.offset.dx - 240 - itemPosition.left + scrollcontroller.offset).abs()) / 230).round();

        if (newEventIndex < 0) newEventIndex = 0;

        print("start $oldEventIndex || end $newEventIndex");

        eventList[newEventIndex]
            .add(new Event(startMinuteOfDay: event.startMinuteOfDay, duration: event.duration, title: event.title));
        eventList[oldEventIndex].removeAt(index);
      }
    }
  }
}