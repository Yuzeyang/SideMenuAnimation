# SideMenuAnimation

## Introduction
This is the animation of the side menu popup from the left side of the view.you can use a button or a pan gesture to show the menu like my demo.

## How to use
```object-c
_sideView = [[SideView alloc] initWithTitleItems:@[@"首页",@"消息",@"推荐",@"更多",@"1",@"2",@"3"]];
_sideView.menuBtnClick = ^(NSString *title) {
NSLog(@"title %@",title);
};
```
you shoule set the side menu's items,and you can set the block to do something
```object-c
[_sideView trigger],
```
and then you call the trigger,that's easy!

## Gif
![](https://github.com/Yuzeyang/SideMenuAnimation/raw/master/SideMenuAnimation.gif)