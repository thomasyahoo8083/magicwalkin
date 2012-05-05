#import "TopMenuViewController.h"


@implementation TopMenuViewController

@synthesize delegate;

-(id) init {
	self = [super init];
	if(self) {
		isProfileOpened = NO;
		
	}
	return self;
}

-(void) loadTopMenu {
	vProfile = [[UIBorderView alloc] initWithFrame:CGRectZero];
	vProfile.backgroundColor = [UIColor whiteColor];
	vProfile.border = BorderRight;
	vProfile.borderMargin = 5;
	vProfile.touchCallback = @selector(profileDidTouch);
	vProfile.touchCallbackTarget = self;
	[mainBorderView addSubview:vProfile];
	
	ivProfile = [[UIImageView alloc] initWithFrame:CGRectZero];
	ivProfile.image = [UIImage imageNamed:@"icon_profile.png"];
	ivProfile.contentMode = UIViewContentModeScaleAspectFit;
	[vProfile addSubview:ivProfile];
	
	lblProfile = [[UILabel alloc] initWithFrame:CGRectZero];
	lblProfile.textAlignment = UITextAlignmentCenter;
	lblProfile.backgroundColor = [UIColor clearColor];
	lblProfile.font = [UIFont systemFontOfSize:12];
	lblProfile.text = @"PROFILE";
	lblProfile.textColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1];
	[vProfile addSubview:lblProfile];
	
	
	vReward = [[UIBorderView alloc] initWithFrame:CGRectZero];
	vReward.backgroundColor = [UIColor whiteColor];
	vReward.border = BorderLeft;
	vReward.borderMargin = 5;
	vReward.touchCallback = @selector(rewardDidTouched);
	vReward.touchCallbackTarget = self;
	[mainBorderView addSubview:vReward];
	
	ivReward = [[UIImageView alloc] initWithFrame:CGRectZero];
	ivReward.image = [UIImage imageNamed:@"icon_reward.png"];
	ivReward.contentMode = UIViewContentModeScaleAspectFit;
	[vReward addSubview:ivReward];
	
	lblReward = [[UILabel alloc] initWithFrame:CGRectZero];
	lblReward.textAlignment = UITextAlignmentCenter;
	lblReward.backgroundColor = [UIColor clearColor];
	lblReward.font = [UIFont systemFontOfSize:12];
	lblReward.text = @"REWARDS";
	lblReward.textColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1];
	[vReward addSubview:lblReward];
	
	vClose = [[UIBorderView alloc] initWithFrame:CGRectZero];
	vClose.backgroundColor = [UIColor whiteColor];
	vClose.border = BorderLeft;
	vClose.borderMargin = 5;
	vClose.hidden = YES;
	vClose.touchCallback = @selector(closeDidTouch);
	vClose.touchCallbackTarget = self;
	[mainBorderView addSubview:vClose];
	
	ivClose = [[UIImageView alloc] initWithFrame:CGRectZero];
	ivClose.image = [UIImage imageNamed:@"but_close.png"];
	ivClose.contentMode = UIViewContentModeScaleAspectFit;
	[vClose addSubview:ivClose];
	
	lblClose = [[UILabel alloc] initWithFrame:CGRectZero];
	lblClose.textAlignment = UITextAlignmentCenter;
	lblClose.backgroundColor = [UIColor clearColor];
	lblClose.font = [UIFont systemFontOfSize:12];
	lblClose.text = @"CLOSE";
	lblClose.textColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1];
	[vClose addSubview:lblClose];

	ivScorebar = [[UIImageView alloc] initWithFrame:CGRectZero];
	ivScorebar.image = [UIImage imageNamed:@"score_bar.png"];
	ivScorebar.clipsToBounds = YES;
	[mainBorderView addSubview:ivScorebar];
	
	for(int i=0; i<18; i++)
	{
		lblMoney[i] = [[UILabel alloc] initWithFrame:CGRectZero];
		lblMoney[i].backgroundColor = [UIColor clearColor];
		
		if(i == 0)
			lblMoney[i].text = @"0";
		
		lblMoney[i].textAlignment = UITextAlignmentCenter;
		lblMoney[i].textColor = [UIColor whiteColor];
		lblMoney[i].font = [UIFont systemFontOfSize:16];
	
		[ivScorebar addSubview:lblMoney[i]];
	}
	
	for(int i=0; i<9; i++)
		lblMoney[i].frame = CGRectMake(i * 17 + 18, 0, 17, 24);
	
	for(int i=9; i<18; i++)
		lblMoney[i].frame = CGRectMake(i * 17 + 18, 24, 17, 24);
	
	profilePanel = [[ProfilePanel alloc] initWithFrame:CGRectZero];
	profilePanel.backgroundColor = [UIColor whiteColor];
	profilePanel.hidden = YES;
	[self.view addSubview:profilePanel];
	
			
	[self initRewardPanel];

	[self.view sendSubviewToBack:vRewardPanel];
	
	
	[self.view sendSubviewToBack:profilePanel];
	[mainBorderView bringSubviewToFront:vProfile];
	
	[mainBorderView bringSubviewToFront:vReward];
	[mainBorderView bringSubviewToFront:vClose];
	
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	for(int i=0; i<7; i++)
	{
		RewardItem *t = [[RewardItem alloc] init];
		t.name =  [NSString stringWithFormat: @"Nike Gift Card $500 #%d", (i + 1)];
		[t.imageUrls addObject:@"pic_rewards_nike.jpg"];
		t.starRequiredToRedeem = 35000;
		[arr addObject:t];
		[t release];
	}
	[vRewardPanel setRewardItems:arr];
	[arr release];
	
}



