import 'package:fashion_fusion/core/utils/app_service.dart';
import 'package:fashion_fusion/core/utils/helper_method.dart';
import 'package:fashion_fusion/core/utils/helper_validation.dart';
import 'package:fashion_fusion/core/widgets/custom_text_field.dart';
import 'package:fashion_fusion/data/auth/model/login_model.dart';
import 'package:fashion_fusion/data/auth/model/set_password.dart';
import 'package:fashion_fusion/data/profile/model/profile_model.dart';
import 'package:fashion_fusion/data/profile/model/upload_profile_model.dart';
import 'package:fashion_fusion/provider/auth/auth_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile/profile_cubit.dart';
import 'package:fashion_fusion/provider/profile_cubit/profile_edit/profile_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fashion_fusion/core/utils/app_colors.dart';

class ProfileSettings extends StatefulWidget {
  final ProfileModel profile;
  const ProfileSettings({super.key, required this.profile});

  @override
  State<ProfileSettings> createState() => _ProfileSettings();
}

class _ProfileSettings extends State<ProfileSettings> {
  late ProfileModel profile;

  Future<void> _fetchProfile() async {
    setState(() {
      context
          .read<ProfileCubit>()
          .getProfile(sl<SharedPreferences>().getString("userID")!);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileEditCubit>(
      create: (context) => sl<ProfileEditCubit>(),
      child: HelperMethod.loader(
        child: Scaffold(
          appBar: AppBar(title: const Text("Settings",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),),
          body: SafeArea(
            bottom: false,
            child: _buildBody()
          )
          // Padding(
          //   padding: const EdgeInsets.all(20),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Padding(
          //         padding: EdgeInsets.only(bottom: 8),
          //         child: Text("Settings",
          //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          //       ),
          //       const Text("Personal Information", style: TextStyle(fontWeight: FontWeight.bold)),
                
          //       InfoCards(cardTitle: "Name", cardContent: "${widget.profile.firstName} ${widget.profile.lastName}", email: widget.profile.email!,),
          //       InfoCards(cardTitle: "Email", cardContent: widget.profile.email!, email: widget.profile.email!),
          //       // TODO
          //       //InfoCards(cardTitle: "Password", cardContent: "", email: widget.profile.email!),
          //       //InfoCards(cardTitle: "Address", cardContent: widget.profile.address!),
          //       InfoCards(cardTitle: "Mobile Number", cardContent: widget.profile.telephoneNumber!, email: widget.profile.email!),
          //     ],
          //   ),
          // )
        ),
      )
    );
  }

  Widget _buildBody() {
    return Center(
      child: BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
        if (state is ProfileLoadedState) {
          profile = state.model!;
          debugPrint("Profile LOADED");
          return _buildSettingsBody();
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              _fetchProfile();
            },
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
    );
  }

  Widget _buildSettingsBody() {
    return RefreshIndicator(
        onRefresh: () async {
          _fetchProfile();
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              10.verticalSpace,
              const Text("Personal Information",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              InfoCards(
                cardTitle: "Name",
                cardContent: "${profile.firstName} ${profile.lastName}",
                email: profile.email!,
              ),
              InfoCards(
                  cardTitle: "Email",
                  cardContent: widget.profile.email!,
                  email: profile.email!),
              // TODO
              //InfoCards(cardTitle: "Address", cardContent: widget.profile.address!),
              InfoCards(
                  cardTitle: "Mobile Number",
                  cardContent: profile.telephoneNumber!,
                  email: profile.email!),
            ],
          ),
        ));
  }
}

class InfoCards extends StatelessWidget {
  final String cardTitle;
  final String cardContent;
  final String email;
  final _editCtrl1 = TextEditingController();
  final _editCtrl2 = TextEditingController();
  final _editCtrl3 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  InfoCards(
      {super.key,
      required this.cardTitle,
      required this.cardContent,
      required this.email});

