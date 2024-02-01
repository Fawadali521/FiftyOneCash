import 'package:fifty_one_cash/splash-screen.dart';
import 'package:fifty_one_cash/src/modules/auth/SignIn.dart';
import 'package:fifty_one_cash/src/modules/auth/UserSignUpProfileUpdate.dart';
import 'package:fifty_one_cash/src/modules/dashboard/dashboard.dart';
import 'package:fifty_one_cash/src/modules/dashboard/master_pin/SetUpMasterPin.dart';
import 'package:fifty_one_cash/src/modules/privacy/master-pin-enter.dart';
import 'package:fifty_one_cash/src/services/SharedData.dart';
import 'package:fifty_one_cash/src/services/toast-msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';

import 'msg-data.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, this.navigationFromForgetPassword});
  final bool? navigationFromForgetPassword;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool showSplash = true;
  Duration splashDelay = const Duration(milliseconds: 3000);
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      // print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          options: const AuthenticationOptions(
            stickyAuth: true,
          ));
    } on PlatformException catch (e) {
      setState(() {
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  handelAuth(Widget destination) async {
    auth.isDeviceSupported().then((bool isSupported) async {
      setState(() => _supportState =
          isSupported ? _SupportState.supported : _SupportState.unsupported);
      if (_supportState == _SupportState.supported) {
        await _checkBiometrics();
        if (_canCheckBiometrics != null && _canCheckBiometrics == true) {
          await _getAvailableBiometrics();
          if (_availableBiometrics != null &&
              _availableBiometrics!.isNotEmpty) {
            await _authenticate();
            if (_authorized == 'Authorized') {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: destination),
                );
              }
            } else {
              await _authenticate();
              if (_authorized == 'Not Authorized') {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              } else {
                //send to master pin page
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: EnterMasterPin(navigatePage: destination)),
                  );
                }
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            }
          } else {
            //send to master pin page
            if (mounted) {
              Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: EnterMasterPin(navigatePage: destination)),
              );
            }
            ToastMsg().sendErrorMsg(MsgData.unableToCheckBioMatrix);
          }
        } else {
          //send to master pin page
          if (mounted) {
            Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: EnterMasterPin(navigatePage: destination)),
            );
          }
          ToastMsg().sendErrorMsg(MsgData.unableToCheckBioMatrix);
        }
      } else {
        //send to master pin page
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: EnterMasterPin(navigatePage: destination)),
          );
        }
      }
    });
  }

  handelLanding() async {
    String? token = await SharedData.getToken();
    bool? isMasterPinSetted = await SharedData.getMasterPinStatus();
    String? username = await SharedData.getUserName();
    debugPrint("token $token");
    debugPrint("isMasterPinSetted $isMasterPinSetted");
    debugPrint("username $username");
    if (token != null && token.isNotEmpty) {
      Future.delayed(splashDelay).then((value) {
        if (username == null) {
          Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: const UserSignUpProfileUpdate()),
          );
        } else {
          if (isMasterPinSetted == null || isMasterPinSetted == false) {
            Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: const SetUpMasterPin()),
            );
          } else {
            handelAuth(const DashBoard());
          }
        }
      });
    } else {
      Future.delayed(splashDelay).then((value) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child:
                const SignIn(), // Replace SignUp() with your SignIn widget if it's named differently
          ),
        );
      });
    }
  }

  @override
  void initState() {
    handelLanding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
