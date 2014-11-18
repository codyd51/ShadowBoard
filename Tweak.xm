BOOL hasUnlockedBefore;

@interface SBIconView : UIView
@end

%hook SBIconView

- (void)layoutSubviews {
	if (!hasUnlockedBefore) {
		self.layer.masksToBounds = NO;
    	self.layer.cornerRadius = 2; // if you like rounded corners
    	self.layer.shadowOffset = CGSizeMake(1, 1);
    	self.layer.shadowRadius = 2;
    	self.layer.shadowOpacity = 0.5;
    	UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset.height" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    	verticalMotionEffect.minimumRelativeValue = @(20);
    	verticalMotionEffect.maximumRelativeValue = @(-20);

    	UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset.width" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    	horizontalMotionEffect.minimumRelativeValue = @(20);
    	horizontalMotionEffect.maximumRelativeValue = @(-20);

    	UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    	group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];

    	[self addMotionEffect:group];

    	%orig;
    }
}

%end

int counter = 0;

%hook SpringBoard

-(BOOL)attemptUnlockWithPasscode:(id)passcode {

	BOOL r = %orig;
	if (counter == 0) {
		counter++;
		return r;
	}
	else {
		hasUnlockedBefore = YES;
		return r;
	}
	return r;

}

%end