//
//  SideMeunBtn.h
//  SideAnimation
//
//  Created by 宫城 on 15/10/25.
//  Copyright © 2015年 宫城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMeunBtn : UIView

@property (nonatomic, copy) void(^BtnClickBlock)(void);

- (instancetype)initWithTitle:(NSString *)title;

@end
