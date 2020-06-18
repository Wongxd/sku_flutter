import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sku_flutter_example/sku/base/base_sku_entity.dart';
import 'package:sku_flutter_example/sku/base/sku.dart';
import 'package:sku_flutter_example/sku/product_model.dart';

import 'entity/spec_entity.dart';
import 'product_model.dart';

typedef TipShowProvider(BuildContext context, String tip);

///
/// 仿 淘宝  京东  拼多多 商品规格选择
///
///Created by Wongxd on 2020/6/17.
///https://github.com/Wongxd
///wxd1@live.com
///
class SpecBottomLayout extends StatefulWidget {
  final double _height;
  final SpecEntity _specEntity;
  final String defDes;
  final String defImg;
  final String defNoStockTip;

  final TipShowProvider tipShowProvider;

  SpecBottomLayout(this._height, this._specEntity,
      {this.defDes = '',
      this.defImg = 'http://1.jpg',
      this.defNoStockTip = '该规格无库存',
      this.tipShowProvider});

  static show(BuildContext context, SpecEntity specEntity,
      {double height, TipShowProvider tipShowProvider}) {
    double h;
    try {
      h = height ?? MediaQuery.of(context).size.height * 0.9;
    } catch (e) {
      print(e);
    }

    h ??= 300.0;

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (context) {
          return SpecBottomLayout(
            h,
            specEntity,
            tipShowProvider: tipShowProvider,
          );
        });
  }

  @override
  State<StatefulWidget> createState() {
    return _SpecBottomLayoutState();
  }
}

class _SpecBottomLayoutState extends State<SpecBottomLayout> {
  String noStockTip = '';
  ProductModel _productModel;
  SpecCombEntity _checkedCombsEntity;

