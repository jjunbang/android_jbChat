import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.chatId, required this.currUser});
  final String chatId;
  final User currUser;


 @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void deactivate() {
    // 상위 위젯 참조를 사용하지 않도록 해제 작업 수행
    super.deactivate();
  }


  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  var _formkey = GlobalKey<FormState>();

  final db = FirebaseFirestore.instance;

  int _countNewlines(String text) {
    int count = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == '\n') {
        count++;
      }
    }
    return count;
  }

  final TextEditingController _controller = TextEditingController();
  int text_line = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formkey,
        child: Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.orange,
            elevation: 0,
            title: Text('채팅방 제목'),
            actions: [
              IconButton(
                    onPressed: () async{
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (innerContext){
                          return Stack(
                            children: [
                              Positioned(
                                  top: mediaHeight(context,0.05),
                                  left: mediaWidth(context, 0.35),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    height: mediaHeight(context, 0.68),
                                    width: mediaWidth(context, 0.62),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          child: Text('대화상대',style: TextStyle(fontSize: 17, color: Colors.orange, fontWeight: FontWeight.bold),)
                                        ),
                                        Container(
                                          height: mediaHeight(context, 0.53),
                                          width: mediaWidth(context, 0.50),
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            // color: Colors.blue
                                          ),
                                          child: StreamBuilder(
                                            stream: db.collection('chatList').doc(widget.chatId).snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return CircularProgressIndicator(); // 데이터가 없으면 로딩 표시
                                              }

                                              var data = snapshot.data!.data(); // 해당 문서의 데이터 가져오기
                                              List<dynamic> joiners = data!['joiner']; // messages 필드 가져오기
                                              int itemCount = joiners.length; // messages 필드의 길이를 itemCount로 사용

                                              return ListView.builder(
                                                  itemCount: itemCount,
                                                  itemBuilder:  (context, index) {
                                                    return FutureBuilder(
                                                      future: db.collection('userData').doc(joiners[index]).get(),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState ==ConnectionState.done &&snapshot.hasData) {
                                                          final userData = snapshot.data!;
                                                          final data = userData.data()!;
                                                          final userNm = data['userNm'];

                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.all(10),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(Icons.account_circle,color: Colors.orange,),
                                                                    SizedBox(width: 10,),
                                                                    Text(userNm,style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return SizedBox.shrink();
                                                        }
                                                      },
                                                    );
                                                  }
                                              );
                                            }
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: (){},
                                                child: Icon(Icons.settings,color: Colors.orange,)
                                              ),
                                              SizedBox(width: 10,),
                                              GestureDetector(
                                                onTap: (){},
                                                child: Icon(Icons.logout,color: Colors.orange,)
                                              ),
                                            ],
                                          )
                                        )
                                      ],
                                    ),
                                  )
                              )
                            ]
                          );
                        }
                      );
                    },
                    icon: Icon(Icons.density_medium),
                  ),
            ],
          ),
          body: Container(
            height: mediaHeight(context, 1),
            width: mediaWidth(context, 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffff6b6b),
                  Color(0xfffcc419),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Padding(padding: EdgeInsets.only(top: mediaHeight(context, 0.12))),
                  Container(
                    height: mediaHeight(context, 0.813),
                    width: mediaWidth(context, 1),
                    // color: Colors.blueAccent,
                    // padding: EdgeInsets.all(10),
                    child: StreamBuilder(
                      stream: db.collection("chatList")
                          .doc(widget.chatId)
                          .collection('chatData').orderBy('createTime',descending: true).snapshots(),
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        }
                        // return Container();
                        return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context,index){
                            var _data = snapshot.data!;
                            return Container(
                              // color: widget.currUser.uid == _data.docs[index]['sendUid'] ? Colors.red : Colors.blue ,
                              padding: EdgeInsets.fromLTRB(10,10,10,10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: widget.currUser.uid == _data.docs[index]['sendUid'] ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    children: [
                                      Text(_data.docs[index]['sendNm']),
                                      SizedBox(width: 10,),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: widget.currUser.uid == _data.docs[index]['sendUid'] ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    children: [
                                      ChatBubble(
                                        clipper: ChatBubbleClipper1(type: widget.currUser.uid == _data.docs[index]['sendUid'] ? BubbleType.sendBubble : BubbleType.receiverBubble),
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(top: 5),
                                        backGroundColor: widget.currUser.uid == _data.docs[index]['sendUid'] ? Color(0xffffdd00) : Color(0xffc0c0c0),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                                          ),
                                          child: Text(
                                            _data.docs[index]['message'],
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        );
                      },
                    ),
                  ),
                  Container(
                    // height: mediaHeight(context, 0.08),
                    width: mediaWidth(context, 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: text_line == 0? 30.0 : (30.0*text_line),
                            width: mediaWidth(context, 0.13),
                            child: ElevatedButton(
                              onPressed: (){
                                FocusScope.of(context).unfocus();
                              },
                              child: Icon(Icons.add,color: Colors.black,),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                elevation: MaterialStateProperty.all(0),
                                overlayColor: MaterialStateProperty.all(Colors.blue),
                              ),
                            ),
                          ),
                          Container(
                            // height: mediaHeight(context, 0.08),
                            width: mediaWidth(context, 0.74),
                            // color: Colors.blueAccent,
                            child: TextFormField(
                              key: ValueKey('text'),
                              controller: _controller,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '   텍스트 입력',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                )
                                // enabledBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(5),
                                // )
                              ),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              onChanged: (val){
                                int line_count = _countNewlines(val);
                                text_line = line_count;
                              },
                            ),
                          ),
                          Container(
                            height: text_line == 0? 30.0 : (30.0*text_line),
                            width: mediaWidth(context, 0.13),
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                String text = _controller.text;

                                text_line = 0;
                                _controller.clear();

                                if(!text.isEmpty){
                                  var _currTime1 = DateFormat('yyyy-MM-dd a hh:mm:ss').format(DateTime.now());
                                  final userRef = await db.collection("userData").doc(widget.currUser.uid).get();
                                  final userData = userRef.data()!;
                                  final chatData = {
                                    "createTime" : _currTime1,
                                    "message" : text,
                                    "sendNm" : userData['userNm'],
                                    "sendEmail" : userData['userEmail'],
                                    "sendUid" : widget.currUser.uid,
                                  };

                                  await db
                                      .collection("chatList")
                                      .doc(widget.chatId)
                                      .collection("chatData")
                                      .doc().set(chatData);

                                }else{

                                }
                              },
                              child: Icon(Icons.send_rounded,color: Colors.black,),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                elevation: MaterialStateProperty.all(0),
                                overlayColor: MaterialStateProperty.all(Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }
}


// final chatJoinRef = parentDoc.reference.collection('chatJoinUser');
// var _userData = await db.collection('userData').doc(_userInfo).get();
// final chatJoinData = {
//   "userEmail": _userData.get('userEmail'),
//   "userNm" : _userData.get('userNm'),
//   "test" : [1,2.4,3]
// };
// await chatJoinRef.add(chatJoinData);