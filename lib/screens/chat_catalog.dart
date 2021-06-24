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

class ChatCatalog extends StatefulWidget {
  ChatCatalog({required this.userId});

  final String? userId;

  @override
  _ChatCatalogState createState() => _ChatCatalogState();
}

class _ChatCatalogState extends State<ChatCatalog> {
  late List<String> chatWith;
  late Query<Map<String, dynamic>> peers;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    print('INITSTATE FINISHED');
  }

  void fetchData() async {
    this.setState(() {
      isLoading = true;
    });
    //TODO: create stream to use in build
    var snapshot = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    List<dynamic> chatWith = snapshot.get('chatWith');
    print(chatWith.toString());
    peers = FirebaseFirestore.instance.collection('users')
        .where('id', whereIn: chatWith);
    print('PEERS INITIALIZED');
    this.setState(() {
      isLoading = false;
    });
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
        backgroundColor: Colors.grey,
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () => {})],
      ),
      backgroundColor: Colors.black,
      body: isLoading ? Loading() : StreamBuilder(
          stream:
              //FirebaseFirestore.instance.collection('chat-catalog').snapshots(),
              //FirebaseFirestore.instance.collection('users').doc(widget.userId).snapshots(),
              peers.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) =>
                  ChatLabel.fromDb(snapshot.data?.docs[index]),
            );
          }),
    );
  }
}

//TODO: lastMessageTime (timestamp)
class ChatLabel extends StatelessWidget {
  ChatLabel({
    required this.photoUrl,
    required this.name,
    this.lastMessage,
    required this.pinned,
    required this.unreadCount,
  });

  ChatLabel.fromDb(QueryDocumentSnapshot<Object?>? document)
      : this(
          photoUrl: '',
          name: document?['name'],
          //lastMessage: document?['lastMessage'],
          lastMessage: '',
          //pinned: document?['pinned'],
          //unreadCount: document?['unreadCount'],
          pinned: true,
          unreadCount: 11,
        );

  final String photoUrl;
  final String name;
  final String? lastMessage;
  final bool pinned;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            ChatModel(pinned: pinned, unreadCount: unreadCount),
        builder: (context, _) {
          return FocusedMenuHolder(
            menuWidth: MediaQuery.of(context).size.width * 0.50,
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
            onPressed: () {},
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                title: context.read<ChatModel>().pinned
                    ? Text("Pin off")
                    : Text("Pin"),
                trailingIcon: context.read<ChatModel>().pinned
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
                    timeLabel('2021-04-09 20:00:00'),
                    style: TextStyle(color: Colors.white),
                  ),
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
            ),
          );
        });
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
