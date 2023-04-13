import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jb_chat/model/list_model.dart';
import 'package:jb_chat/screens/chat/chat_screen.dart';
import 'package:jb_chat/screens/chat/form_screen.dart';
import 'package:provider/provider.dart';

class ExitLists extends StatefulWidget{

  ExitLists({required this.currUser});
  final User currUser;

  @override
  State<ExitLists> createState() => _ExitListsState();
}




class _ExitListsState extends State<ExitLists>{

  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  final _joinPasswdFocus = FocusNode();

  // var _currTime = DateFormat('h:mm s a - EEEE, d MMM yyy').format(DateTime.now());

  final db = FirebaseFirestore.instance;

  int _listInfo = 0;
  String _joinPasswd = '';


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListModel(listInfo: 0),
      child: Scaffold(
        body: Container(
          child: StreamBuilder(
              stream: db.collection('chatList').orderBy('createTime').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length ,
                  itemBuilder: ((context, index) {
                    List<dynamic> joinerList = snapshot.data!.docs[index]['joiner'];
                    bool _joinChk = false;
                    for (var joinerUid in joinerList) {
                      // print('test1 : $joinerUid / $widget.currUser.uid');
                      if (joinerUid == widget.currUser.uid) {
                        // print('test2 : '+_joinChk.toString());
                        _joinChk = true;
                        break;
                      }
                    }

                    if(_joinChk == false){
                      return GestureDetector(
                        onTap: (){
                          Provider.of<ListModel>(context, listen: false ).changeListinfo(_listInfo == index+1 ? 0 : index+1);
                          _listInfo = _listInfo == index+1 ? 0 : index+1;
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
                                      if(_joinChk == false)
                                        TextButton(
                                            onPressed: (){
                                              _joinPasswd = '';

                                              if(snapshot.data!.docs[index]['isLock'] == "true"){
                                                var showContext = context;
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                                                    builder: (showContext) {
                                                      // FocusScope.of(context).requestFocus(_joinPasswdFocus);
                                                      return AlertDialog(
                                                        content: Container(
                                                          height: 140,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                            children: [
                                                              Text('비밀번호',
                                                                style: TextStyle(fontWeight: FontWeight.bold,),
                                                              ),
                                                              Text('비밀번호 입력이 필요한 비공개 채팅방 입니다.',
                                                                style: TextStyle(color: Colors.grey,fontSize: 14),
                                                              ),
                                                              TextField(
                                                                focusNode: _joinPasswdFocus,
                                                                onChanged: (val){
                                                                  _joinPasswd = val;
                                                                },
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  TextButton(
                                                                    child: const Text('취소',style: TextStyle(fontWeight: FontWeight.bold,),),
                                                                    onPressed: () {
                                                                      Navigator.of(showContext).pop();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: const Text('확인',style: TextStyle(fontWeight: FontWeight.bold,),),
                                                                    onPressed: () async {
                                                                      if(_joinPasswd.isEmpty || _joinPasswd == ''){
                                                                        ScaffoldMessenger.of(showContext).showSnackBar(
                                                                            SnackBar(
                                                                              content: Text('비밀번호를 입력해주세요.'),
                                                                              backgroundColor: Colors.redAccent,
                                                                            )
                                                                        );
                                                                        FocusScope.of(showContext).requestFocus(_joinPasswdFocus);
                                                                      }else{
                                                                        String _realPasswd = snapshot.data!.docs[index].get('password').toString();
                                                                        if(_joinPasswd == _realPasswd){
                                                                          final parentDoc = snapshot.data!.docs[index];
                                                                          final _userInfo = widget.currUser.uid;

                                                                          Navigator.of(showContext).pop();

                                                                          int _currCnt = int.parse(parentDoc.get('currCnt').toString()) + 1;
                                                                          List<dynamic> joinerList = snapshot.data!.docs[index].get('joiner');
                                                                          joinerList.add(_userInfo);
                                                                          await parentDoc.reference.update({
                                                                            'currCnt':_currCnt.toString(),
                                                                            'joiner':joinerList
                                                                          });

                                                                          Navigator.push(context,
                                                                              MaterialPageRoute(
                                                                                builder:(context) =>
                                                                                    ChatScreen(chatId: snapshot.data!.docs[index].id, currUser: widget.currUser),
                                                                              )
                                                                          );

                                                                        }else{
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                content: Text('비밀번호를 확인해주세요.'),
                                                                                backgroundColor: Colors.redAccent,
                                                                              )
                                                                          );
                                                                          FocusScope.of(context).requestFocus(_joinPasswdFocus);
                                                                        }
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                );
                                              }else{
                                                var showContext = context;
                                                showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (showContext) {
                                                    return AlertDialog(
                                                      content: Container(
                                                        height: 85,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: [
                                                            Text('입장 하시겠습니까?'),
                                                            SizedBox(height: 10,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                TextButton(
                                                                    onPressed: (){
                                                                      Navigator.of(showContext).pop();
                                                                    },
                                                                    child: Text('취소',style: TextStyle(fontWeight: FontWeight.bold,),)
                                                                ),
                                                                TextButton(
                                                                    onPressed: () async {
                                                                      final parentDoc = snapshot.data!.docs[index];
                                                                      final _userInfo = widget.currUser.uid;


                                                                      Navigator.of(showContext).pop();

                                                                      int _currCnt = int.parse(parentDoc.get('currCnt').toString()) + 1;
                                                                      List<dynamic> joinerList = snapshot.data!.docs[index].get('joiner');
                                                                      joinerList.add(_userInfo);
                                                                      await parentDoc.reference.update({
                                                                        'currCnt':_currCnt.toString(),
                                                                        'joiner':joinerList
                                                                      });

                                                                      await Navigator.push(context,
                                                                          MaterialPageRoute(
                                                                            builder:(context) =>
                                                                                ChatScreen(chatId: snapshot.data!.docs[index].id,currUser: widget.currUser),
                                                                          )
                                                                      );
                                                                    },
                                                                    child: const Text('확인',style: TextStyle(fontWeight: FontWeight.bold,),)
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Text('참가')
                                        ),
                                      if(_joinChk == true)
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
                    }else{
                      return Container();
                    }

                  }),
                );
              }
          ),
        ),
      ),
    );
  }
}
