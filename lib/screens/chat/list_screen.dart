import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jb_chat/model/list_model.dart';
import 'package:jb_chat/model/page_model.dart';
import 'package:jb_chat/screens/chat/entry_list.dart';
import 'package:jb_chat/screens/chat/exit_list.dart';
import 'package:jb_chat/screens/chat/form_screen.dart';
import 'package:provider/provider.dart';

class ChatLists extends StatefulWidget{

  ChatLists({required this.currUser});
  final User currUser;

  @override
  State<ChatLists> createState() => _ChatListsState();
}

class _ChatListsState extends State<ChatLists>{

  // index가 0인 페이지 먼저 보여줌
  final PageController pageController = PageController(
    initialPage: 0,
  );

  int _currentPage = 0;



  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PageModel(pageInfo: 0),
      builder: (context, child) =>
      Scaffold(
        body: SafeArea(
          child: Container(
            // height: mediaHeight(context, 1),
            // width: mediaWidth(context, 1),
            color: Colors.white,
            // padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.orange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Container(
                              // color: Colors.red,
                              width: 100,
                              child: Center(
                                  child: TextButton(
                                      onPressed: (){
                                        pageController.animateToPage(
                                          0,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: Text('채팅방',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Provider.of<PageModel>(context).pageInfo == 0? Colors.white : Colors.black,
                                            fontWeight: Provider.of<PageModel>(context).pageInfo == 0? FontWeight.bold : FontWeight.normal,
                                        ),
                                      )
                                  )
                              )
                          )
                      ),
                      Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Container(
                              // color: Colors.grey,
                              width: 100,
                              child: Center(
                                  child: TextButton(
                                    onPressed: (){
                                      pageController.animateToPage(
                                        1,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Text('참여중',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Provider.of<PageModel>(context).pageInfo == 1? Colors.white : Colors.black,
                                            fontWeight: Provider.of<PageModel>(context).pageInfo == 1? FontWeight.bold : FontWeight.normal,
                                        ),
                                    )
                                  )
                              )
                          )
                      ),
                      Container(
                        // color: Colors.blue,
                        child: Row(
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(Size(10, 10)),
                                // backgroundColor: MaterialStateProperty.all(Colors.red),
                              ),
                              onPressed: ()  {
                                print('search');
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.black),
                                ],
                              ),
                            ),
                            TextButton(
                              style:  ButtonStyle(
                                minimumSize: MaterialStateProperty.all(Size(10, 10)),
                                // backgroundColor: MaterialStateProperty.all(Colors.red),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context){
                                      return FormScreen(curUser: widget.currUser,);
                                    })
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.maps_ugc_outlined, color: Colors.black),
                                ],
                              ),
                            ),
                            TextButton(
                              style:  ButtonStyle(
                                minimumSize: MaterialStateProperty.all(Size(10, 10)),
                                // backgroundColor: MaterialStateProperty.all(Colors.red),
                              ),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.black),
                                ],
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                        controller: pageController, // PageController 연결
                        onPageChanged: (index){
                          Provider.of<PageModel>(context, listen: false).changePageinfo(index);
                        },
                        children: [
                          ExitLists(currUser: widget.currUser),
                          EntryLists(currUser: widget.currUser),
                        ]
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
