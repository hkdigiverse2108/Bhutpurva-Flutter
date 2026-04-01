import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/data/models/res/res_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/api_service.dart';
import '../../data/models/address/location_model.dart';

mixin LocationDropdownMixin {
  Future<void> loadCountriesFor(Rx<AddressEntry> rxAddress) async {
    rxAddress.value = rxAddress.value.copyWith(loadingCountries: true);
    try {
      final ResModel res = await ApiService.to.get(
        ApiConstants.location(typeFilter: 'country'),
      );
      if (res.status == 200) {
        final countries = (res.data as List)
            .map((e) => LocationModel.fromJson(e))
            .toList();
        rxAddress.value = rxAddress.value.copyWith(
          countries: countries,
          loadingCountries: false,
        );
      }
    } catch (_) {
      rxAddress.value = rxAddress.value.copyWith(loadingCountries: false);
    }
  }

  Future<void> onCountryChanged(
    Rx<AddressEntry> rxAddress,
    String countryId,
    String countryName,
  ) async {
    var nextState = rxAddress.value.resetStateAndBelow();
    nextState = nextState.copyWith(
      selectedCountryId: countryId,
      selectedCountryName: countryName,
      loadingStates: true,
    );
    rxAddress.value = nextState;

    try {
      final ResModel res = await ApiService.to.get(
        ApiConstants.location(typeFilter: 'state', parentId: countryId),
      );
      if (res.status >= 200 && res.status < 300) {
        final states = (res.data as List)
            .map((e) => LocationModel.fromJson(e))
            .toList();
        rxAddress.value = rxAddress.value.copyWith(
          states: states,
          loadingStates: false,
        );
      }
    } catch (_) {
      rxAddress.value = rxAddress.value.copyWith(loadingStates: false);
    }
  }

  Future<void> onStateChanged(
    Rx<AddressEntry> rxAddress,
    String stateId,
    String stateName,
  ) async {
    var nextState = rxAddress.value.resetDistrictAndBelow();
    nextState = nextState.copyWith(
      selectedStateId: stateId,
      selectedStateName: stateName,
      loadingDistricts: true,
    );
    rxAddress.value = nextState;

    try {
      final ResModel res = await ApiService.to.get(
        ApiConstants.location(typeFilter: 'district', parentId: stateId),
      );
      if (res.status >= 200 && res.status < 300) {
        final districts = (res.data as List)
            .map((e) => LocationModel.fromJson(e))
            .toList();
        rxAddress.value = rxAddress.value.copyWith(
          districts: districts,
          loadingDistricts: false,
        );
      }
    } catch (_) {
      rxAddress.value = rxAddress.value.copyWith(loadingDistricts: false);
    }
  }

  Future<void> onDistrictChanged(
    Rx<AddressEntry> rxAddress,
    String districtId,
    String districtName,
  ) async {
    var nextState = rxAddress.value.resetCity();
    nextState = nextState.copyWith(
      selectedDistrictId: districtId,
      selectedDistrictName: districtName,
      loadingCities: true,
    );
    rxAddress.value = nextState;

    try {
      final ResModel res = await ApiService.to.get(
        ApiConstants.location(typeFilter: 'city', parentId: districtId),
      );
      if (res.status >= 200 && res.status < 300) {
        final cities = (res.data as List)
            .map((e) => LocationModel.fromJson(e))
            .toList();
        rxAddress.value = rxAddress.value.copyWith(
          cities: cities,
          loadingCities: false,
        );
      }
    } catch (_) {
      rxAddress.value = rxAddress.value.copyWith(loadingCities: false);
    }
  }

  void onCityChanged(
    Rx<AddressEntry> rxAddress,
    String cityId,
    String cityName,
  ) {
    rxAddress.value = rxAddress.value.copyWith(
      selectedCityId: cityId,
      selectedCityName: cityName,
    );
  }

  void onAddressChanged(Rx<AddressEntry> rxAddress, String fullAddress) {
    rxAddress.value = rxAddress.value.copyWith(fullAddress: fullAddress);
  }

  void onPincodeChanged(Rx<AddressEntry> rxAddress, String pincode) {
    rxAddress.value = rxAddress.value.copyWith(pincode: pincode);
  }

  Future<void> prefillAddressEntry(
    Rx<AddressEntry> rxAddress, {
    String? savedCountry,
    String? savedState,
    String? savedDistrict,
    String? savedCity,
    String? fullAddress,
    String? pincode,
  }) async {
    rxAddress.value = rxAddress.value.copyWith(
      fullAddress: fullAddress ?? '',
      pincode: pincode ?? '',
    );

    // Fetch Countries
    await loadCountriesFor(rxAddress);
    if (savedCountry == null || savedCountry.isEmpty) return;

    final countryMatch = rxAddress.value.countries.firstWhereOrNull(
      (c) => c.name.toLowerCase() == savedCountry.toLowerCase(),
    );
    if (countryMatch == null) return;

    // Fetch States
    await onCountryChanged(rxAddress, countryMatch.id, countryMatch.name);
    if (savedState == null || savedState.isEmpty) return;

    final stateMatch = rxAddress.value.states.firstWhereOrNull(
      (s) => s.name.toLowerCase() == savedState.toLowerCase(),
    );
    if (stateMatch == null) return;

    // Fetch Districts
    await onStateChanged(rxAddress, stateMatch.id, stateMatch.name);
    if (savedDistrict == null || savedDistrict.isEmpty) return;

    final districtMatch = rxAddress.value.districts.firstWhereOrNull(
      (d) => d.name.toLowerCase() == savedDistrict.toLowerCase(),
    );
    if (districtMatch == null) return;

    // Fetch Cities
    await onDistrictChanged(rxAddress, districtMatch.id, districtMatch.name);
    if (savedCity == null || savedCity.isEmpty) return;

    final cityMatch = rxAddress.value.cities.firstWhereOrNull(
      (c) => c.name.toLowerCase() == savedCity.toLowerCase(),
    );
    if (cityMatch != null) {
      onCityChanged(rxAddress, cityMatch.id, cityMatch.name);
    }
  }
}
