// Image Paths
import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/ui_helper.dart';

const imageBasePath = 'assets/images';
const kimageMap = '$imageBasePath/map.jpeg';
const kImageIcon = '$imageBasePath/logo.svg';
const kImageHome = '$imageBasePath/ic_home.svg';
const kImageMessage = '$imageBasePath/ic_message.svg';
const kImageProject = '$imageBasePath/ic_project.svg';
const kImageFlagId = '$imageBasePath/flag_id.png';
const kImageFlagEn = '$imageBasePath/flag_en.png';
const kImageHomeInacitve = '$imageBasePath/ic_home_inactive.svg';
const kImageNotification = '$imageBasePath/ic_notification.svg';
const kImageMessageInacitve = '$imageBasePath/ic_message_inactive.svg';
const kImageProjectInactive = '$imageBasePath/ic_project_inactive.svg';

// Button Labels
const kButtonSubmit = 'Submit';
const kButtonConfirm = 'Confirm';
const kButtonReject = 'Reject';
const kButtonDeny = 'Deny';
const kButtonOpenSettings = 'Open Settings';
const kButtonGrantPermission = 'Grant Permission';

// Error Codes
const kErrorUnauthorised = 401;

// String Constants
const kDonthaveAccount = "Dont't have account? ";
const kSignUp = 'Signup';
const kFemaleEmpTArget = 'Female Employment Target';
const kTargetFundsForPlanning = 'Target funds for Planning';
const kTargetFundsForConservation = 'Target funds for Conservation';
const kFundRaised = 'Funds raised';
const kCommunity = 'Community';
const kPlantingArea = 'Planting Area';
const kDensity = 'Density';
const kTotalTrees = 'Total Trees';

// Errors
const kErrorCameraScreen =
    "App can't take image without Camera and Microphone Permissions. Please grant Permissions from device Settings!";

//Language Codes
const kLangIn = 'id';
const kLangEn = 'en';
const kCountryIn = '';
const kCountryEn = 'US';

// App Locales
const kLocaleIn = Locale(kLangIn, kCountryIn);
const kLocaleEn = Locale(kLangEn, kCountryEn);

// Hints
const kHintEmail = 'Email';
const kHintPassword = 'Password';

// Colors
const kColorPrimary = Color(0xFF1F4949);
const kColorPrimaryDark = Color(0xFF1F4949);
const kColorTabIndicator = Color(0xFF55B2C8);
const kColorAccent = Color(0xFFD81B60);
const kColorTextfieldBackground = Color(0xFFF5F9FC);
const kColorBottomsheetBackground = Color(0xFFE0E0E0);

// Dialog Titles
const kTitleCameraPermissionDenied = 'Enable Camera Permission';
const kTitleAudioPermissionDenied = 'Enable Microphone Permission';

// Dialog Descriptions
const kDescriptionCameraPermissionDenied = 'Enable Camera permission from settings to use the app!';
const kDescriptionMicrohonePermissionDenied =
    'Enable Microphone permission from settings to use the app!';

//Regex
const kRegexEmail = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

// URLs
const kUrlSignup = 'https://grovedev.globalmangrove.org/congrats-funding';

// Array
const kArraySignin = [kDonthaveAccount, kSignUp];
List<BottomNavigationBarItem> kArrayDashboardBottomNavigationItems({@required double iconSize}) => [
      getBottomNavigationBarItem(
        icon: getSvgImage(
          path: kImageHomeInacitve,
          height: iconSize,
          width: iconSize,
        ),
        title: 'Home',
        activeIcon: getSvgImage(
          path: kImageHome,
          height: iconSize,
          width: iconSize,
        ),
      ),
      getBottomNavigationBarItem(
        icon: getSvgImage(
          path: kImageProjectInactive,
          height: iconSize,
          width: iconSize,
        ),
        title: 'Project',
        activeIcon: getSvgImage(
          path: kImageProject,
          height: iconSize,
          width: iconSize,
        ),
      ),
      // getBottomNavigationBarItem(
      //   icon: getSvgImage(
      //     path: kImageMessageInacitve,
      //     height: iconSize,
      //     width: iconSize,
      //   ),
      //   title: 'Inbox',
      //   activeIcon: getSvgImage(
      //     path: kImageMessage,
      //     height: iconSize,
      //     width: iconSize,
      //   ),
      // ),
      getBottomNavigationBarItem(
        icon: Icon(Icons.message_outlined, color: Colors.grey.shade400, size: iconSize - 4),
        title: 'Inbox',
        activeIcon: Icon(Icons.message_outlined, color: kColorPrimary, size: iconSize - 4),
      ),
    ];
