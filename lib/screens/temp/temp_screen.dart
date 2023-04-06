import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class tempScreen extends StatefulWidget {
  tempScreen(this.flag,{Key? key}) : super(key: key);

  final String flag;

  @override
  State<tempScreen> createState() => _tempScreenState(flag);
}

class _tempScreenState extends State<tempScreen> {
  _tempScreenState(this._flag,{Key? key});

  String _flag;

  @override
  // TODO: implement context
  BuildContext get context => super.context;

  void test() async {
    final user = FirebaseAuth.instance.currentUser;

    print('user : http://www.example.com/verify?email=${user?.email} / '+user.toString());
    final actionCodeSettings = ActionCodeSettings(
      url: "http://www.example.com/verify?email=${user?.email}",
      iOSBundleId: "com.example.ios",
      androidPackageName: "com.example.android",
    );

    await user?.sendEmailVerification(actionCodeSettings);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('flag : $_flag');
    if(_flag == 'signin'){
      test();
    }
    print('test2222');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트 템플릿'),
      ),
      body: Center(
        child: Text(
            _flag
        ),
      ),
    );
  }
}




