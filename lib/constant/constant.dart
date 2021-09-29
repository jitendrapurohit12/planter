// Image Paths
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmt_planter/helper/ui_helper.dart';

const imageBasePath = 'assets/images';
const kImageTree = '$imageBasePath/tree.svg';
const kimageMap = '$imageBasePath/map.jpeg';
const kImageIcon = '$imageBasePath/logo.svg';
const kImageHome = '$imageBasePath/ic_home.svg';
const kImageMessage = '$imageBasePath/ic_message.svg';
const kImageProject = '$imageBasePath/ic_project.svg';
const kImageFlagId = '$imageBasePath/flag_id.png';
const kImageFlagEn = '$imageBasePath/flag_en.png';
const kImageWatermark = '$imageBasePath/watermark.png';
const kImageHomeInacitve = '$imageBasePath/ic_home_inactive.svg';
const kImageNotification = '$imageBasePath/ic_notification.svg';
const kImageProjectInactive = '$imageBasePath/ic_project_inactive.svg';

// FCM Topics
const kTopicDev = 'planter_dev';
const kTopicProd = 'planter_prod';

// Button Labels
const kButtonSubmit = 'Submit';
const kButtonConfirm = 'Confirm';
const kButtonReject = 'Reject';
const kButtonDeny = 'Deny';
const kButtonYes = 'Yes';
const kButtonNo = 'No';
const kButtonUpdate = 'Update';
const kButtonRetry = 'Retry';
const kButtonLogout = 'Logout';
const kButtonOpenSettings = 'Open Settings';
const kButtonGrantPermission = 'Grant Permission';

// Error Codes
const kErrorUnauthorised = 401;
const kErrorUnauthorisedFund = 400;

// String Constants
const kDonthaveAccount = "Dont't have account? ";
const kSignUp = 'Signup';
const kFemaleEmpTArget = 'Female Employment Target';
const kTargetFundsForPlanning = 'Target funds for Planting';
const kTargetFundsForConservation = 'Target funds for Conservation';
const kFundRaised = 'Funds raised';
const kCommunity = 'Community';
const kPlantingArea = 'Planting Area';
const kDensity = 'Density';
const kTotalTrees = 'Total Trees';

// Errors
const kErrorCameraScreen =
    "App can't take image without Camera and Microphone Permissions. Please grant Permissions from device Settings!";
const kErrorSocket = 'Please check your Internet Connection!';
const kErrorTimeout = 'Request Timeout! Please check your Internet Connection!';

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
const kTitleUpdateApp = 'Update App';

// Dialog Descriptions
const kDescriptionCameraPermissionDenied = 'Enable Camera permission from settings to use the app!';
const kDescriptionMicrohonePermissionDenied =
    'Enable Microphone permission from settings to use the app!';
const kDescriptionUpdateApp =
    'Please update to latest version to continue using the Super Planter App!';

//Regex
const kRegexEmail = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

// formatters
final doubleFormatter = FilteringTextInputFormatter.allow(RegExp("[0-9]"));

// URLs
const kUrlSignup = 'https://grovedev.globalmangrove.org/congrats-funding';

// Array
const kArraySignin = [kDonthaveAccount, kSignUp];
List<BottomNavigationBarItem> kArrayDashboardBottomNavigationItems() => [
      getBottomNavigationBarItem(
        icon: getSvgImage(path: kImageHomeInacitve),
        title: 'Home',
        activeIcon: getSvgImage(path: kImageHome),
      ),
      getBottomNavigationBarItem(
        icon: getSvgImage(path: kImageProjectInactive),
        title: 'Project',
        activeIcon: getSvgImage(path: kImageProject),
      ),
      getBottomNavigationBarItem(
        icon: getSvgImage(path: kImageMessage, width: 20, height: 20),
        title: 'Contact Us',
        activeIcon: getSvgImage(path: kImageMessage, color: Colors.cyan, width: 20, height: 20),
      ),
    ];

// Status
const kStatusAccepted = 'accepted';
const kStatusRejected = 'rejected';
