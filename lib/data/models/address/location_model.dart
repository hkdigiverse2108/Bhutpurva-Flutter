class LocationModel {
  final String id;
  final String name;
  final String type;
  final String? parentId;

  LocationModel({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      parentId: json['parentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'parentId': parentId,
    };
  }
}

class AddressEntry {
  // We store both the ID for dropdown selection and the Name for submission
  String? selectedCountryId;
  String? selectedStateId;
  String? selectedDistrictId;
  String? selectedCityId;

  String? selectedCountryName;
  String? selectedStateName;
  String? selectedDistrictName;
  String? selectedCityName;

  // Additional fields standard for our address structure
  String fullAddress;
  String pincode;

  // Dropdown lists
  List<LocationModel> countries;
  List<LocationModel> states;
  List<LocationModel> districts;
  List<LocationModel> cities;

  // Loading flags
  bool loadingCountries;
  bool loadingStates;
  bool loadingDistricts;
  bool loadingCities;

  AddressEntry({
    this.selectedCountryId,
    this.selectedStateId,
    this.selectedDistrictId,
    this.selectedCityId,
    this.selectedCountryName,
    this.selectedStateName,
    this.selectedDistrictName,
    this.selectedCityName,
    this.fullAddress = '',
    this.pincode = '',
    this.countries = const [],
    this.states = const [],
    this.districts = const [],
    this.cities = const [],
    this.loadingCountries = false,
    this.loadingStates = false,
    this.loadingDistricts = false,
    this.loadingCities = false,
  });

  AddressEntry copyWith({
    String? selectedCountryId,
    String? selectedStateId,
    String? selectedDistrictId,
    String? selectedCityId,
    String? selectedCountryName,
    String? selectedStateName,
    String? selectedDistrictName,
    String? selectedCityName,
    String? fullAddress,
    String? pincode,
    List<LocationModel>? countries,
    List<LocationModel>? states,
    List<LocationModel>? districts,
    List<LocationModel>? cities,
    bool? loadingCountries,
    bool? loadingStates,
    bool? loadingDistricts,
    bool? loadingCities,
  }) {
    // If a field is explicitly set to empty string via a copy operation where we want to clear it,
    // we must handle that in the UI manually, but here we just do standard copyWith
    return AddressEntry(
      selectedCountryId: selectedCountryId != null && selectedCountryId.isEmpty ? null : selectedCountryId ?? this.selectedCountryId,
      selectedStateId: selectedStateId != null && selectedStateId.isEmpty ? null : selectedStateId ?? this.selectedStateId,
      selectedDistrictId: selectedDistrictId != null && selectedDistrictId.isEmpty ? null : selectedDistrictId ?? this.selectedDistrictId,
      selectedCityId: selectedCityId != null && selectedCityId.isEmpty ? null : selectedCityId ?? this.selectedCityId,
      selectedCountryName: selectedCountryName != null && selectedCountryName.isEmpty ? null : selectedCountryName ?? this.selectedCountryName,
      selectedStateName: selectedStateName != null && selectedStateName.isEmpty ? null : selectedStateName ?? this.selectedStateName,
      selectedDistrictName: selectedDistrictName != null && selectedDistrictName.isEmpty ? null : selectedDistrictName ?? this.selectedDistrictName,
      selectedCityName: selectedCityName != null && selectedCityName.isEmpty ? null : selectedCityName ?? this.selectedCityName,
      fullAddress: fullAddress ?? this.fullAddress,
      pincode: pincode ?? this.pincode,
      countries: countries ?? this.countries,
      states: states ?? this.states,
      districts: districts ?? this.districts,
      cities: cities ?? this.cities,
      loadingCountries: loadingCountries ?? this.loadingCountries,
      loadingStates: loadingStates ?? this.loadingStates,
      loadingDistricts: loadingDistricts ?? this.loadingDistricts,
      loadingCities: loadingCities ?? this.loadingCities,
    );
  }

  // Used for explicitly resetting children to null
  AddressEntry resetStateAndBelow() {
    return copyWith(
      selectedStateId: "",
      selectedStateName: "",
      selectedDistrictId: "",
      selectedDistrictName: "",
      selectedCityId: "",
      selectedCityName: "",
      states: [],
      districts: [],
      cities: [],
    );
  }

  AddressEntry resetDistrictAndBelow() {
    return copyWith(
      selectedDistrictId: "",
      selectedDistrictName: "",
      selectedCityId: "",
      selectedCityName: "",
      districts: [],
      cities: [],
    );
  }

  AddressEntry resetCity() {
    return copyWith(
      selectedCityId: "",
      selectedCityName: "",
      cities: [],
    );
  }
}
