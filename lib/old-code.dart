import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Replica',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        //primaryColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => {},
          ),
          title: Text("Chats"),
          backgroundColor: Colors.grey,
          actions: [IconButton(icon: Icon(Icons.search), onPressed: () => {})],
        ),
        backgroundColor: Colors.black,
        body: ListView(
          children: <Widget>[
            ChatLabel(
              color: Colors.pink[200]!,
              name: "Виталий",
              lastMessage: "Унтерсанчизес",
              messageCount: 228,
            ),
            ChatLabel(
              color: Colors.purple[200]!,
              name: "Abdulla",
              lastMessage: "Alhamdulillah",
              messageCount: 42,
            )
          ],
        ),
      ),
    );
  }
}



class ChatLabel extends StatefulWidget {
  ChatLabel({
    required this.color,
    required this.name,
    required this.lastMessage,
    required this.messageCount,
    this.unreadCount = 0,
    // this.pinned = false,
  });

  final Color color;
  final String name;
  final String lastMessage;
  final int messageCount;
  final int unreadCount;

  @override
  _ChatLabelState createState() => _ChatLabelState();
}

class _ChatLabelState extends State<ChatLabel> {
  bool pinned = false;

  void pin() {
    setState(() {
      pinned = !pinned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.color,
        //radius: 25.0,
      ),
      title: Text(
        widget.name,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        widget.lastMessage,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            //DateTime.parse("2012-02-27").toString(),
            // DateTime.now().weekday.toString(),
            timeLabel('2021-04-09 20:00:00'),
            style: TextStyle(color: Colors.white),
          ),
          //if (widget.unreadCount > 0)
          if (pinned)
            SvgPicture.asset(
              "assets/push-pin-svgrepo-com.svg",
              width: 12.0,
              height: 12.0,
              color: Colors.white,
            )
          else
            Container(
              child: Text(widget.messageCount.toString()),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(7.0),
                    right: Radius.circular(7.0),
                  ),
                ),
              ),
              padding: EdgeInsets.all(2.0),
            )
        ],
      ),
      onLongPress: () => showDialog(
        context: context,
        builder: (BuildContext context) => _buildOptionsMenu(context, pin),
      ),
    );
  }
}

String timeLabel(String time) {
  var then = DateTime.parse(time);
  var now = DateTime.now();
  var diff = now.difference(then);
  if (diff.inDays > 6)
    return DateFormat('dd.MM').format(then);
  else if (diff.inDays.abs() > 0)
    return DateFormat('EEE').format(then);
  else
    return DateFormat.Hm().format(then);
}


/*
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) => AlertDialog(
        //           content: Column(children: [
        //             ElevatedButton(onPressed: pin, child: Text("Pin"))
        //           ]),
        //         ));
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopup(context, pin));
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        height: 60,
        child: Row(children: [
          CircleAvatar(
            backgroundColor: widget.color,
            radius: 25.0,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.lastMessage,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateTime.parse("2012-02-27").toString(),
                // DateTime.now().weekday.toString(),
                style: TextStyle(color: Colors.white),
              ),
              //if (widget.unreadCount > 0)
              if (pinned)
                SvgPicture.asset(
                  "assets/push-pin-svgrepo-com.svg",
                  width: 12.0,
                  height: 12.0,
                  color: Colors.white,
                )
              else
                Container(
                  child: Text(widget.messageCount.toString()),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(7.0),
                        right: Radius.circular(7.0),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(2.0),
                )
            ],
          ),
        ]),
      ),
    );
  }
}
*/
// Widget _buildPopup(BuildContext context, void Function() onPin) {
//   return AlertDialog(
//     content: Column(
//         children: [ElevatedButton(onPressed: onPin, child: Text("Pin"))]),
//   );
// }
//TODO:ListView.separated
Widget _buildOptionsMenu(BuildContext context, void Function()? pin) {
  return AlertDialog(
      content: ListView(
        children: [
          ListTile(
            title: Text("pin"),
            trailing: SvgPicture.asset(
              "assets/push-pin-svgrepo-com.svg",
              width: 7.0,
              height: 7.0,
              color: Colors.grey,
            ),
            onTap: pin,
          ),
        ],
      )
  );
}