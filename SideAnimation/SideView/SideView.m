//
//  SideView.m
//  SideAnimation
//
//  Created by 宫城 on 15/10/25.
//  Copyright © 2015年 宫城. All rights reserved.
//

#import "SideView.h"
#import "SideMeunBtn.h"

#define kExtern 30
#define kBtnHeight  40
#define kBtnWidth   100
#define kBtnSpacing 30

@interface SideView ()

@property (nonatomic, strong) UIView *helperSideView;
@property (nonatomic, strong) UIView *helperCenterView;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, assign) BOOL isTrigger;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger displayCount;
@property (nonatomic, assign) CGFloat diff;

@end

@implementation SideView

- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width - kExtern, 0)];
    [bezierPath addQuadCurveToPoint:CGPointMake(self.frame.size.width - kExtern, self.frame.size.height) controlPoint:CGPointMake(_keyWindow.frame.size.width/2 + _diff, _keyWindow.frame.size.height/2)];
    [bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [bezierPath closePath];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, bezierPath.CGPath);
    [[UIColor orangeColor] set];
    CGContextFillPath(ctx);
}

- (id)initWithTitleItems:(NSArray *)items {
    self = [super init];
    if (self) {
        _keyWindow = [UIApplication sharedApplication].keyWindow;
        _keyWindow.backgroundColor = [UIColor clearColor];
        
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurView.frame = _keyWindow.frame;
        _blurView.alpha = 0;
        
        _helperSideView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
        [_helperSideView setBackgroundColor:[UIColor redColor]];
        _helperSideView.hidden = YES;
        [_keyWindow addSubview:_helperSideView];
        
        _helperCenterView = [[UIView alloc] initWithFrame:CGRectMake(-40, _keyWindow.frame.size.height/2, 40, 40)];
        [_helperCenterView setBackgroundColor:[UIColor yellowColor]];
        _helperCenterView.hidden = YES;
        [_keyWindow addSubview:_helperCenterView];
        
        [self setFrame:CGRectMake(-(CGRectGetWidth(_keyWindow.frame)/2 + kExtern), 0, CGRectGetWidth(_keyWindow.frame)/2 + kExtern, CGRectGetHeight(_keyWindow.frame))];
        self.backgroundColor = [UIColor clearColor];
        [_keyWindow insertSubview:self belowSubview:_helperSideView];
        
        [self addBtns:items];
    }
    return self;
}

- (void)trigger {
    if (!_isTrigger) {
        [_keyWindow insertSubview:_blurView belowSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.bounds;
        }];
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.9 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            [_helperSideView setCenter:CGPointMake(_keyWindow.center.x, _helperSideView.frame.size.height/2)];
        } completion:^(BOOL finished) {
            [self endAnimation];
        }];
        [UIView animateWithDuration:0.3 animations:^{
            _blurView.alpha = 1;
        }];
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            [_helperCenterView setCenter:_keyWindow.center];
        } completion:^(BOOL finished) {
            if (finished) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBlurView:)];
                [_blurView addGestureRecognizer:tap];
            }
            [self endAnimation];
        }];
        
        [self animationButtons];
        _isTrigger = YES;
    }else {
        [self tapOnBlurView:nil];
    }
    
}

- (void)beforeAnimation {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLineAction:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    _displayCount++;
}

- (void)endAnimation {
    _displayCount--;
    if (_displayCount == 0) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)displayLineAction:(CADisplayLink *)dis {
    CALayer *helperSideViewPresentationLayer = (CALayer *)[_helperSideView.layer presentationLayer];
    CALayer *helperCenterViewPresentationLayer = (CALayer *)[_helperCenterView.layer presentationLayer];
    
    CGRect helperSideViewFrame = [[helperSideViewPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    CGRect helperCenterViewFrame = [[helperCenterViewPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    
    _diff = helperSideViewFrame.origin.x - helperCenterViewFrame.origin.x;
//    NSLog(@"%f",_diff);
    [self setNeedsDisplay];
}

- (void)tapOnBlurView:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(-(CGRectGetWidth(_keyWindow.frame)/2 + kExtern), 0, CGRectGetWidth(_keyWindow.frame)/2 + kExtern, CGRectGetHeight(_keyWindow.frame))];
    }];
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.9 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        [_helperSideView setCenter:CGPointMake(-CGRectGetHeight(_helperSideView.frame)/2, CGRectGetHeight(_helperSideView.frame)/2)];
    } completion:^(BOOL finished) {
        [self endAnimation];
    }];
    [UIView animateWithDuration:0.3 animations:^{
        _blurView.alpha = 0;
    }];
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        [_helperCenterView setCenter:CGPointMake(-CGRectGetHeight(_helperCenterView.frame)/2, CGRectGetHeight(_keyWindow.frame)/2)];
    } completion:^(BOOL finished) {
        [self endAnimation];
    }];
    
    _isTrigger = NO;
}

- (void)animationButtons {
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *btn = self.subviews[i];
        btn.transform = CGAffineTransformMakeTranslation(-90, 0);
        
        [UIView animateWithDuration:0.7 delay:(0.3/self.subviews.count)*i usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

- (void)addBtns:(NSArray *)titleItems {
    // 针对奇偶数显示不同
    if (titleItems.count % 2) {
        NSInteger midNum = (titleItems.count + 1)/2 - 1;
        for (NSInteger i = 0; i < titleItems.count; i++) {
            SideMeunBtn *btn = [[SideMeunBtn alloc] initWithTitle:titleItems[i]];
            [btn setFrame:CGRectMake(0, 0, kBtnWidth, kBtnHeight)];
            CGFloat centerY = _blurView.center.y + (kBtnHeight + kBtnSpacing)*(i - midNum) ;
            [btn setCenter:CGPointMake(_keyWindow.frame.size.width/4, centerY)];
            [self addSubview:btn];
            
            __weak typeof(self)weakSelf = self;
            btn.BtnClickBlock = ^() {
                [weakSelf tapOnBlurView:nil];
                if (weakSelf.menuBtnClick) {
                    weakSelf.menuBtnClick(titleItems[i]);
                }
            };
        }
    }else {
        double midNum = (double)titleItems.count/2 - 0.5;
        for (NSInteger i = 0; i < titleItems.count; i++) {
            SideMeunBtn *btn = [[SideMeunBtn alloc] initWithTitle:titleItems[i]];
            [btn setFrame:CGRectMake(0, 0, kBtnWidth, kBtnHeight)];
            CGFloat centerY= _blurView.center.y + (kBtnHeight + kBtnSpacing)*(i - midNum);
            [btn setCenter:CGPointMake(_keyWindow.frame.size.width/4, centerY)];
            [self addSubview:btn];
            
            __weak typeof(self)weakSelf = self;
            btn.BtnClickBlock = ^() {
                [weakSelf tapOnBlurView:nil];
                weakSelf.menuBtnClick(titleItems[i]);
            };
        }
    }
}

@end
