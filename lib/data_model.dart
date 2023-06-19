class DataModelPrice {
  String? symbol;
  String? price;
  int? timestamp;

  DataModelPrice({this.symbol, this.price, this.timestamp});

  DataModelPrice.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    price = json['price'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this.symbol;
    data['price'] = this.price;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
