import 'base/base_sku_entity.dart';

///
///记录商品信息
///
///Created by Wongxd on 2020/6/17.
///https://github.com/Wongxd
///wxd1@live.com
///
class ProductModel {
  ///存储所有录入的库存情况
  Map<String, BaseSkuEntity> productStocks = new Map();

  ///记录规格的种类
  List<AttributesEntity> attributes = new List();

  ///存放Sku计算结果
  Map<String, BaseSkuEntity> skuResult;

  /// 当前选择的属性map
  Map<String, AttributeMembersEntity> selectedMap = new Map();

  ///产品名字
  String productStr = '';

  ///价格描述文字
  String priceDesStr = '';

  ///已选规格描述文字
  String get specDesStr {
    StringBuffer sb = StringBuffer();
    selectedMap.forEach((key, value) {
      sb.write(value.name);
      sb.write(' ');
    });
    return sb.toString();
  }

  ///确认按钮能否点击
  bool canSubmit() {
    return selectedMap.keys.length == attributes.length;
  }

  ///是否是同一组合
  bool isSameComb(String oriComb) {
    bool flag = true;

    var combStr = getCombStr();

    if (oriComb == combStr) return true;

    var oriCombItemList = oriComb.split(',');
    var combItemList = combStr.split(',');

    var sameCount = 0;

    oriCombItemList.forEach((oriItem) {
      combItemList.forEach((item) {
        if (oriItem == item) {
          sameCount++;
        }
      });
    });

    flag = sameCount == oriCombItemList.length;

    return flag;
  }

  ///获取组合字符串
  String getCombStr() {
    return selectedMap.values
        .map((e) => e.attributeMemberId.toString())
        .toList()
        .join(',');
  }

  ///获取组合的BaseSkuEntity
  BaseSkuEntity getBaseSkuEntity() {
    return canSubmit() ? skuResult[getCombStr] : '';
  }
}

class AttributesEntity {
  int _id;
  String _name;
  List<AttributeMembersEntity> _attributeMembers = new List();
  AttributeMembersEntity currentSelectedItem;

  bool operator ==(o) {
    return _id == o.id;
  }

  String printStr() {
    return "id=$_id   name=$_name  members=${_attributeMembers.map((e) => e.printStr())}  currentItem={${currentSelectedItem?.printStr()}}";
  }

  AttributesEntity.empty();

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  List<AttributeMembersEntity> get attributeMembers => _attributeMembers;

  set attributeMembers(List<AttributeMembersEntity> value) {
    _attributeMembers = value;
  }
}

class AttributeMembersEntity {
  int _attributeGroupId;
  int _attributeMemberId;
  String _name;
  AttributeMemberStatus _status;

  bool operator ==(o) {
    return _attributeMemberId == o.attributeMemberId;
  }

  String printStr() {
    return "groupId=$_attributeGroupId   mId=$_attributeMemberId  $name  $status";
  }

  AttributeMembersEntity.empty();

  int get attributeGroupId => _attributeGroupId;

  set attributeGroupId(int value) {
    _attributeGroupId = value;
  }

  int get attributeMemberId => _attributeMemberId;

  set attributeMemberId(int value) {
    _attributeMemberId = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  AttributeMemberStatus get status =>
      _status ?? AttributeMemberStatus.CHECKABLE;

  set status(AttributeMemberStatus value) {
    _status = value;
  }
}

enum AttributeMemberStatus { CHECKABLE, CHECKED, UNCHECKABLE }
