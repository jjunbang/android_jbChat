import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jb_chat/model/list_model.dart';
import 'package:jb_chat/screens/chat/chat_screen.dart';
import 'package:jb_chat/screens/chat/form_screen.dart';
import 'package:provider/provider.dart';

class EntryLists extends StatefulWidget{

  EntryLists({required this.currUser});
  final User currUser;

  @override
  State<EntryLists> createState() => _EntryListsState();
}




class _EntryListsState extends State<EntryLists>{

  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  final _joinPasswdFocus = FocusNode();

  final db = FirebaseFirestore.instance;

  int _listInfo = 0;
  String _joinPasswd = '';

  // Future<QuerySnapshot<Object?>> test(testval) async{
  //   QuerySnapshot  querySnapshot
  //   = await db.collection("userData").
  //   doc(widget.currUser.uid).
  //   collection('joinList').where('recentJoinTime', isLessThan: testval).get();
  //
  //   return querySnapshot;
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListModel(listInfo: 0),
      child: Scaffold(
        body: Container(
          child: StreamBuilder(
              // stream: db.collection('chatList').orderBy('createTime').snapshots(),
              stream: db.collection('chatList').where('joiner', arrayContains: widget.currUser.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length ,
                  itemBuilder: ((context, index) {
                    final parentDoc = snapshot.data!.docs[index];
                    // test();
                    // CollectionReference join
                    // =

                    // DocumentSnapshot joinSnapshot = join.doc().get();


                    // var joinTime = joinDocRef.snapshots().toString();

                      return GestureDetector(
                        onTap: (){
                          Provider.of<ListModel>(context, listen: false ).changeListinfo(_listInfo == index+1 ? 0 : index+1);
                          _listInfo = _listInfo == index+1 ? 0 : index+1;
                        },
                        onDoubleTap: () async{
                          var _currTime1 = DateFormat('yyyy-MM-dd a hh:mm:ss').format(DateTime.now());
                          DocumentReference joinDocRef =
                              db.collection("userData").doc(widget.currUser.uid).collection("joinList").doc(parentDoc.id);
                          // final data = parentDoc.id;

                           // print('${joinTime}');

                          await joinDocRef.update({
                            'recentJoinTime':_currTime1,
                          });

                          // await Navigator.push(context,
                          //     MaterialPageRoute(
                          //       builder:(context) =>
                          //           ChatScreen(chatId: snapshot.data!.docs[index].id,currUser: widget.currUser),
                          //     )
                          // );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: mediaWidth(context,1),
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                                  border: Border.all(color: Colors.black12, width: 3),
                                  gradient:LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.yellow,
                                        Colors.orangeAccent,
                                        Colors.orange,
                                      ]
                                  )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          (snapshot.data!.docs[index]['isLock'] == "true") ? Icon(Icons.lock) : Icon(Icons.lock_open),
                                          SizedBox(width: 10,),
                                          Text(snapshot.data!.docs[index]['title']),
                                        ],
                                      ),
                                      Text('참석인원 : '+snapshot.data!.docs[index]['currCnt'] + ' / '+snapshot.data!.docs[index]['totalCnt']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('최근 대화 시간 : '+snapshot.data!.docs[index]['recentChatTime']),
                                      const Text('참여중',style: TextStyle(color: Colors.yellow),)
                                    ],
                                  ),
                                  Visibility(
                                    key: ValueKey((index+1)),
                                    visible: ((index+1) == Provider.of<ListModel>(context).listInfo) ,
                                    child: Opacity(
                                      opacity: 0.85,
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(snapshot.data!.docs[index]['infomation']),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );

                  }),
                );
              }
          ),
        ),

      ),
    );
  }
}