  void onSaveButtonPressed(BuildContext context, BuildContext context2) {
    if (cardTitle == "Name") {
      context.read<ProfileEditCubit>().updateProfile(
          UploadProfileModel(dictionary: 'last_name', newData: _editCtrl2.text),
          sl<SharedPreferences>().getString("userID")!);
    } else if (cardTitle == "Password") {
      context.read<AuthCubit>().setPassword(SetPasswordModel(
          oldPassword: _editCtrl1.text, password: _editCtrl2.text));
    } else {
      debugPrint("Email or mobile number updated");
      context.read<ProfileEditCubit>().updateProfile(
          UploadProfileModel(
              dictionary: cardTitle == "Email" ? 'email' : 'telephone_number',
              newData: _editCtrl1.text),
          sl<SharedPreferences>().getString("userID")!);
    }
    Navigator.pop(context2);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Info successfully updated!"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (cardTitle == "Name") {
      _editCtrl1.text = cardContent.split(' ')[0];
      _editCtrl2.text = cardContent.split(' ')[1];
    } else {
      _editCtrl1.text = cardContent;
    }

    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: AppColors.bg,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cardTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 5.0),
                Text(cardContent, style: const TextStyle(fontSize: 15))
              ],
            ),
            const Expanded(child: Spacer()),
            Card(
              color: AppColors.bg,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.black, width: 1.0)),
              child: InkWell(
                splashColor: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  _showModalBottomSheet(context);
                  debugPrint('Edit $cardTitle Pressed');
                },
                child: const SizedBox(
                    width: 80,
                    height: 40,
                    child: Center(
                      child: Text(
                        'Edit',
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showModalBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context1) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: cardTitle == "Password" ? 500 : 400,
            ),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "$cardTitle Change",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, left: 20.0, right: 20.0, bottom: 40.0),
                      child: cardTitle == "Name"
                          ? Column(
                              children: [
                                CustomTextField(
                                  label: "First Name",
                                  hint: "",
                                  ctrl: _editCtrl1,
                                  validator: (p0) =>
                                      ValidationHelper.firstNameValidation(p0),
                                ),
                                10.verticalSpace,
                                CustomTextField(
                                  label: "Last Name",
                                  hint: "",
                                  ctrl: _editCtrl2,
                                  validator: (p0) =>
                                      ValidationHelper.secondNameValidation(p0),
                                ),
                              ],
                            )
                          : cardTitle == "Email"
                              ? CustomTextField(
                                  label: "Email",
                                  hint: "",
                                  ctrl: _editCtrl1,
                                  validator: (p0) =>
                                      ValidationHelper.emailValidation(p0),
                                )
                              : CustomTextField(
                                  label: "Mobile Number",
                                  hint: "",
                                  ctrl: _editCtrl1,
                                  validator: (p0) =>
                                      ValidationHelper.phoneNumberValidation(
                                          p0),
                                ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(300, 50)),
                        onPressed: () {
                          if (cardTitle != "Password") {
                            _editCtrl3.text = " ";
                            if (cardTitle != "Name") {
                              _editCtrl2.text = " ";
                            }
                          }
                          debugPrint("Save Pressed");
                          if (_formKey.currentState!.validate()) {
                            debugPrint("valid");
                            showDialog(
                                context: context,
                                builder: (BuildContext context2) {
                                  return AlertDialog(
                                    title: const Text("Are you sure?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context2);
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () => {
                                                onSaveButtonPressed(
                                                    context, context2)
                                              },
                                          child: const Text("Yes"))
                                    ],
                                  );
                                });
                            Navigator.pop(context1);
                            //context.pushNamedAndRemoveUntil(Routes.mainScren);
                          }
                        },
                        child: Text(
                          "Save $cardTitle",
                          style: const TextStyle(fontSize: 18.0),
                        )),
                    const Spacer()
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Widget _buildChangePassword(BuildContext context) {
  //   return Form(
  //     key: _formKey,
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           CustomTextField(
  //             label: "Old Password",
  //             hint: "",
  //             ctrl: _editCtrl1,
  //             validator: (p0) => ValidationHelper.passwordValidation(p0),
  //           ),
  //           10.verticalSpace,
  //           CustomTextField(
  //             label: "New Password",
  //             hint: "",
  //             ctrl: _editCtrl2,
  //             validator: (p0) => ValidationHelper.passwordNewValidation(p0, _editCtrl1.text),
  //           ),
  //           10.verticalSpace,
  //           CustomTextField(
  //             label: "Repeat New Password",
  //             hint: "",
  //             ctrl: _editCtrl3,
  //             validator: (p0) => ValidationHelper.passwordMatchValidation(p0, _editCtrl2.text),
  //           ),
  //         ],
  //       ),
  //     )
  //   );
  // }
}
