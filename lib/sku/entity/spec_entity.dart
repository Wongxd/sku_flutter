///
///Created by Wongxd on 2020/6/17.
///https://github.com/Wongxd
///wxd1@live.com
///
class SpecEntity {
  List<SpecAttrEntity> attrs;
  List<SpecCombEntity> combs;

  SpecEntity({this.attrs, this.combs});

  factory SpecEntity.fromJson(Map<String, dynamic> json) {
    return SpecEntity(
      attrs: json['attrs'] != null
          ? (json['attrs'] as List)
              .map((i) => SpecAttrEntity.fromJson(i))
              .toList()
          : null,
      combs: json['combs'] != null
          ? (json['combs'] as List)
              .map((i) => SpecCombEntity.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attrs != null) {
      data['attrs'] = this.attrs.map((v) => v.toJson()).toList();
    }
    if (this.combs != null) {
      data['combs'] = this.combs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecAttrEntity {
  String key; // 尺寸
  List<SpecAttrValueEntity> value;

  SpecAttrEntity({this.key, this.value});

  factory SpecAttrEntity.fromJson(Map<String, dynamic> json) {
    return SpecAttrEntity(
      key: json['key'],
      value: json['value'] != null
          ? (json['value'] as List)
              .map((i) => SpecAttrValueEntity.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    if (this.value != null) {
      data['value'] = this.value.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecAttrValueEntity {
  int id; // 18
  String name; // 10cm
  int ownId; // 14

  SpecAttrValueEntity({this.id, this.name, this.ownId});

  factory SpecAttrValueEntity.fromJson(Map<String, dynamic> json) {
    return SpecAttrValueEntity(
      id: json['id'],
      name: json['name'],
      ownId: json['ownId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ownId'] = this.ownId;
    return data;
  }
}

class SpecCombEntity {
  String comb; // 3,6,24,18
  String desc; // 红色-20KG-江油-10
  int id; // 11
  String price; // 1.0(可抵扣)
  int productId; // 5
  String
      specImg; // http://wx2.sinaimg.cn/mw600/0072bW0Xly1fo8zf0pn15j30ia0tzdox.jpg
  int stock; // 2

  SpecCombEntity(
      {this.comb,
      this.desc,
      this.id,
      this.price,
      this.productId,
      this.specImg,
      this.stock});

  factory SpecCombEntity.fromJson(Map<String, dynamic> json) {
    return SpecCombEntity(
      comb: json['comb'],
      desc: json['desc'],
      id: json['id'],
      price: json['price'],
      productId: json['productId'],
      specImg: json['specImg'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comb'] = this.comb;
    data['desc'] = this.desc;
    data['id'] = this.id;
    data['price'] = this.price;
    data['productId'] = this.productId;
    data['specImg'] = this.specImg;
    data['stock'] = this.stock;
    return data;
  }
}
