import 'dart:collection';
import 'dart:core';
import 'base_sku_entity.dart';

///
///
///Created by Wongxd on 2020/6/17.
///https://github.com/Wongxd
///wxd1@live.com
///
class Sku {
  /// 算法入口
  ///
  /// @param initData 所有库存的hashMap组合
  /// @return 拆分所有组合产生的所有情况（生成客户端自己的字典）
  static Map<String, BaseSkuEntity> skuCollection(
      Map<String, BaseSkuEntity> initData) {
    //用户返回数据
    HashMap<String, BaseSkuEntity> result = new HashMap();
    // 遍历所有库存
    for (String subKey in initData.keys) {
      BaseSkuEntity skuModel = initData[subKey];
      //根据；拆分key的组合
      List<String> skuKeyAttrs = subKey.split(",");

      //获取所有的组合
      List<List<String>> combArr = _combInArray(skuKeyAttrs);
//      print(combArr);

      // 对应所有组合添加到结果集里面
      for (int i = 0; i < combArr.length; i++) {
        _add2SKUResult(result, combArr[i], skuModel);
      }

      // 将原始的库存组合也添加进入结果集里面
      String key = skuKeyAttrs.join(",");
      result[key] = skuModel;
    }
    return result;
  }

  /// 获取所有的组合放到List里面
  ///
  /// @param skuKeyAttrs 单个key被 , 拆分的数组
  /// @return List
  static List<List<String>> _combInArray(List<String> skuKeyAttrs) {
    if (skuKeyAttrs == null || skuKeyAttrs.length <= 0) return null;
    int len = skuKeyAttrs.length;
    List<List<String>> aResult = new List<List<String>>();
    for (int n = 1; n < len; n++) {
      List<List<int>> aaFlags = _getCombFlags(len, n);
      for (int i = 0; i < aaFlags.length; i++) {
        List<int> aFlag = aaFlags[i];
        List<String> aComb = new List();
        for (int j = 0; j < aFlag.length; j++) {
          if (aFlag[j] == 1) {
            aComb.add(skuKeyAttrs[j]);
          }
        }
        aResult.add(aComb);
      }
    }
    return aResult;
  }

  ///
  ///  获得从 len 中取 n 的所有组合
  /// 算法拆分组合 用 1和 0 的移位去做控制
  /// （这块需要你打印才能看的出来）
  ///
  /// @param len
  /// @param n
  /// @return
  static List<List<int>> _getCombFlags(int len, int n) {
    if (n <= 0) {
      return new List();
    }
    List<List<int>> aResult = new List();
    List<int> aFlag = new List<int>(len);
    bool bNext = true;
    int iCnt1 = 0;
    //初始化
    for (int i = 0; i < len; i++) {
      aFlag[i] = i < n ? 1 : 0;
    }

    aResult.add(aFlag.clone());
    while (bNext) {
      iCnt1 = 0;
      for (int i = 0; i < len - 1; i++) {
        if (aFlag[i] == 1 && aFlag[i + 1] == 0) {
          for (int j = 0; j < i; j++) {
            aFlag[j] = j < iCnt1 ? 1 : 0;
          }
          aFlag[i] = 0;
          aFlag[i + 1] = 1;
          List<int> aTmp = aFlag.clone();
          aResult.add(aTmp);
          if (!aTmp.join("").substring(len - n).contains("0")) {
            bNext = false;
          }
          break;
        }
        if (aFlag[i] == 1) {
          iCnt1++;
        }
      }
    }
    return aResult;
  }

  /// 添加到数据集合
  ///
  /// @param result
  /// @param newKeyList
  /// @param skuModel
  static void _add2SKUResult(HashMap<String, BaseSkuEntity> result,
      List<String> newKeyList, BaseSkuEntity skuModel) {
    String key = newKeyList.join(",");
    if (result.keys.contains(key)) {
      result[key].setStock(result[key].getStock() + skuModel.getStock());
      result[key].setPrice(skuModel.getPrice());
    } else {
      result[key] = new BaseSkuEntity(skuModel.getPrice(), skuModel.getStock());
    }
  }
}

extension Clone<T> on List<T> {
  List<T> clone() {
    var temp = new List<T>();
    this.forEach((e) => (temp.add(e)));
    return temp;
  }
}
