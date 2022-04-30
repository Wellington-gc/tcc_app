import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:telephony/telephony.dart';

String username = 'wellingtonalves0103@gmail.com';
String password = 'vexcbywurzananvf';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 10;
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  Future<void> onEnd() async {
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Wellington Alves')
      ..recipients.add(const Address('arthurdourado01@hotmail.com'))
      ..subject = 'Fall Detected - I am dying!!! :: 😀 :: ${DateTime.now()}'
      ..html =
          '<h1>Fall Detected!!!!</h1>\n<p>Hey! I am dying here, come save me!</p>';

    await send(message, smtpServer);

    telephony.sendSms(
      to: "+5562994576141",
      message: "Fall detected!!!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: SizedBox(
              width: 325,
              height: 450,
              child: Center(
                child: CountdownTimer(
                  controller: controller,
                  onEnd: onEnd,
                  endTime: endTime,
                  widgetBuilder: (context, CurrentRemainingTime? time) {
                    return Container(
                      width: 325,
                      height: 325,
                      decoration: const ShapeDecoration(
                        color: Colors.black12,
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.red,
                            style: BorderStyle.solid,
                            width: 10,
                          ),
                        ),
                      ),
                      child: Center(
                        child: DefaultTextStyle(
                          style: const TextStyle(fontSize: 70),
                          child: time == null
                              ? const Text(
                                  'Alerta Enviado',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 50),
                                )
                              : Text(
                                  "${time.min ?? '00'}:${time.sec! >= 10 ? time.sec : '0' + time.sec.toString()}",
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                fixedSize: const Size(250, 75),
              ),
              onPressed: () {
                controller.disposeTimer();

                SystemNavigator.pop();
              },
              child: const Text(
                'Dispensar',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