  @override
  void initState() {
    super.initState();
    noStockTip = widget.defNoStockTip;
    _initData(widget._specEntity);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => checkedColor = Theme.of(context).primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    //获取comb
    _checkedCombsEntity = null;
    widget._specEntity.combs.forEach((element) {
//      print('el.comb=${element.comb}  combStr=${_productModel.getCombStr()} ');
      if (_productModel.isSameComb(element.comb)) {
        _checkedCombsEntity = element;
      }
    });

    return Container(
      height: widget._height,
      child: Column(
        children: [
          Row(
            children: [
              SizedOverflowBox(
                size: Size(100, 60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    _checkedCombsEntity?.specImg ?? widget.defImg,
                    width: 90,
                    height: 90,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(_checkedCombsEntity?.desc ?? widget.defDes),
                    Text(_checkedCombsEntity?.price ?? ''),
                    Text(_checkedCombsEntity?.stock?.toString() ?? ''),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: _buildSpec(context),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: RawMaterialButton(
              fillColor:
                  _productModel.canSubmit() ? checkedColor : unCheckableColor,
              onPressed: () {
                if (!_productModel.canSubmit()) {
                  widget.tipShowProvider?.call(context, noStockTip);
                  print(noStockTip);
                } else {
                  widget.tipShowProvider?.call(context, '确定');
                  print('确定');
                }
              },
              child: Text(
                '确定',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 初始化展示的数据
  void _initData(SpecEntity bean) {
    List<SpecAttrEntity> attrs = bean.attrs;

    List<AttributesEntity> pAttr = new List();
    int groupId = 0;
    for (SpecAttrEntity attr in attrs) {
      AttributesEntity group = new AttributesEntity.empty();
      group
        ..name = attr.key
        ..id = groupId;
      for (SpecAttrValueEntity item in attr.value) {
        group.attributeMembers.add(new AttributeMembersEntity.empty()
          ..attributeGroupId = groupId
          ..attributeMemberId = item.id
          ..name = item.name);
      }
      pAttr.add(group);
      groupId++;
    }

    List<SpecCombEntity> comb = bean.combs;
    Map<String, BaseSkuEntity> initData = new Map();
    for (SpecCombEntity g in comb) {
      initData[g.comb] = new BaseSkuEntity(g.price, g.stock);
    }

    _productModel = new ProductModel();

    _productModel
      ..productStocks = initData
      ..attributes = pAttr;

    /// SKU 计算
    _productModel.skuResult = (Sku.skuCollection(_productModel.productStocks));

//    _productModel.skuResult.forEach((key, value) {
//      print(
//          "SKU Result   key = $key  keyIsEmpty = ${key.isEmpty}  value = ${value.printStr()}");
//    });

//    print( _productModel.skuResult.keys.toList()..sort((a, b) => a.length.compareTo(b.length)));
  }

  _buildSpec(BuildContext context) {
    var widgets = List<Widget>();

    _productModel.attributes.forEach((attributesEntity) {
      widgets.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          attributesEntity.name,
          style: TextStyle(fontSize: 16),
        ),
      ));
      widgets.add(_buildSpecItem(context, attributesEntity));
    });

    return Column(
      children: widgets,
    );
  }

  Color unCheckableColor = Color(0xffaaaaaa);
  Color checkableColor = Color(0xfff1f1f1);
  Color checkedColor = Colors.blue;

  _buildSpecItem(BuildContext context, AttributesEntity attrGroupData) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: attrGroupData.attributeMembers.map((attr) {
          doHugeSkuWork(attrGroupData, attr);

          Color bgColor;

          switch (attr.status) {
            case AttributeMemberStatus.UNCHECKABLE:
              bgColor = unCheckableColor;
              break;
            case AttributeMemberStatus.CHECKABLE:
              bgColor = checkableColor;
              break;
            case AttributeMemberStatus.CHECKED:
              bgColor = checkedColor;
              break;
          }

          return GestureDetector(
            onTap: () {
              //不可点击
              if (attr.status == AttributeMemberStatus.UNCHECKABLE) {
                print(noStockTip);
//                widget.tipShowProvider(context, noStockTip);
                return;
              }

              // 设置当前单选点击
              doSkuSpecClick(attrGroupData, attr);

              //刷新
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                attr.name,
                style: TextStyle(
                    color: attr.status == AttributeMemberStatus.CHECKED
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void doSkuSpecClick(AttributesEntity attrGroup, AttributeMembersEntity attr) {
    // 设置当前单选点击
    for (AttributeMembersEntity entity in attrGroup.attributeMembers) {
      if (entity == attr) {
        String key = attrGroup.name;
        if (attrGroup.currentSelectedItem == null ||
            !(attrGroup.currentSelectedItem == entity)) {
          entity.status = AttributeMemberStatus.CHECKED;
          //添加已经选择的对象
          attrGroup.currentSelectedItem = entity;
          _productModel.selectedMap[key] = entity;
        } else {
          entity.status = AttributeMemberStatus.CHECKABLE;
          attrGroup.currentSelectedItem = null;
          _productModel.selectedMap.remove(key);
        }
      } else {
        entity.status = (entity.status == AttributeMemberStatus.UNCHECKABLE
            ? AttributeMemberStatus.UNCHECKABLE
            : AttributeMemberStatus.CHECKABLE);
      }
    }

  }

  void doHugeSkuWork(
      AttributesEntity attrGroupData, AttributeMembersEntity attr) {
    // 处理没有该种组合和没有库存
    BaseSkuEntity skuInfo =
        _productModel.skuResult[attr.attributeMemberId.toString()];

    if (skuInfo == null || skuInfo.getStock() <= 0) {
      attr.status = AttributeMemberStatus.UNCHECKABLE;
    } else if (attr == attrGroupData.currentSelectedItem) {
      attr.status = AttributeMemberStatus.CHECKED;
    } else {
      attr.status = AttributeMemberStatus.CHECKABLE;
    }

    if (_productModel.selectedMap.isEmpty) return;

    //判断加上 当前的 attr 是否是可用组合
    // 冒泡排序
    List<AttributeMembersEntity> cacheSelected = new List();
    cacheSelected.addAll(_productModel.selectedMap.values);
    cacheSelected.removeWhere(
        (element) => element.attributeGroupId == attr.attributeGroupId);
    cacheSelected.add(attr);

    for (int j = 0; j < cacheSelected.length - 1; j++) {
      for (int k = 0; k < cacheSelected.length - 1 - j; k++) {
        AttributeMembersEntity cacheEntity;
        if (cacheSelected[k].attributeGroupId >
            cacheSelected[k + 1].attributeGroupId) {
          //交换数据
          cacheEntity = cacheSelected[k];
          cacheSelected[k] = cacheSelected[k + 1];
          cacheSelected[k + 1] = cacheEntity;
        }
      }
    }

    String tempSpecId =
        cacheSelected.map((e) => e.attributeMemberId.toString()).join(',');

//    print(
//        'des=${cacheSelected.map((e) => e.name.toString()).join(',')}  tempSpecId=$tempSpecId  result=${_productModel.skuResult[tempSpecId]?.printStr()}');

    if (_productModel.skuResult[tempSpecId] != null &&
        _productModel.skuResult[tempSpecId].getStock() > 0) {
      attr.status = (attr.status == AttributeMemberStatus.CHECKED
          ? AttributeMemberStatus.CHECKED
          : AttributeMemberStatus.CHECKABLE);
    } else {
      attr.status = AttributeMemberStatus.UNCHECKABLE;
    }
  }
}
