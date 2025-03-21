class AppValidator {

  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter a Email';
    }
    RegExp emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhoneNumber(value) {
    if (value!.isEmpty) {
      return 'Please enter a PhoneNumber';
    }
    RegExp phoneReg = RegExp(r'^0\d{9}$');
    if (!phoneReg.hasMatch(value)) {
      return 'Phone number must be 10 digits and cannot start with 0';
    }
    return null;
  }

  String? validateUserName(value) {
    if (value!.isEmpty) {
      return 'Please enter a User name';
    }
    return null;
  }

  String? validatePassWord(value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  String? isEmptyCheck(value) {
    if (value!.isEmpty) {
      return 'Please fill details';
    }
    return null;
  }
}