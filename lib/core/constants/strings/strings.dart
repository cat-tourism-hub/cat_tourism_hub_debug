import 'package:flutter/foundation.dart';

String appName = 'Catanduanes Tourism Hub';

class AppStrings {
  const AppStrings._();
  // Use https://cat-tourism-hub-api.onrender.com on server
  // Use http://127.0.0.1:5000 on local
  static const String baseApiUrl = kIsWeb
      ? 'http://127.0.0.1:5000'
      : 'https://cat-tourism-hub-api.onrender.com';
  static const String municipalitUrl =
      'https://psgc.gitlab.io/api/provinces/052000000/municipalities/';
  static const String homepage = 'Homepage';
  static const String home = 'Home';
  static const String termsOfUse = 'Terms of Use';
  static const String privacyPolicy = 'Privacy Policy';
  static const String loginRegister = 'Login/Register';

  static const String appName = 'Catanduanes Tourism Hub';
  static const String accommodationsLong = 'Accommodations to Stay';
  static const String restaurantsLong = 'Restaurants to Dine';
  static const String vehicleRentalsLong = 'Vehicle Rentals';
  static const String delicaciesLong = 'Delicacies to enjoy';
  static const String eventsLong = 'Events to witness';
  static const String others = 'Others';
  static const String pending = 'PENDING';
  static const String tellUsAboutYourBusiness = 'Tell us about your business';
  static const String pleaseSelectBusinessTypePrompt =
      'Please select business type';
  static const String chooseBusinessType = 'Choose a Business Type';
  static const String pleaseSpecify = 'Please specify';
  static const String pleaseSpecifyYourBusinessType =
      'Please specify your business type';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String businessName = 'Business Name';
  static const String enterBusinessNamePrompt = 'Please enter business name.';
  static const String uploadBusinessLogo = 'Upload your business logo';
  static const String uploadImagePrompt = 'Please upload an image';

  static const String accommodations = 'Accommodations';
  static const String restaurants = 'Restaurants';
  static const String hotelAndResto = 'Hotel & Restaurants';
  static const String vehicleRentals = 'Vehicle Rentals';
  static const String delicacies = 'Delicacies';
  static const String events = 'Events';

  static const String partnerDetails = 'Partner\'s Details';
  static const String policies = 'Policies';
  static const String facilitiesAndAmenities = 'Facilities & Amenities';
  static const String headingText = 'Enter heading text';
  static const String subText = 'Enter sub text';

  static const String partnerHeader = 'Partner\'s Basic Information';
  static const String estType = 'Establishment type';
  static const String about = 'About';
  static const String estStatus = 'Establishment Status';
  static const String contactInfo = 'Contact Information';
  static const String phone = 'Phone';
  static const String socmed = 'Social media';
  static const String website = 'Website';
  static const String locInfo = 'Location Information';
  static const String building = 'Building';
  static const String street = 'Street';
  static const String barangay = 'Barangay';
  static const String municipality = 'Municipality';
  static const String legalities = 'Legalities';
  static const String bussPermit = 'Business Permit';
  static const String sanitPerm = 'Sanitation Permit';
  static const String dotCert = 'Department of Tourism Accreditation';

  static const String login = 'Login';
  static const String signin = 'Sign in';
  static const String signup = 'Sign up';
  static const String loginAndRegister = 'Login and Register UI';
  static const String uhOhPageNotFound = 'uh-oh!\nPage not found';
  static const String register = 'Register';

  static const String authenticating = 'Authenticating account...';
  static const String fetching = 'Fetching establishment details...';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String cancel = 'Cancel';
  static const String addField = 'Add field';
  static const String tag = 'Tag';
  static const String seeAll = 'See all';
  static const String room = 'Room';

  static const String clickToAddPhoto = 'Click here to add image.';
  static const String addThumbnail = 'Click to add photos';
  static const String labelReturn = 'Return';
  static const String description = 'Description (Optional)';
  static const String fetchingData = 'Fetching data...';
  static const String category = 'Category';
  static const String amenities = 'Amenities';
  static const String price = 'Price';
  static const String customData = 'Enter custom data';
  static const String included =
      'Included in the price (separate by comma) (Optional)';
  static const String noProducts = 'No products/services available.';
  static const String addOtherServices = 'Add add-ons';
  static const String addOnsServices = 'Add-ons';
  static const String selectDateRange = 'Check-in date - Check-out date';
  static const String availability = 'Availability';
  static const String guests = 'Guests';
  static const String done = 'Done';

  static const String businessAccount = 'Business Account';
  static const String createYourAccount = 'Create your account';
  static const String failedToLoadImage = 'Failed to load image';

  static const String signInToYourNAccount = 'Sign in to your\nAccount';
  static const String signInToYourBusinessAccount =
      'Sign in to your Business Account';
  static const String iHaveAnAccount = 'I have an account?';
  static const String forgotPassword = 'Forgot Password?';
  static const String loggedIn = 'Logged In!';
  static const String registrationComplete = 'Registration Complete!';
  static const String logout = 'Logout';

  static const String name = 'Name';
  static const String pleaseEnterName = 'Please enter name';
  static const String invalidName = 'Invalid Name';

  static const String email = 'Email Address';
  static const String pleaseEnterEmailAddress = 'Please enter email address';
  static const String invalidEmailAddress = 'Invalid Email Address';

  static const String password = 'Password';
  static const String pleaseEnterPassword = 'Please enter password';
  static const String invalidPassword = 'Invalid Password';
  static const String verifyPassword = 'Verify Password';

  static const String error1 = 'Error gathering all the happy places.';
  static const String error2 = 'Error gathering the happy place.';
  static const String errorImage = 'Failed to load image.';

  static const String caption = 'Caption';
  static const String tryAgain = 'Try again';
  static const String captionPrompt = 'Please enter a caption';
  static const String dashboard = 'Dashboard';

  static const String searchTheHappyIsland = 'Search the Happy Island...';
}
