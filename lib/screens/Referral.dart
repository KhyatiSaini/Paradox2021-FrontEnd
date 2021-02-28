import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paradox/models/user.dart';
import 'package:paradox/providers/referral_provider.dart';
import 'package:paradox/providers/user_provider.dart';
import 'package:paradox/utilities/Toast.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ReferralScreen extends StatefulWidget {
  static String routeName = "/referral-Screen";

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool loader = false;
  TextEditingController referralCodeController = new TextEditingController();

  @override
  void dispose() {
    referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: true).user;
    final availReferral =
        Provider.of<ReferralProvider>(context, listen: true).availReferral;
    print(user.referralAvailed);
    return Scaffold(
      appBar: AppBar(
        title: Text("Referral"),
      ),
      body: Container(
        child: Column(
          children: [
            if (user.referralAvailed == false)
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Avail Referral",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        readOnly: loader,
                        controller: referralCodeController,
                        cursorColor: Colors.amber,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Referral Code',
                          hintText: 'Enter Referral Code',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[700],
                          ),
                          hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[700],
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: new BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: new BorderSide(
                                width: 2, color: Colors.grey[200]),
                          ),
                          suffixIcon: Icon(
                            Icons.screen_share,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (user.referralAvailed == false)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  width: double.infinity,
                  child: MaterialButton(
                      height: 48,
                      color: Colors.blue,
                      onPressed: !loader
                          ? () async {
                              setState(() {
                                loader = true;
                              });
                              print(referralCodeController.text);
                              if (referralCodeController.text == null ||
                                  // ignore: unrelated_type_equality_checks
                                  referralCodeController.text == "") {
                                createToast("Enter Referral Code");
                              } else {
                                final res = await availReferral(
                                    referralCodeController.text, user.uid);
                                if (res == true) {
                                  await Provider.of<UserProvider>(context,
                                          listen: true)
                                      .fetchUserDetails();
                                }
                              }
                              setState(() {
                                loader = false;
                              });
                            }
                          : () {},
                      child: !loader
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Avail Referral Code',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : SpinKitCircle(
                              color: Colors.white,
                            ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white,
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(17.0),
                      )),
                ),
              ),
            if (user.referralAvailed == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "Referral Code Already Availed.",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Share Your Referral Code.",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {},
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            style: BorderStyle.solid,
                            width: 2),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Your Referral Code: " + user.referralCode,
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      )),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 20,
                  child: FittedBox(
                    child: IconButton(
                        icon: Icon(
                          Icons.share,
                          size: 30,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          Share.share(
                              'Download Paradox from https://play.google.com/store/apps/details?id=com.exe.paradoxplay and use my referral code: ${user.referralAvailed} and earn 50 coins.');
                        }),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}