//
//  JZDialog.h
//
//  Created by JZ on 2017.
//

#import "JZDialog.h"
#import <QuartzCore/QuartzCore.h>

#define kDismissDuration 0.3
#define kShowDuration 0.3

@interface JZDialog() <UIGestureRecognizerDelegate> {
    CGPoint _center;
}
@end

@implementation JZDialog

- (void)dealloc {
    self.delegate = nil;
}

- (id)init {
    self = [super init];
    if (self) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        self.frame = window.frame;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6f];
        [window addSubview:self];
        
        _center = CGPointMake(window.center.x, window.center.y + [self getHeightOfStatusBar] / 2.0f);
        _dialogAnimation = JZDialogAnimationTransitionFromBottom;
        _autoAnimateDuration = 0;
        _contentView = [self setupView];
    }
    return self;
}

- (void)setDisableBackgroundColor:(BOOL)disableBackgroundColor {
    if (disableBackgroundColor) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6f];
    }
}

- (id)initWithDelegate:(id)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (CGPoint)center {
    return _center;
}

- (UIView *)setupView {
    return [UIView new];
}

- (void)dialogWillShow {
    
}

- (void)dialogDidShow {
    
}

- (void)dialogWillDismiss {
    
}

- (void)tapRecognizerEvent:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)animationForView:(UIView *)contentView show:(BOOL)show {
    switch (self.dialogAnimation) {
        case JZDialogAnimationTransitionFromBottom:
            if (show) {
                [self animationTransitionFromBottomForView:contentView withAwaitDuration:self.autoAnimateDuration];
            } else {
                [self animationTransitionToBottomForView:contentView];
            }
            break;
        case JZDialogAnimationFade:
            if (show) {
                [self animationFadeInForView:contentView withAwaitDuration:self.autoAnimateDuration];
            } else {
                [self animationFadeOutForView:contentView];
            }
            break;
        default:
            break;
    }
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    [self showInView:window];
}

- (void)showInView:(UIView *)view {
    [self dialogWillShow];
    [view addSubview:self];
    _contentView.center = [self center];
    if (_enableTapRecognizer) {
        UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerEvent:)];
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];
    }
    if (_enableAnimation) {
        [self animationForView:_contentView show:YES];
    }
    
    if (!_disableShadow) {
        [[_contentView layer] setShadowOffset:CGSizeMake(1, 1)];
        [[_contentView layer] setShadowRadius:6];
        [[_contentView layer] setShadowOpacity:0.9];
        [[_contentView layer] setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f].CGColor];
    }
    
    [view addSubview:_contentView];
    [self dialogDidShow];
}

- (void)removeDialogFromView {
    [_contentView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)dismiss {
    [self dialogWillDismiss];
    if (_enableAnimation) {
        [self animationForView:_contentView show:NO];
    } else {
        [self removeDialogFromView];
    }
}

- (void)animationTransitionFromBottomForView:(UIView *)view withAwaitDuration:(CGFloat)awaitDuration {
    self.alpha = 0.0f;
    view.transform = CGAffineTransformMakeTranslation(0, view.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0f;
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (awaitDuration > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(awaitDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.contentView) {
                    [self animationTransitionToBottomForView:view];
                }
            });
        }
    }];
}

- (void)animationTransitionToBottomForView:(UIView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
        view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, view.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeDialogFromView];
    }];
}

- (void)animationFadeInForView:(UIView *)view withAwaitDuration:(CGFloat)awaitDuration {
    view.alpha = 0.0f;
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
        view.alpha = 1.0f;
    } completion:^(BOOL finished){
        if (awaitDuration > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(awaitDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.contentView) {
                    [self animationFadeOutForView:view];
                }
            });
        }
    }];
}

- (void)animationFadeOutForView:(UIView *)view {
    view.alpha = 1.0f;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
        view.alpha = 0.0f;
    } completion:^(BOOL finished){
        [self removeDialogFromView];
    }];
}

- (CGFloat)getHeightOfStatusBar {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusBarHeight = MIN(statusBarFrame.size.width, statusBarFrame.size.height);
    return statusBarHeight;
}
@end