-(void) initRewardPanel {
	vRewardPanel = [[RewardPanel alloc] initWithFrame:CGRectZero];
	vRewardPanel.backgroundColor = [UIColor whiteColor];
	vRewardPanel.hidden = YES;
	[self.view addSubview:vRewardPanel];
}

-(void) loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view.backgroundColor = [UIColor clearColor];
	
	mainBorderView = [[UIBorderView alloc] initWithFrame:CGRectZero];
	mainBorderView.backgroundColor = [UIColor whiteColor];
	mainBorderView.border = BorderBottom;
	[self.view addSubview:mainBorderView];
	
	[self loadTopMenu];	
}

-(void) viewWillLayoutSubviews {
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height;
	
	mainBorderView.frame = CGRectMake(0, 0, width, 43);
	
	if(!isProfileOpened) {
		vProfile.frame = CGRectMake(0, 0, 65, 40);
		ivProfile.frame = CGRectMake(-1, 3, 66, 34);
		lblProfile.frame = CGRectMake(1, 21, 60, 20);
	
		profilePanel.frame = CGRectMake(0, -190 + height, width, 190);
	}
	else 
	{
		CGRect frame = vProfile.frame;
		frame.size.width = width;
		vProfile.frame = frame;
		profilePanel.frame = CGRectMake(0, 43, width, 190);
		
	}
	
	if(!isRewardOpened)
	{
		vRewardPanel.frame = CGRectMake(0, -417, width, 417);
		
		vReward.frame = CGRectMake(width - 70, 0, 70, 40);
		ivReward.frame = CGRectMake(2, 5, 66, 34);
		lblReward.frame = CGRectMake(0, 21, 71, 20);
		
		vClose.frame = vReward.frame;
		ivClose.frame = CGRectMake(28, 5, 15, 15);
		lblClose.frame = CGRectMake(0, 21, 71, 20);
	}
	else
	{
		vRewardPanel.frame = CGRectMake(0, 43, width, 417);
	}
	
	if(!isProfileOpened && !isRewardOpened)
		ivScorebar.frame = CGRectMake((width - 171) / 2, 8, 171, 24);
	else if(isProfileOpened)
		ivScorebar.frame = CGRectMake(70, 40, 171, 24);
	else
		ivScorebar.frame = CGRectMake(70, 35, 171, 24);
	
}


-(void) closeDidTouch {
	if(isRewardOpened)
		[self closeRewardsMenu];
	else if(isProfileOpened)
		[self closeProfileMenu];
}

-(void) openProfileMenu {
	if(delegate != nil)
		[delegate menuWillOpen];
	
	isProfileOpened = YES;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDidStopSelector:@selector(openProfileMenu2)];
	
	vProfile.frame = CGRectMake(0, 0, vReward.frame.origin.x + 10, 40);
	ivProfile.alpha = 0;
    lblProfile.alpha = 0;
    
	[UIView commitAnimations];
}

