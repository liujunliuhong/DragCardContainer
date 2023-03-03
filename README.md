# DragCardContainer

A multi-directional card swiping library inspired by Tinder and TanTan.

## Introduction

Due to project reasons, I often need to use the card sliding effect. At the beginning, I also searched for various three-party libraries on GitHub. Fortunately, I found it. But I am not very satisfied, either some of the functions I want are missing, or I feel that the sliding effect of the card is not good, or there are some bugs, and finally I have to modify the source code. After tossing around like this a few times, I decided to write one.

I refer some third-party libraries:

- [CCDraggableCard](https://github.com/liuzechen/CCDraggableCard-Master)
- [QiCardView](https://github.com/QiShare/QiCardView)
- [ZLSwipeableViewSwift](https://github.com/zhxnlai/ZLSwipeableViewSwift)
- [Shuffle](https://github.com/mac-gallagher/Shuffle)

## Features

- Advanced swipe recognition based on velocity and card position.
- Multiple built-in card stacking styles.
- Manual and programmatic actions.
- Smooth card overlay view transitions.
- Similar to UITableView, dynamic card loading using data source pattern.

## Preview

<img src="GIF/example.gif" width="350">

## Getting Start

### Requirements

- Deployment target iOS 11.0+
- Swift 5+
- Xcode 14+

### Installation

#### CocoaPods

```ruby
pod 'DragCardContainer'
```

Or

```ruby
pod 'DragCardContainer', :git => "https://github.com/liujunliuhong/DragCardContainer.git"
```

### Usage

#### Setting up the card view

Create your own card by either subclassing `DragCardContainer` and setting its properties directly.

```swift
let cardContainer = DragCardContainer()
cardContainer.infiniteLoop = false
cardContainer.dataSource = self
cardContainer.delegate = self
cardContainer.visibleCount = 3
cardContainer.allowedDirection = .horizontal
```

#### Configuring the datasource

You must conform the protocol `DragCardDataSource`.

```swift
public func numberOfCards(_ dragCard: DragCardContainer) -> Int {
    return 10
}

public func dragCard(_ dragCard: DragCardContainer, viewForCard index: Int) -> UIView {
    let view = UIView()
    return view
}
```

#### Configuring the delegate

The protocol `DragCardDelegate` is optional.

```swift
public func dragCard(_ dragCard: DragCardContainer, displayTopCardAt index: Int, with card: UIView) {
    print("displayTopCardAt: \(index)")
}

public func dragCard(_ dragCard: DragCardContainer, movementCardAt index: Int, translation: CGPoint, with card: UIView) {
    print("movementCardAt: \(index) - \(translation)")
}

public func dragCard(_ dragCard: DragCardContainer, didRemovedTopCardAt index: Int, direction: Direction, with card: UIView) {
    print("didRemovedTopCardAt: \(index)")
}

public func dragCard(_ dragCard: DragCardContainer, didRemovedLast card: UIView) {
    print("didRemovedLast")
}

public func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with card: UIView) {
    print("didSelectTopCardAt: \(index)")
}
```

#### Removing Views

##### Swiping programmatically

The user can swipe views in the allowed directions. This can also happen programmatically.

```swift
cardContainer.swipeTopCard(to: .right)
```

##### Rewinding

Returns the most recently swiped card to the top of the card stack.

```swift
cardContainer.rewind(from: .right)
```

### Author

liujun, universegalaxy96@gmail.com
