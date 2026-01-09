import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:finance_tracker/core/enums/currency.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/abstracts/profiles_repository.dart';
import 'package:finance_tracker/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEntryViewmodel extends ChangeNotifier {
  final ProfilesRepository _profilesRepository;

  ProfileEntryViewmodel(
    this._profilesRepository, {
    Profile? profile,
  }) : _profile = profile;
  SharedPreferences? _prefs;
  LoadingStatus loadingStatus = LoadingStatus.idle;

  Profile? _profile;

  Profile? get profile => _profile;

  List<Profile> _profiles = [];

  int _decimalPoint = 2;

  String _profileName = "";
  String? _nickName;
  Currency? _currency;
  String? _address;
  String? _zip;
  String? _email;
  String? _phone;
  String? _tin;

  String get profileName => _profileName;

  set profileName(String value) {
    _profileName = value;
    notifyListeners();
  }

  String? get nickName => _nickName;

  set nickName(String? value) {
    _nickName = value;
    notifyListeners();
  }

  Currency? get currency => _currency;

  set currency(Currency? value) {
    _currency = value;
    notifyListeners();
  }

  String? get address => _address;

  set address(String? address) {
    _address = address;
    notifyListeners();
  }

  String? get zip => _zip;

  set zip(String? zip) {
    _zip = zip;
    notifyListeners();
  }

  String? get email => _email;

  set email(String? email) {
    _email = email;
    notifyListeners();
  }

  String? get phone => _phone;

  set phone(String? phone) {
    _phone = phone;
    notifyListeners();
  }

  String? get tin => _tin;

  set tin(String? id) {
    _tin = id;
    notifyListeners();
  }

  Future<void> getProfiles() async {
    _profiles = await _profilesRepository.getAll();
    notifyListeners();
  }

  set profile(Profile? profile) {
    if (_profile != null) {
      loadingStatus = LoadingStatus.loading;

      _profileName = _profile!.name;
      _nickName = _profile!.alias;
      _currency = _profile!.currency;
      _address = _profile!.address;
      _zip = _profile!.zip;
      _email = _profile!.email;
      _phone = _profile!.phone;
      _tin = _profile!.tin;

      loadingStatus = LoadingStatus.completed;
      notifyListeners();
    }
  }

  get decimalPoint => _decimalPoint;

  set decimalPoint(value) {
    _decimalPoint = value;
    notifyListeners();
  }

  // Error text variables
  String nameError = "";
  String nickNameError = "";
  String currencyError = "";
  String addressError = "";
  String zipError = "";
  String emailError = "";
  String phoneError = "";

  String errorText = "";

  void init() async {
    try {
      loadingStatus = LoadingStatus.loading;
      notifyListeners();
      _prefs = await SharedPreferences.getInstance();
      profile = _profile;
      getProfiles();
      loadingStatus = LoadingStatus.completed;
      if (_profile == null) {
        getDeviceCurrencyCode();
      }
      notifyListeners();
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
      errorText = 'Error: Failed to initialise profile form';
      loadingStatus = LoadingStatus.error;
      notifyListeners();
    }
  }

  bool _validate() {
    bool isValid = true;
    nameError = "";
    nickNameError = "";
    currencyError = "";
    addressError = "";
    zipError = "";
    emailError = "";
    phoneError = "";

    notifyListeners();

    if (profileName.isEmpty) {
      nameError = "Name cannot be empty";
      isValid = false;
    }
    if (_profile == null &&
        _profiles.where((p) => p.name == _profileName).isNotEmpty) {
      nameError = "Profile name already exist";
      isValid = false;
    }

    if (_currency == null) {
      currencyError = "Choose a currency";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  Future<bool> save() async {
    if (_validate()) {
      loadingStatus = LoadingStatus.submitting;
      notifyListeners();
      if (_profile == null) {
        int newPro = await _profilesRepository.insertProfile(
          name: _profileName,
          alias: _nickName,
          currency: _currency!,
          address: _address,
          zip: _zip,
          email: _email,
          phone: _phone,
          tin: _tin,
        );
        _profile = await _profilesRepository.getById(newPro);
      } else {
        await _profilesRepository.updateProfile(
          id: _profile!.dbID,
          name: _profileName,
          alias: _nickName,
          currency: _currency!,
          address: _address,
          zip: _zip,
          email: _email,
          phone: _phone,
          tin: _tin,
        );
      }

      loadingStatus = LoadingStatus.submitted;
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  void resetErrorText() {
    errorText = "";
    notifyListeners();
  }

  /// Get the device's country code
  String _getDeviceCountryCode() {
    String locale = Platform.localeName; // Example: "en_IN"
    List<String> parts = locale.split('_'); // Splitting "en_IN" -> ["en", "IN"]
    return parts.length > 1 ? parts[1] : "US"; // Default to "US" if missing
  }

  /// Get the currency code from the country code
  void getDeviceCurrencyCode() {
    try {
      String countryCode = _getDeviceCountryCode();
      _currency =
          Currency.values.firstWhereOrNull((c) => c.countryCode == countryCode);
    } catch (e) {
      AppLogger.instance.error('Cannot set default currency  ${e.toString()}');
    }
  }

  Future<void> setLastUpdatedTimeStamp() async {
    try {
      final timeStamp = DateTime.now();
      _prefs?.setInt('lastUpdated', timeStamp.millisecondsSinceEpoch);
    } catch (e) {
      AppLogger.instance
          .error("Error setting Last updated timestamp ${e.toString()}");
    }
  }
}

