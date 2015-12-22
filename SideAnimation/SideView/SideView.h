//
//  SideView.h
//  SideAnimation
//
//  Created by 宫城 on 15/10/25.
//  Copyright © 2015年 宫城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideView : UIView

@property (nonatomic, copy) void(^menuBtnClick)(NSString *title);

- (id)initWithTitleItems:(NSArray *)items;

- (void)trigger;

@end
