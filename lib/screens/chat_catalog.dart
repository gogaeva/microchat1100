import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:telegrammm/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:telegrammm/screens/loading.dart';
import 'package:telegrammm/screens/chat.dart';

class User {
  User(this.id, this.name, this.photoUrl, this.pinned, this.lastMsg, this.lastMsgTime);

  late String name;
  late String id;
  late String? photoUrl;
  late bool pinned;
  late String lastMsg;
  late String lastMsgTime;
}

class ChatCatalog extends StatefulWidget {
  //late User _user;
  ChatCatalog({required this.userId});

  final String? userId;

  @override
  _ChatCatalogState createState() => _ChatCatalogState();
}

class _ChatCatalogState extends State<ChatCatalog> {
  bool isLoading = false;

  Future<User> fetchData(String peerId, bool pinned) async {
    print("FUTURE BEGIN");
    var peerDoc = await FirebaseFirestore.instance.collection('users')
        .doc(peerId).get();
    print(1);
    String name = peerDoc.get('name');
    String? photoUrl = peerDoc.get('photoURL');
    print(2);
    String chatId = (widget.userId.hashCode <= peerId.hashCode)
        ? 'messages-${widget.userId}-$peerId'
        : 'messages-$peerId-${widget.userId}';
    var querySnapshot = await FirebaseFirestore.instance.collection('messages')
        .doc(chatId).collection(chatId).get();
    print(3);
    var msgDoc = querySnapshot.docs.last;
    String timestamp = msgDoc['timestamp'];
    String msg = msgDoc['content'];
    print(name);
    print(pinned);
    print(msg);
    print("FUTURE END");
    //widget._user = User(peerId, name, photoUrl, pinned, msg, timestamp);
    return User(peerId, name, photoUrl, pinned, msg, timestamp);
  }

  @override
  Widget build(BuildContext context) {
    print('BUILDING STARTS');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => {},
        ),
        title: Text("Chats"),
        backgroundColor: Colors.grey[800],
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () => {})],
      ),
      backgroundColor: Colors.black,
      body: isLoading ? Loading() : StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(
              widget.userId)
              .collection('chatsWith').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var document = snapshot.data?.docs[index];
                String peerId = document?['id'];
                bool pinned = document?['pinned'];
                print(peerId);
                print(pinned);
                return FutureBuilder(
                  future: fetchData(peerId, pinned),
                  builder: (context, user) {
                    print('FUTURE BUILD');
                    if (user.hasData)
                      return ChatLabel.fromUser(user.data! as User);
                    else {
                      if (user.hasError)
                        print(user.error);
                      return Loading();
                    }
                  }
                );
              },
            );
          }),
    );
  }
}

class ChatLabel extends StatelessWidget {
  // ChatLabel({Key key}) : super(key: key);
  ChatLabel({
    required this.id,
    required this.photoUrl,
    required this.name,
    this.lastMessage,
    this.lastMessageTime,
    required this.pinned,
    required this.unreadCount,
  });

  ChatLabel.fromUser(User user)
      : this(
    id: user.id,
    photoUrl: user.photoUrl,
    name: user.name,
    lastMessage: user.lastMsg,
    lastMessageTime: user.lastMsgTime,
    pinned: user.pinned,
    unreadCount: 11,
  );

  final String id;
  final String? photoUrl;
  final String name;
  final String? lastMessage;
  final String? lastMessageTime;
  final bool pinned;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
        ChatModel(pinned: pinned, unreadCount: 11),
        builder: (context, _) {
          return FocusedMenuHolder(
            menuWidth: MediaQuery
                .of(context)
                .size
                .width * 0.50,
            blurSize: 5.0,
            menuItemExtent: 45,
            menuBoxDecoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            duration: Duration(milliseconds: 100),
            animateMenuItems: true,
            blurBackgroundColor: Colors.black54,
            bottomOffsetHeight: 100,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Chat(
                            peerId: id,
                            peerName: name,
                            peerAvatar: '',
                          )));
            },
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                backgroundColor: Colors.grey,
                title: context
                    .read<ChatModel>()
                    .pinned
                    ? Text("Pin off")
                    : Text("Pin"),
                trailingIcon: context
                    .read<ChatModel>()
                    .pinned
                    ? Icon(MdiIcons.pinOff)
                    : Icon(MdiIcons.pin),
                onPressed: () => context.read<ChatModel>().pin(),
              )
            ],
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
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
                lastMessage ?? '',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    timeLabel(lastMessageTime ?? ''),
                    style: TextStyle(color: Colors.white),
                  ),
                  if (Provider
                      .of<ChatModel>(context)
                      .pinned)
                    SvgPicture.asset(
                      "assets/push-pin-svgrepo-com.svg",
                      width: 12.0,
                      height: 12.0,
                      color: Colors.white,
                    )
                  else
                    Container(
                      child: Text(
                          context
                              .read<ChatModel>()
                              .unreadCount
                              .toString()),
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
            ),
          );
        });
  }
}

String timeLabel(String timestamp) {
  var then = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  var now = DateTime.now();
  var diff = now.difference(then);
  if (diff.inDays > 6)
    return DateFormat('dd.MM').format(then);
  else if (diff.inDays.abs() > 0)
    return DateFormat('EEE').format(then);
  else
    return DateFormat.Hm().format(then);
}
