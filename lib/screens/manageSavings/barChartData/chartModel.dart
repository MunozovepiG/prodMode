class SavingDataModel {
  String? key;
  String? value;

  SavingDataModel({this.key, this.value});

  factory SavingDataModel.fromJson(Map<String, dynamic> json) {
    return SavingDataModel(
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'key': key,
      'value': value,
    };
    return data;
  }

  @override
  String toString() {
    return 'DataModel{key: $key, value: $value}';
  }
}
