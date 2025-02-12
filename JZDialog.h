//
//  JZDialog.h
//
//  Created by JZ on 2017.
//

#import <UIKit/UIKit.h>

/// 对话窗动画
typedef enum{
    /// 从底部移动动画
    JZDialogAnimationTransitionFromBottom = 0,
    /// 消散动画
    JZDialogAnimationFade,
} JZDialogAnimation;

/// 对话窗
@interface JZDialog : UIView

/// 是否启用点击阴影区域关闭对话框
@property (nonatomic, assign) BOOL enableTapRecognizer;
/// 是否启用对话框弹出和关闭动画
@property (nonatomic, assign) BOOL enableAnimation;
/// 禁用背景颜色
@property (nonatomic, assign) BOOL disableBackgroundColor;
/// 禁用阴影
@property (nonatomic, assign) BOOL disableShadow;
/// 动画时长
@property (nonatomic, assign) CGFloat autoAnimateDuration;
/// 对话窗动画
@property (nonatomic, assign) JZDialogAnimation dialogAnimation;
/// 代理
@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) UIView *contentView;


/// 创建对象
/// @param delegate 代理
- (id)initWithDelegate:(id)delegate;

/// 展示
- (void)show;

/// 消失
- (void)dismiss;

/// 在视图中展示
/// @param view 视图
- (void)showInView:(UIView *)view;

- (UIView *)setupView;

@end
