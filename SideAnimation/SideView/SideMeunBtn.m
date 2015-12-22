//
//  SideMeunBtn.m
//  SideAnimation
//
//  Created by 宫城 on 15/10/25.
//  Copyright © 2015年 宫城. All rights reserved.
//

#import "SideMeunBtn.h"

@interface SideMeunBtn ()

@property (nonatomic, strong) NSString *buttonTitle;

@end

@implementation SideMeunBtn

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, rect);
    [[UIColor orangeColor] set];
    CGContextFillPath(ctx);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:rect.size.height/2];
    [[UIColor orangeColor] setFill];
    [path fill];
    [[UIColor whiteColor] setStroke];
    path.lineWidth = 1;
    [path stroke];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attri = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                            NSForegroundColorAttributeName: [UIColor whiteColor],
                            NSParagraphStyleAttributeName: paragraph};
    CGSize titleSize = [_buttonTitle sizeWithAttributes:attri];
    CGRect titleRect = CGRectMake((rect.size.width - titleSize.width)/2 , (rect.size.height - titleSize.height)/2, titleSize.width, titleSize.height);
    
    [self.buttonTitle drawInRect:titleRect withAttributes:attri];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSInteger num = touch.tapCount;
    
    switch (num) {
        case 1:
            if (self.BtnClickBlock) {
                self.BtnClickBlock();
            }
            break;
            
        default:
            break;
    }
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _buttonTitle = title;
    }
    return self;
}

@end