-(void) openProfileMenu2 {
	
	[ivScorebar removeFromSuperview];
	
	CGRect f = profilePanel.frame;
	f.origin.y = 43 - f.size.height;
	profilePanel.frame = f;
	
	[profilePanel addSubview:ivScorebar];
	ivScorebar.frame = CGRectMake(70, 40, 171, 24);
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(openProfileMenu3)];
	
	CGRect frame = vReward.frame;
	frame.origin.x = self.view.frame.size.width + 100;
	vReward.frame = frame;
	
	frame = vProfile.frame;
	frame.size.width = self.view.frame.size.width + 100;
	vProfile.frame = frame;
	
    [UIView commitAnimations];
	
}

-(void) openProfileMenu3 {
	ivProfile.frame = CGRectMake(-120, 5, 88, 44);
    lblProfile.frame = CGRectMake(-60, 10, 120, 20);
    lblProfile.font = [UIFont systemFontOfSize:18];
    ivProfile.alpha = 1;
    lblProfile.alpha = 1;
    
	vClose.frame = vReward.frame;
	vClose.hidden = NO;
	vReward.hidden = YES;
	profilePanel.hidden = NO;
	
	[mainBorderView bringSubviewToFront:vProfile];
	[mainBorderView bringSubviewToFront:vClose];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(openMenuDone)];
	 
	CGRect frame = vClose.frame;
	frame.origin.x = self.view.frame.size.width - frame.size.width;
	vClose.frame = frame;
	
	frame = profilePanel.frame;
	frame.origin.y += frame.size.height;
	profilePanel.frame = frame;
	
    ivProfile.frame = CGRectMake(-15, 5, 88, 44);
    lblProfile.frame = CGRectMake(22, 10, 120, 20);
    
	[UIView commitAnimations];
	
}

-(void) openMenuDone {

	if(delegate != nil)
		[delegate menuDidOpen];
}

-(void) closeMenuDone {
	if(delegate != nil)
		[delegate menuDidClose];
}

-(void) profileDidTouch {
	
	if(!isProfileOpened)
		[self openProfileMenu];
	
    else
        [self closeProfileMenu];

}

-(void) closeProfileMenu {
	
	if(delegate != nil)
		[delegate menuWillClose];
	
	isProfileOpened = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(CloseProfileMenu2)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	
	CGRect frame = profilePanel.frame;
	frame.origin.y = frame.origin.y - frame.size.height;
	profilePanel.frame = frame;
	
	frame = vClose.frame;
	frame.origin.x = self.view.frame.size.width + 100;
	vClose.frame = frame;
	[UIView commitAnimations];
}

-(void) CloseProfileMenu2 {
	
	[ivScorebar removeFromSuperview];
	[mainBorderView addSubview:ivScorebar];
	ivScorebar.frame = CGRectMake((self.view.frame.size.width - 171) / 2, 8, 171, 24);
	[mainBorderView bringSubviewToFront:vProfile];
	[mainBorderView bringSubviewToFront:vReward];
	
	CGRect frame =  vClose.frame;
	frame.origin.x = self.view.frame.size.width;
	vReward.frame = frame;
	
	vReward.hidden = NO;
	vClose.hidden = YES;
	profilePanel.hidden = YES;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDidStopSelector:@selector(CloseProfileMenu3)];
	
	frame = vReward.frame;
	frame.origin.x = self.view.frame.size.width - frame.size.width;
	vReward.frame = frame;
	
	frame = vProfile.frame;
	frame.size.width = vReward.frame.origin.x;
	vProfile.frame = frame;
	
	[UIView commitAnimations];
}

-(void) CloseProfileMenu3 {
    lblProfile.font = [UIFont systemFontOfSize:12];
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(closeMenuDone)];
	
	vProfile.frame = CGRectMake(0, 0, 65, 40);
	ivProfile.frame = CGRectMake(-1, 3, 66, 34);
	lblProfile.frame = CGRectMake(1, 21, 60, 20);
	
	[UIView commitAnimations];
	
}




-(void) openRewardsMenu {
	if(delegate != nil)
		[delegate menuWillOpen];
	
	isRewardOpened = YES;
	[self.view bringSubviewToFront:vReward];
	[self.view bringSubviewToFront:vProfile];
	
	CGRect f = vReward.frame;
	f.origin.x += f.size.width;
	vClose.frame = f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDidStopSelector:@selector(openRewardsMenu2)];
	
	f = vReward.frame;
	float distance = f.origin.x - (vProfile.frame.size.width - 20);
	f.origin.x = vProfile.frame.size.width - 20;
	f.size.width = self.view.frame.size.width;
	
	vReward.frame = f;
	
	f = ivReward.frame;
	f.origin.x += distance; 
	ivReward.frame = f;
	
	f = lblReward.frame;
	f.origin.x += distance; 
	lblReward.frame = f;
	
	lblReward.alpha = 0;
    ivReward.alpha = 0;
	
	[UIView commitAnimations];

}

