/// Model customer — dipakai Mitra App (D3).
///
/// Nested `customer` di response §7 role=driver TIDAK menyertakan `id`.
class CustomerModel {
  final String id;
  final String name;
  final String? phoneFormatted;

  const CustomerModel({
    this.id = '',
    required this.name,
    this.phoneFormatted,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneFormatted: json['phone_formatted'] as String?,
    );
  }
}
