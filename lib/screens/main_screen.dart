import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:jb_chat/screens/chat/list_screen.dart';
import 'package:jb_chat/screens/temp/temp_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  bool isSignUp = false;
  final _formkey = GlobalKey<FormState>();
  String userEmail = '';
  String userPw = '';
  String userNm = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
             children: [
               // div1 바탕화면 영역
               Positioned(
                 child: Container(
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
                 ),
               ),
               // div2 텍스트필드 영역
               Positioned(
                 top: mediaHeight(context, 0.2),
                 left: mediaWidth(context,0.1),
                 child: SingleChildScrollView(
                   child: Container(
                     // color: Colors.red,
                     height: mediaHeight(context, isSignUp? 0.5 : 0.4 ),
                     width: mediaWidth(context, 0.8),
                     // color: Colors.grey,
                     child: Form(
                       key: _formkey,
                       child: Column(
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     isSignUp = false;
                                     _formkey.currentState!.reset();
                                   });
                                 },
                                 child: Text(
                                   'Sign in',
                                   style: TextStyle(
                                     fontFamily: 'kalam',
                                     fontSize: isSignUp? 30 : 40,
                                     color: isSignUp? Colors.black : Colors.white,
                                   ),
                                 ),
                               ),
                               GestureDetector(
                                 onTap: () {
                                   setState((){
                                     isSignUp = true;
                                     _formkey.currentState!.reset();
                                   });
                                 },
                                 child: Text(
                                   'Sign up',
                                   style: TextStyle(
                                     fontFamily: 'kalam',
                                     fontSize: isSignUp? 40 : 30,
                                     color: isSignUp? Colors.white : Colors.black,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(height: 15,),
                           if(!isSignUp)
                             Container(
                               height: 150,
                               // color: Colors.grey,
                               child: SingleChildScrollView(
                                 child: Column(
                                   children: [
                                     TextFormField(
                                       key: ValueKey(1),
                                       keyboardType: TextInputType.emailAddress,
                                       decoration: InputDecoration(
                                         focusedBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.blue
                                           ),
                                         ),
                                         enabledBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.white
                                           ),
                                         ),
                                         labelText: 'User Email',
                                         labelStyle: TextStyle(
                                           fontSize: 16,
                                           color: Colors.white,
                                         ),
                                       ),
                                       validator: (val) {
                                         if(val!.isEmpty || !val.contains('@')){
                                           return '이메일을 확인 해 주세요.';
                                         }
                                         return null;
                                       },
                                       onChanged: (val) {
                                         userEmail = val;
                                       },
                                     ),
                                     SizedBox(height: 15,),
                                     TextFormField(
                                       key: ValueKey(2),
                                       obscureText: true,
                                       decoration: InputDecoration(
                                         focusedBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.blue
                                           ),
                                         ),
                                         enabledBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.white
                                           ),
                                         ),
                                         labelText: 'User Password',
                                         labelStyle: TextStyle(
                                           fontSize: 16,
                                           color: Colors.white,
                                         ),
                                       ),
                                       validator: (val) {
                                         if(val!.isEmpty || val.length < 6){
                                           return '비밀번호를 확인 해 주세요.';
                                         }
                                         return null;
                                       },
                                       onChanged: (val) {
                                         userPw = val;
                                       },
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           if(isSignUp)
                             Container(
                               height: 220,
                               // color: Colors.grey,
                               child: SingleChildScrollView(
                                 child: Column(
                                   children: [
                                     TextFormField(
                                       key: ValueKey(3),
                                       keyboardType: TextInputType.emailAddress,
                                       decoration: InputDecoration(
                                         focusedBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.blue
                                           ),
                                         ),
                                         enabledBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.white
                                           ),
                                         ),
                                         labelText: 'User Email',
                                         labelStyle: TextStyle(
                                           fontSize: 16,
                                           color: Colors.white,
                                         ),
                                       ),
                                       validator: (val) {
                                         if(val!.isEmpty || !val.contains('@')){
                                           return '유효한 메일주소를 입력해주세요';
                                         }
                                         return null;
                                       },
                                       onChanged: (val) {
                                         userEmail = val;
                                       },
                                     ),
                                     SizedBox(height: 15,),
                                     TextFormField(
                                       key: ValueKey(4),
                                       obscureText: true,
                                       decoration: InputDecoration(
                                         focusedBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.blue
                                           ),
                                         ),
                                         enabledBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.white
                                           ),
                                         ),
                                         labelText: 'User Password',
                                         labelStyle: TextStyle(
                                           fontSize: 16,
                                           color: Colors.white,
                                         ),
                                       ),
                                       validator: (val) {
                                         if(val!.isEmpty || val.length < 6){
                                           return '비밀번호는 6자 이상으로 설정해주세요';
                                         }
                                         return null;
                                       },
                                       onChanged: (val) {
                                         userPw = val;
                                       },
                                     ),
                                     SizedBox(height: 15,),
                                     TextFormField(
                                       key: ValueKey(5),
                                       decoration: InputDecoration(
                                         focusedBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.blue
                                           ),
                                         ),
                                         enabledBorder: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Colors.white
                                           ),
                                         ),
                                         labelText: 'User Name',
                                         labelStyle: TextStyle(
                                           fontSize: 16,
                                           color: Colors.white,
                                         ),
                                       ),
                                       onChanged: (val) {
                                         userNm = val;
                                       },
                                       validator: (val){
                                         if(val!.isEmpty || val.length < 3){
                                           return '사용자명은 3자 이상으로 설정해주세요';
                                         }
                                         return null;
                                       },
                                     ),
                                   ],
                                 ),
                               ),
                             ),

                         ],
                       ),
                     ),
                   ),
                 ),
               ),
               // div3 버튼 영역
               Positioned(
                 top: mediaHeight(context, isSignUp? 0.65 : 0.55),
                 left: mediaWidth(context,0.1),
                 child: SingleChildScrollView(
                   child: SizedBox(
                     height: mediaHeight(context, 0.15),
                     width: mediaWidth(context, 0.8),
                     child: Column(
                       children: [
                         if(!isSignUp)
                          Container(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [
                               ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.orange,
                                 ),
                                 onPressed: () async{
                                   try {
                                     if(_formkey.currentState!.validate()){
                                       print('userEmail : $userEmail / userPw : $userPw');

                                       final signinChk = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                           email: userEmail,
                                           password: userPw
                                       );

                                       print('curUser : '+signinChk.toString());

                                       if(signinChk != null){
                                         final currUser = FirebaseAuth.instance.currentUser;
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(builder: (context) => ChatLists(currUser: currUser!),)
                                         );
                                         _formkey.currentState!.reset();
                                       }else{
                                         print('인증 사용자 불일치');

                                       }
                                     }

                                   } on FirebaseAuthException catch (e) {
                                     print('jb : '+e.toString());
                                     if (e.code == 'user-not-found') {
                                       print('No user found for that email.');
                                       ScaffoldMessenger.of(context).showSnackBar(
                                           SnackBar(
                                             content: Text(
                                               '로그인 사용자 정보를 확인해 주세요',
                                               style: TextStyle(
                                                 color: Colors.white,
                                               ),
                                             ),
                                             backgroundColor: Colors.redAccent,
                                           )
                                       );
                                     } else if (e.code == 'wrong-password') {
                                       print('Wrong password provided for that user.');
                                       ScaffoldMessenger.of(context).showSnackBar(
                                           SnackBar(
                                             content: Text(
                                               '로그인 사용자 정보를 확인해 주세요',
                                               style: TextStyle(
                                                 fontSize: 15,
                                                 color: Colors.white,
                                               ),
                                             ),
                                             backgroundColor: Colors.redAccent,
                                           )
                                       );
                                     }
                                   } catch (e){
                                     print('여기를 타는지 확인');
                                   }
                                 },
                                 child: Text(
                                   'Sign in',
                                   style: TextStyle(
                                     // fontFamily: 'kalam',
                                     fontWeight: FontWeight.w400,
                                     fontSize: 17,
                                   ),
                                 ),
                               ),
                               ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.orange,
                                 ),
                                 onPressed: (){

                                 },
                                 child: Text(
                                   'Google Sign in',
                                   style: TextStyle(
                                     // fontFamily: 'kalam',
                                     fontWeight: FontWeight.w400,
                                     fontSize: 17,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                         if(isSignUp)
                          Container(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [
                               ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.orange,
                                 ),
                                 onPressed: () async {
                                   try {
                                     if(_formkey.currentState!.validate()){
                                       final _credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                         email: userEmail,
                                         password: userPw,
                                       );

                                       if(_credential != null){
                                         var _currTime1 = DateFormat('yyyy-MM-dd a hh:mm').format(DateTime.now());

                                         final userData = <String, String>{
                                           "userEmail": userEmail,
                                           "userNm":userNm,
                                           "creatDt":_currTime1,
                                           "changeDt": _currTime1,
                                         };

                                         FirebaseFirestore.instance.collection('userData').doc(_credential.user!.uid).set(userData);

                                         ScaffoldMessenger.of(context).showSnackBar(
                                           SnackBar(
                                             content: Text('사용자 등록이 완료되었습니다.'),
                                             backgroundColor: Colors.blue,
                                           ),
                                         );
                                         setState(() {
                                           isSignUp = false;
                                         });
                                       }
                                     }
                                   } on FirebaseAuthException catch (e) {
                                     if (e.code == 'weak-password') {
                                       print('The password provided is too weak.');
                                     } else if (e.code == 'email-already-in-use') {
                                       print('The account already exists for that email.');
                                     }
                                   } catch (e) {
                                     print(e);
                                   }
                                },
                               child: Text(
                                 'Sign up',
                                 style: TextStyle(
                                   // fontFamily: 'kalam',
                                   fontWeight: FontWeight.w400,
                                   fontSize: 17,
                                 ),
                               )
                               ),
                               ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.orange,
                                 ),
                                 onPressed: (){

                                 },
                                 child: Text(
                                   'Google Sign up',
                                   style: TextStyle(
                                     // fontFamily: 'kalam',
                                     fontWeight: FontWeight.w400,
                                     fontSize: 17,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         )
                       ],
                     ),
                   ),
                 )
               )
             ],
            ),
        ),
    );
  }
}
