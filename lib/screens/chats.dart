import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:telegrammm/models/chat.dart';

class ChatCatalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
            unreadCount: 228,
            pinned: true,
          ),
          ChatLabel(
            color: Colors.purple[200]!,
            name: "Abdulla",
            lastMessage: "Alhamdulillah",
            unreadCount: 42,
            pinned: false,
          ),
        ],
      ),
    );
  }
}

class ChatLabel extends StatelessWidget {
  ChatLabel({
    required this.color,
    required this.name,
    required this.lastMessage,
    required this.pinned,
    required this.unreadCount,
  });

  final Color color;
  final String name;
  final String lastMessage;
  final bool pinned;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            ChatModel(pinned: pinned, unreadCount: unreadCount),
        builder: (context, _) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              //radius: 25.0,
            ),
            title: Text(
              name,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              lastMessage,
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
                if (Provider.of<ChatModel>(context).pinned)
                  SvgPicture.asset(
                    "assets/push-pin-svgrepo-com.svg",
                    width: 12.0,
                    height: 12.0,
                    color: Colors.white,
                  )
                else
                  Container(
                    child: Text(unreadCount.toString()),
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
            onLongPress: () => showMenu(
              context: context,
              position: RelativeRect.fromLTRB(0.0, 0.0, 50.0, 50.0),
              items: _menuItems(context),
            ),
          );
          //);
        });
  }
}

List<PopupMenuItem<ListTile>> _menuItems(BuildContext context) {
  var chat = context.read<ChatModel>();
  return <PopupMenuItem<ListTile>>[
    PopupMenuItem(
        child: ListTile(
      title: chat.pinned ? Text("Pin off") : Text("Pin"),
      trailing: SvgPicture.asset(
        chat.pinned ? "assets/options-pin-off.svg" : "assets/options-pin.svg",
        width: 12.0,
        height: 12.0,
        color: Colors.black,
      ),
      onTap: chat.pin,
    )),
  ];
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

