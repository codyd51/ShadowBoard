#import <UIKit/UIKit.h>

@interface SBIconImageView : UIView 
@end

@interface SBIconView : UIView
- (SBIconImageView*)_iconImageView;
@end

static UIMotionEffectGroup *effects;

%hook SBIconView

- (void)layoutSubviews 
{
    %orig;
    if (self.layer.shadowOpacity != 0.5 && [[self motionEffects] indexOfObject:effects] == NSNotFound) 
    {
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = self._iconImageView.layer.cornerRadius;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.5;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = UIScreen.mainScreen.scale;
        [self addMotionEffect:effects];
    }
}

%end

%ctor
{
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset.height" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(30);
    verticalMotionEffect.maximumRelativeValue = @(-30);

    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset.width" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(30);
    horizontalMotionEffect.maximumRelativeValue = @(-30);

    effects = [UIMotionEffectGroup new];
    effects.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
}