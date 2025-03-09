// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DropdownMenuItems {
  final String lable;
  final String value;

  DropdownMenuItems({required this.lable, required this.value});

  DropdownMenuItems copyWith({String? lable, String? value}) {
    return DropdownMenuItems(
      lable: lable ?? this.lable,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'lable': lable, 'value': value};
  }

  factory DropdownMenuItems.fromMap(Map<String, dynamic> map) {
    return DropdownMenuItems(
      lable: map['lable'] as String,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DropdownMenuItems.fromJson(String source) =>
      DropdownMenuItems.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DropdownMenuItems(lable: $lable, value: $value)';

  @override
  bool operator ==(covariant DropdownMenuItems other) {
    if (identical(this, other)) return true;

    return other.lable == lable && other.value == value;
  }

  @override
  int get hashCode => lable.hashCode ^ value.hashCode;
}
