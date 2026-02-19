class AddressModel {
  final String addressType;
  final String fullAddress;
  final String city;
  final String district;
  final String state;
  final String pincode;
  final String country;

  AddressModel({
    this.addressType = 'not Selected',
    this.fullAddress = '',
    this.city = '',
    this.district = '',
    this.state = '',
    this.pincode = '',
    this.country = '',
  });

  AddressModel copyWith({
    String? addressType,
    String? fullAddress,
    String? city,
    String? district,
    String? state,
    String? pincode,
    String? country,
  }) {
    return AddressModel(
      addressType: addressType ?? this.addressType,
      fullAddress: fullAddress ?? this.fullAddress,
      city: city ?? this.city,
      district: district ?? this.district,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      country: country ?? this.country,
    );
  }
}