-(void) openRewardsMenu2 {
	[ivScorebar removeFromSuperview];
	[vRewardPanel addSubview:ivScorebar];
	ivScorebar.frame = CGRectMake(70, 35, 171, 24);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(openRewardsMenu3)];
	
	
	CGRect frame = vReward.frame;
	frame.origin.x -= 100;
	vReward.frame = frame;
	
	frame = vProfile.frame;
	frame.origin.x -= 100;
	vProfile.frame = frame;
	
    [UIView commitAnimations];
}

-(void) openRewardsMenu3 {
	vRewardPanel.hidden = NO;
	
	[mainBorderView bringSubviewToFront:vProfile];
	[mainBorderView bringSubviewToFront:vClose];

	ivReward.frame = CGRectMake(-120, 8, 88, 44);
    lblReward.frame = CGRectMake(-60, 10, 120, 24);
    lblReward.font = [UIFont systemFontOfSize:18];
    ivReward.alpha = 1;
    lblReward.alpha = 1;
    vClose.hidden = NO;
	vProfile.hidden = YES;
	
	[mainBorderView bringSubviewToFront:vProfile];
	[mainBorderView bringSubviewToFront:vClose];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(openMenuDone)];
	
	CGRect frame = vClose.frame;
	frame.origin.x = self.view.frame.size.width - frame.size.width;
	vClose.frame = frame;
	
	ivReward.frame = CGRectMake(30, 8, 88, 44);
    lblReward.frame = CGRectMake(78, 10, 120, 24);
    
	
	vRewardPanel.frame = CGRectMake(0, 43, self.view.frame.size.width, 417);
	 
	
	[UIView commitAnimations];

}

-(void) closeRewardsMenu {
	
	if(delegate != nil)
		[delegate menuWillClose];
	
	isRewardOpened = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(closeRewardMenu2)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	
	
	
	CGRect frame = vRewardPanel.frame;
	frame.origin.y = frame.origin.y - frame.size.height;
	vRewardPanel.frame = frame;
	
	frame = ivReward.frame;
	frame.origin.x -= 200;
	ivReward.frame = frame;
	
	frame = lblReward.frame;
	frame.origin.x -= 200;
	lblReward.frame = frame;
	
	frame = vClose.frame;
	frame.origin.x = self.view.frame.size.width + frame.size.width;
	vClose.frame = frame;
	
	[UIView commitAnimations];
}

-(void) closeRewardMenu2 {
	
	
	ivReward.frame = CGRectMake(2, 5, 66, 34);
	lblReward.frame = CGRectMake(0, 21, 71, 20);
	lblReward.font = [UIFont systemFontOfSize:12];
	
	[ivScorebar removeFromSuperview];
	[mainBorderView addSubview:ivScorebar];
	ivScorebar.frame = CGRectMake((self.view.frame.size.width - 171) / 2, 8, 171, 24);
	[mainBorderView bringSubviewToFront:vProfile];
	[mainBorderView bringSubviewToFront:vReward];
	
	vProfile.hidden = NO;
	vClose.hidden = YES;
	vRewardPanel.hidden = YES;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(closeMenuDone)];
	
	CGRect frame = vClose.frame;
	frame.origin.x = self.view.frame.size.width - frame.size.width;
	vReward.frame = frame;
	
	frame = vProfile.frame;
	frame.origin.x = 0;
	vProfile.frame = frame;
	
	[UIView commitAnimations];
}

-(void) rewardDidTouched {
	if(!isRewardOpened) 
		[self openRewardsMenu];
	else 
		[self closeRewardsMenu];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    
	
	[ivProfile release];
	[lblProfile release];
	[vProfile release];
	
	[lblReward release];
	[ivReward release];
	[vReward release];
	
	[lblClose release];
	[ivClose release];
	[vClose release];

	
	for(int i=0; i<18; i++)
		[lblMoney[i] release];
	
	[ivScorebar release];
	[profilePanel release];	
	[mainBorderView release];
	
	[vRewardPanel release];
	
	[super viewDidUnload];
}


@end
