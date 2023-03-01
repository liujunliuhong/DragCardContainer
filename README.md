# DragCardContainer
高度还原类似探探、陌陌等社交应用的滑牌效果。

# (2023.03.01)目前正在重构优化中...

# 为什么写这个库?
&emsp;&emsp;由于项目原因，我经常需要用到滑牌效果。最开始，我也是在网上找各种三方库，也的确找到了一些，但是都不是很满意，要么某些我想要的功能没有，要么就是感觉滑牌效果不好，要么就是有些Bug，导致我总是要去改动源码。这样折腾了几次之后，我决定自己写一个，因此就有了这个库。

# 与其他三方库对比
本人参考了一些其他开源库，给了我很多灵感，在此表示感谢:

- [CCDraggableCard](https://github.com/liuzechen/CCDraggableCard-Master)
- [QiCardView](https://github.com/QiShare/QiCardView)
- [ZLSwipeableViewSwift](https://github.com/zhxnlai/ZLSwipeableViewSwift)

但是我觉得这些开源库有些不足的地方:
- `CCDraggableCard`:只是对卡片的宽做了缩放，没有对高做缩放，另外，其还可以滑动和点击没有显示在最顶部的卡片，而且其没有提供当前滑动索引的方法，并且其属性在框架内部写死了，不能灵活配置。之前在使用的时候，由于这些原因导致我改动了大量的源代码。
- `QiCardView`:没有提供卡片的点击事件，并且在滑动过程中没有对下层卡片做处理。
- `ZLSwipeableViewSwift`:没有重用机制，且屏幕旋转的支持不够完美。

综合上述原因，本人决定自己写一个扩展性好，可以灵活配置各种属性的滑牌库。
与其他的同类三方库对比的优点：
- ✅可以无限滑动
- ✅可以上下左右滑动
- ✅实现了卡片的重用机制，在快速滑动时，内存不会飙升
- ✅多种类型的卡片可以同时显示
- ✅滑牌属性可以自由定制
- ✅支持`Autolayout`和`Frame`
- ✅支持屏幕旋转
- ✅通过数据源的方式来控制卡牌
- ✅代理丰富，可以根据自己的需要来选择合适的代理
- ✅不依赖任何三方库

目前暂不支持的功能：
- ❌不支持Xib，将来也许会支持
- ❌不支持自定义卡牌划出方向。目前只能水平和竖直，不支持`["向右", "向上"]`等这种自定义方式

## 即将加入的功能
- 即将支持物理引擎，使卡牌滑动更接近物理效果

## 效果预览
<img src="GIF/example.gif" width="350">

## 安装

### 手动
Clone代码，把`Sources`文件夹拖入项目就可以使用了

### CocoaPods

```
pod 'DragCard'
```
如果提示未找到，先执行`pod repo update`，再执行`pod install`。支持`iOS 9.0`以上系统

## 使用
用法很简单，类似于`UITableView`，可以运行Demo查看具体使用方法

```
let cardContainer = DragCardContainer()
cardContainer.delegate = self
cardContainer.dataSource = self
cardContainer.visibleCount = 3
cardContainer.minimumScale = 0.8
cardContainer.cellRotationMaximumAngle = 15
cardContainer.removeDirection = .horizontal
cardContainer.register(CardCell.self, forCellReuseIdentifier: "ID")
view.addSubview(cardContainer)

cardContainer.snp.makeConstraints { make in
    make.centerX.equalToSuperview()
    make.width.equalToSuperview().multipliedBy(0.6)
    make.centerY.equalToSuperview()
    make.height.equalToSuperview().multipliedBy(0.6)
}

```
实现数据源协议
```
public func numberOfCount(_ dragCard: DragCardContainer) -> Int {
    return 8
}

public func dragCard(_ dragCard: DragCardContainer, indexOfCell index: Int) -> DragCardCell {
    let cell = dragCard.dequeueReusableCell(withIdentifier: "ID") as? CardCell
    cell?.titleLabel.text = "\(index)"
    return cell ?? DragCardCell()
}
```


## 更新记录(倒叙)

### 8、1.1.1（2021.10.22）
- 修改当前卡片索引异常的Bug

### 7、1.1.0（2021.10.22）

由于此次更新重构了代码，类名、协议名、属性名称都有一些改变，如果你使用了我写的这个库，请记得修改下你的代码

- 重构代码，更加Swift，不再支持OC，只支持Swift
- 增加Cell注册
- 修改隐藏Bug

### 6、 1.0.1（2020.10.24）
- 添加屏幕旋转的Demo

### 5、1.0.0（2020.04.21）
- 移除OC版本库，之后只会对Swift库进行更新，并增加对OC的支持
- 实现了卡片重用机制。现在卡片快速滑动时，内存不会飙升
- 优化代码，优化交互体验。现在可以快速滑动了，而不必等上一个卡片滑出去了，才可以滑下一个卡片

### 4、(2019.12.15)

###### OC 0.6.2版本
- 解决push下一个界面之后，卡片reload的bug

###### Swift 0.6.3版本
- 移除`didMoveToSuperview`方法，由开发者自行选择合适时机reload

### 3、(2019.10.08)

###### OC 0.6.0版本
- OC版本重构，优化代码

###### Swift 0.6.1版本
- 增加Swift版本

### 2、OC 0.5.0版本（2019.6.20）
- 增加禁用拖动手势的功能

### 1、OC 0.4.0版本（2019.6.13）
- 增加撤销功能
- 增加往上滑动和往下滑动的回调

## 补充
该仓库会不断进行优化，在使用过程中，有任何建议或问题，欢迎提issue，或者通过邮箱1035841713@qq.com联系我<br>
喜欢就star❤️一下吧
