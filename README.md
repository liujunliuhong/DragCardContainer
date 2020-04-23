# YHDragContainer
高度还原类似探探等社交应用的滑牌效果。(兼容OC)

# 为什么写这个库?
由于项目原因，我经常需要用到滑牌效果。最开始，我也是在网上找各种三方库，也的确找到了一些，但是都不是很满意，要么某些我想要的功能没有，要么就是感觉滑牌效果不好，要么就是有些Bug，导致我总是要去改动源码。这样折腾了几次之后，我决定自己写一个，因此就有了这个库。

# 与其他三方库对比
本人参考了一些其他开源库，给了我很多灵感，在此表示感谢:

- [CCDraggableCard](https://github.com/liuzechen/CCDraggableCard-Master)
- [QiCardView](https://github.com/QiShare/QiCardView)

但是我觉得这些开源库有些不足的地方:
- `CCDraggableCard`:只是对卡片的宽做了缩放，没有对高做缩放，另外，其还可以滑动和点击没有显示在最顶部的卡片，而且其没有提供当前滑动索引的方法，并且其属性在框架内部写死了，不能灵活配置。之前在使用的时候，由于这些原因导致我改动了大量的源代码。
- `QiCardView`:没有提供卡片的点击事件，并且在滑动过程中没有对下层卡片做处理。

综合上述原因，本人决定自己写一个扩展性好，可以灵活配置各种属性的滑牌库。
与其他的同类三方库对比的优点：
- 可以无限滑动
- 可以上下左右滑动
- 实现了卡片的重用机制，在快速滑动时，内存不会飙升
- 多种类型的卡片可以同时显示
- 滑牌属性可以自由定制
- 兼容OC
- 通过数据源的方式来控制卡牌
- 代理丰富，可以根据自己的需要来选择合适的代理

## 即将加入的功能
- 目前是只支持纯frame初始化，接下来研究下如何适配AutoLayout

## 效果预览
<img src="GIF/test.gif" width="350">

## 安装

### 手动
Clone代码，把`Sources`文件夹拖入项目就可以使用了

### CocoaPods

```
pod 'YHDragCard.swift'
```
如果提示未找到，先执行`pod repo update`，再执行`pod install`

## 使用
- 👉Swift（具体用法请看Demo，以及框架里面的注释，写的很详细）

```
let card = YHDragCard(frame: CGRect(x: 50, y: UIApplication.shared.statusBarFrame.size.height + 44.0 + 40.0, width: self.view.frame.size.width - 100 , height: 400))
card.dataSource = self
card.delegate = self
card.minScale = 0.9
card.removeDirection = .horizontal
self.view.addSubview(card)

card.reloadData(animation: false) // 这一步千万别忘了，否则界面上是没有卡片的
```
实现数据源协议
```
func numberOfCount(_ dragCard: YHDragCard) -> Int {
    return 10
}
    
func dragCard(_ dragCard: YHDragCard, indexOfCell index: Int) -> YHDragCardCell {
    var cell = dragCard.dequeueReusableCard(withIdentifier: "ID") as?DemoCell
    if cell == nil {
        cell = DemoCell(reuseIdentifier: "ID")
    }
    return cell!
}

```


- 👉OC（具体用法请看Demo里面的`OCDemoViewController`）

```
YHDragCard *card = [[YHDragCard alloc] initWithFrame:CGRectMake(50.0, [UIApplication sharedApplication].statusBarFrame.size.height + 44.0 + 40.0, [UIScreen mainScreen].bounds.size.width - 50.0 * 2.0, 400.0)];
card.delegate = self;
card.dataSource = self;
[self.view addSubview:card];

[card reloadData:NO]; // 这一步千万别忘了，否则界面上是没有卡片的
```
实现数据源协议
```
- (NSInteger)numberOfCount:(YHDragCard *)dragCard{
    return 10;
}

- (YHDragCardCell *)dragCard:(YHDragCard *)dragCard indexOfCell:(NSInteger)index{
    DemoCell *cell = (DemoCell *)[dragCard dequeueReusableCardWithIdentifier:@"OC_ID"];
    if (!cell) {
        cell = [[DemoCell alloc] initWithReuseIdentifier:@"OC_ID"];
    }
    return cell;
}
```



## 更新记录(倒叙)
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
