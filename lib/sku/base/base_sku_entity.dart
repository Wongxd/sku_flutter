///
/// Sku基本模型数据
///
///Created by Wongxd on 2020/6/17.
///https://github.com/Wongxd
///wxd1@live.com
///
class BaseSkuEntity {
  ///价格
  String _price;

  ///库存
  int _stock;

  BaseSkuEntity(this._price, this._stock);

  void setPrice(String price) {
    _price = price;
  }

  String getPrice() {
    return _price;
  }

  void setStock(int stock) {
    _stock = stock;
  }

  int getStock() {
    return _stock;
  }

  String printStr() {
    return 'BaseSkuEntity(price:$_price,stock:$_stock)';
  }
}
