import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jb_chat/screens/chat/list_screen.dart';

class FormScreen extends StatefulWidget {
  final User curUser;

  FormScreen({required this.curUser});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }

  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  final db = FirebaseFirestore.instance;

  var _formkey = GlobalKey<FormState>();
  bool _isLock = false;

  String? _chatTitle;
  String? _chatPasswd;
  String? _chatInfo;
  String? _chatTotal;

  final _chatTitleFocus = FocusNode();
  final _chatPasswdFocus = FocusNode();
  final _chatInfoFocus = FocusNode();
  final _chatTotalFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              width: mediaWidth(context,1),
              height: mediaHeight(context,1),
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
              child: Opacity(
                opacity: 0.9,
                child: FittedBox(
                  fit: BoxFit.none,
                  // color: Colors.red,
                  // height: _isLock ? mediaHeight(context, 0.7) : mediaHeight(context, 0.55),
                  // width: mediaWidth(context, 0.9),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white
                    ),
                    padding: EdgeInsets.all(10),
                    height: _isLock ? mediaHeight(context, 0.64) : mediaHeight(context, 0.53),
                    width: mediaWidth(context, 0.90),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // color: Colors.red,
                                width: mediaWidth(context, 0.55),
                                child: TextFormField(
                                  key: ValueKey('chatTitle'),
                                  focusNode: _chatTitleFocus,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.orange
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black26
                                      ),
                                    ),
                                    labelText: '채팅방 제목',
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  validator: (val){
                                    if(val!.isEmpty || val == null){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('제목을 입력해 주세요'),
                                          backgroundColor: Colors.redAccent,
                                          duration: Duration(seconds: 1),
                                        )
                                      );
                                      FocusScope.of(context).requestFocus(_chatTitleFocus);
                                      return '';
                                    }
                                    return null;
                                  },
                                  onSaved: (val){
                                    setState(() {
                                      _chatTitle = val;
                                    });
                                  },
                                  onFieldSubmitted: (val){
                                    print('_isLock : '+_isLock.toString());
                                    if(_isLock){
                                      FocusScope.of(context).requestFocus(_chatPasswdFocus);
                                    }else{
                                      FocusScope.of(context).requestFocus(_chatInfoFocus);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 10,),
                              AnimatedToggleSwitch.dual(
                                current: _isLock,
                                first: true,
                                second: false,
                                dif: 10.0,
                                borderColor: Colors.transparent,
                                borderWidth: 5.0,
                                height: 40,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                  ),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    _isLock = val;
                                    _chatPasswd = '';
                                  });
                                },
                                iconBuilder: (val){
                                  if(val){
                                    return Icon(Icons.lock);
                                  }else{
                                    return Icon(Icons.lock_open);
                                  }
                                },
                                textBuilder: (val){
                                  if(val){
                                    return Center(child: Text('비공개'));
                                  }else{
                                    return Center(child: Text('공개'));
                                  }
                                },
                              ),
                            ],
                          ),
                          if(_isLock)
                            SizedBox(height: 10,),
                          if(_isLock)
                            TextFormField(
                              key: ValueKey('chatPasswd'),
                              focusNode: _chatPasswdFocus,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black26
                                  ),
                                ),
                                labelText: '비밀번호',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38,
                                ),
                              ),
                              validator: (val){
                                if(_isLock){
                                  if(val == null || val.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('비밀번호를 입력해 주세요'),
                                        backgroundColor: Colors.redAccent,
                                        duration: Duration(seconds: 1),
                                      )
                                    );
                                    return '';
                                  }else{
                                    if(val.length < 4){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('암호는 4자리 이상 설정해주세요'),
                                            backgroundColor: Colors.redAccent,
                                            duration: Duration(seconds: 1),
                                          )
                                      );
                                      return '';
                                    }
                                  }
                                }
                                return null;
                              },
                              onSaved: (val){
                                setState(() {
                                  _chatPasswd = val;
                                });
                              },
                              onFieldSubmitted: (val){
                                FocusScope.of(context).requestFocus(_chatInfoFocus);
                              },
                            ),
                          SizedBox(height: 10,),
                          TextFormField(
                            key: ValueKey('chatInfo'),
                            maxLines: 8,
                            focusNode: _chatInfoFocus,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orange
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26
                                ),
                              ),
                              labelText: '채팅방 설명',
                              labelStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black38,
                              ),
                            ),
                            onSaved: (val){
                              setState(() {
                                _chatInfo = val;
                              });
                            },
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                width: 100,
                                child: TextFormField(
                                  key: ValueKey('chatTotal'),
                                  keyboardType: TextInputType.number,
                                  focusNode: _chatTotalFocus,
                                  inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow:true), ],
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.orange
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black26
                                      ),
                                    ),
                                    labelText: '최대 인원',
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  validator: (val){
                                    if(val!.isEmpty || val == null){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('최대 인원을 설정해 주세요'),
                                            backgroundColor: Colors.redAccent,
                                            duration: Duration(seconds: 1),
                                          )
                                      );
                                      FocusScope.of(context).requestFocus(_chatTotalFocus);
                                      return '';
                                    }else{
                                      if(int.parse(val) > 200){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('최대 인원수는 200명 입니다'),
                                              backgroundColor: Colors.redAccent,
                                              duration: Duration(seconds: 1),
                                            )
                                        );
                                        FocusScope.of(context).requestFocus(_chatTotalFocus);
                                        return '';
                                      }
                                    }
                                    return null;
                                  },
                                  onChanged: (val){
                                    if(!val.isEmpty){
                                      if(int.parse(val) > 200){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('최대 인원수는 200명 입니다'),
                                              backgroundColor: Colors.redAccent,
                                              duration: Duration(seconds: 1),
                                            )
                                        );
                                      }
                                    }
                                  },
                                  onSaved: (val){
                                    _chatTotal = val;
                                  },
                                ),
                              ),
                              SizedBox(width: 75,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(25,19,25,19),
                                  backgroundColor: Colors.orangeAccent,
                                ),
                                onPressed: () async {
                                  if(_formkey.currentState!.validate()){
                                    var _currTime1 = DateFormat('yyyy-MM-dd a hh:mm:ss').format(DateTime.now());
                                    _formkey.currentState!.save();

                                    final roomData = {
                                      "title": _chatTitle!,
                                      "currCnt": "1",
                                      "isLock":_isLock.toString(),
                                      "password":_isLock? _chatPasswd! : "",
                                      "totalCnt": _chatTotal!,
                                      "infomation": _chatInfo!,
                                      "recentChatTime": _currTime1,
                                      "creatId" : widget.curUser.email,
                                      "createTime" : _currTime1,
                                      "joiner" : [widget.curUser.uid]
                                    };

                                    await db
                                        .collection("chatList")
                                        .doc().set(roomData);

                                    Navigator.pop(context);
                                  }

                                },
                                child: Text(
                                  '생성',
                                  style: TextStyle(
                                    // fontFamily: 'kalam',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(25,19,25,19),
                                  backgroundColor: Colors.orangeAccent,
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  '취소',
                                  style: TextStyle(
                                    // fontFamily: 'kalam',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
