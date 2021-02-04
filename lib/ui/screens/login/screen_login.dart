import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/login_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/style/decorations.dart';
import 'package:gmt_planter/ui/common_widget/clikable_text.dart';
import 'package:gmt_planter/ui/common_widget/custom_button.dart';
import 'package:gmt_planter/ui/common_widget/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenLogin extends HookWidget {
  static const id = 'login';
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _emailNode = useFocusNode();
    final _passwordNode = useFocusNode();
    SizedBox divider({double multiplier = 1.0}) =>
        SizedBox(height: context.percentHeight * 3 * multiplier);
    String _email, _password;

    Widget _button({@required LoginController controller}) => CustomButton(
          callback: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              controller.login(
                context: context,
                email: _email,
                password: _password,
              );
            }
          },
          title: kButtonSubmit,
        );

    return Scaffold(
      backgroundColor: kColorPrimary,
      body: Column(
        children: [
          divider(multiplier: 4),
          getSvgImage(
            path: kImageIcon,
            width: context.percentWidth * 12,
            height: context.percentHeight * 5,
          ),
          divider(multiplier: 4),
          Expanded(
            child: Container(
              width: double.maxFinite,
              decoration: loginDecoration(
                color: Colors.white,
                radius: 32,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.percentWidth * 6),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      divider(multiplier: 3),
                      CustomTextFormField(
                        context: context,
                        hint: kHintEmail,
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.emailAddress,
                        leadingIcon: const Icon(Icons.email_outlined),
                        onSave: (s) => _email = s,
                        myNode: _emailNode,
                        nextNode: _passwordNode,
                      ),
                      divider(),
                      Consumer<LoginController>(builder: (_, value, __) {
                        final icon = value.showPassowrd
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off);
                        return CustomTextFormField(
                          context: context,
                          hint: kHintPassword,
                          hide: !value.showPassowrd,
                          leadingIcon: const Icon(Icons.lock_open_outlined),
                          inputAction: TextInputAction.done,
                          onSave: (s) => _password = s,
                          myNode: _passwordNode,
                          suffixIcon: GestureDetector(
                            onTap: () => value.changeVisibility(),
                            child: icon,
                          ),
                        );
                      }),
                      divider(multiplier: 2),
                      // ignore: missing_return
                      Consumer<LoginController>(builder: (_, value, __) {
                        switch (value.state) {
                          case NotifierState.initial:
                            return _button(controller: value);
                          case NotifierState.fetching:
                            return getPlatformProgress();
                          case NotifierState.loaded:
                            saveToken(value: value.model.data.token);
                            performAfterDelay(
                              callback: () => launchDashboard(context: context),
                            );
                            return Container();
                          case NotifierState.noData:
                            return _button(controller: value);
                          case NotifierState.error:
                            performAfterDelay(
                              callback: () => showSnackbar(
                                context: context,
                                message: value.error.message,
                              ),
                            );
                            return _button(controller: value);
                        }
                      }),
                      divider(),
                      ClikableText(
                        texts: kArraySignin,
                        callback: (text, index) => launch(kUrlSignup),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
