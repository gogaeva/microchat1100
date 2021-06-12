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
    );
  }
}

class ChatLabel extends StatelessWidget {
  ChatLabel({
    required this.color,
    required this.name,
    required this.lastMessage,
    required this.messageCount,
    //this.pinned = false,
    //this.unreadCount = 0,
    // this.pinned = false,
  });

  final Color color;
  final String name;
  final String lastMessage;
  final int messageCount;
  //bool pinned;
  //int unreadCount;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatModel(),
      child: ListTile(
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
                child: Text(messageCount.toString()),
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
          builder: (BuildContext context) => _buildOptionsMenu(context),
        ),
      ),
    );
  }
}

_buildChatLabelItem(ChatData cd)

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

Widget _buildOptionsMenu(BuildContext context) {
 // var chat = context.read<ChatModel>();
  //var chat = Provider.of<ChatModel>(context, listen :false);
  return Consumer<ChatModel>(
    builder: (context, chat, _) => AlertDialog(
        content: ListView(
          children: [
            ListTile(
              title: Text("pin"),
              trailing: chat.pinned ?
              SvgPicture.asset(
                "assets/push-pin-svgrepo-com.svg",
                width: 7.0,
                height: 7.0,
                color: Colors.grey,
              ) : null,
              onTap: chat.pin,
            ),
          ],
        )
    ),
  );
}