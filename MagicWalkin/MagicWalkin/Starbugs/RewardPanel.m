
#import "RewardPanel.h"
#define rowHeight 140


@protocol RewardItemViewDelegate <NSObject>

@optional
-(void) rewardDidTouch: (RewardItem *) item index: (int) index;

@end


@interface RewardPanel(private) <RewardItemViewDelegate>

@end

@interface RewardItemsView : UIView
{
}

@property (nonatomic, readonly) NSArray *rewardItems; 
@property (nonatomic, retain) id<RewardItemViewDelegate> delegate;
-(void) setRewardItems: (NSArray *) items;

@end



@implementation RewardItemsView

@synthesize delegate, rewardItems=_rewardItems;

-(void) rewardDidTouch: (UIButton *) button {
	RewardItem *item = [_rewardItems objectAtIndex:button.tag - 1];
	
	if(delegate != nil)
		[delegate rewardDidTouch:item index:button.tag - 1];
}

-(void) setRewardItems: (NSArray *) items {
	[_rewardItems release];
	_rewardItems = [items retain];
	
	int subviewCnt = [self.subviews count];
	for(int i=0; i < subviewCnt; i++)
		[[self.subviews objectAtIndex:i] removeFromSuperview];

	int cnt = [items count];
	for(int i=0; i<cnt; i++)
	{
		int x = i % 2 == 0 ? 0 : 10;
		RewardItem *item = [items objectAtIndex:i];
		
		UIButton *b = [[UIButton alloc] initWithFrame:CGRectZero];
		b.tag = i + 1;
		[b addTarget:self action:@selector(rewardDidTouch:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:b];
		
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, 5, 145, 20)];
		lbl.font = [UIFont boldSystemFontOfSize:12];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.text = item.name;
		[b addSubview:lbl];
		[lbl release];
		
		UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(x, 30, 140, 80)];
		view.image = [UIImage imageNamed:[item.imageUrls objectAtIndex:0]];
		view.contentMode = UIViewContentModeScaleToFill;
		[b addSubview:view];
		[view release];
		
		view = [[UIImageView alloc] initWithFrame:CGRectMake(x, 108, 140, 25)];
		view.image = [UIImage imageNamed:@"reward_pic_pointbar.png"];
		view.contentMode = UIViewContentModeScaleAspectFit;
		[b addSubview:view];
		[view release];
		
		
		lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 25)];
		lbl.font = [UIFont boldSystemFontOfSize:12];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textColor = [UIColor whiteColor];
		lbl.text = [NSString stringWithFormat:@"%.0f", item.starRequiredToRedeem];
		[view addSubview:lbl];
		[lbl release];
		
		[b release];
	}
	
	
}

-(void) layoutSubviews {
	int n = [self.subviews count];
	
	for(int i=0; i<n; i++)
	{
		UIView *v = [self.subviews objectAtIndex:i];
		int x = i % 2 == 0 ? 0 : self.frame.size.width / 2;
		int y = (i / 2) * rowHeight;
		int width = self.frame.size.width / 2 - 10;
		v.frame = CGRectMake(x, y, width, rowHeight);
		
	}
}

-(void) drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, NO);
	CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1] CGColor]);
	
	int cnt = [_rewardItems count];
	int rowCnt = cnt / 2;
	
	
	CGContextMoveToPoint(context, self.frame.size.width / 2, 0);
	CGContextAddLineToPoint(context, self.frame.size.width / 2, rowHeight * (rowCnt + 1));
	
	for(int i=0; i<cnt; i++)
	{
		CGContextMoveToPoint(context, 0, rowHeight * (i + 1));
		CGContextAddLineToPoint(context, self.frame.size.width, rowHeight * (i + 1));
	}
	
	CGContextStrokePath(context);
}

-(void) dealloc {
	
	[_rewardItems release];
	[super dealloc];
}
@end




@implementation RewardPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		isAnimating = NO;
		
		button = [[NavBarButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
		button.iconImage = [UIImage imageNamed:@"icon_gift.png"];
		button.isActive = YES;
		[self addSubview:button];
		
		
		UIButton *b = [[UIButton alloc] initWithFrame:button.frame];
		[b addTarget:self action:@selector(butBackDidTouch) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:b];
		[b release];
			
		lblRewardTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, 200, 20)];
		lblRewardTitle.font = [UIFont systemFontOfSize:20];
		lblRewardTitle.backgroundColor = [UIColor clearColor];
		lblRewardTitle.textColor = PurpleColor;
		lblRewardTitle.text = @"YOUR STARS";
		[self addSubview:lblRewardTitle];
		
		
		vMiddleBg = [[UIView alloc] initWithFrame:CGRectZero];
		vMiddleBg.backgroundColor = PurpleColor;
		[self addSubview:vMiddleBg];
		
		
		lblMiddle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
		lblMiddle.backgroundColor = [UIColor clearColor];
		lblMiddle.textColor = [UIColor whiteColor];
		lblMiddle.font = [UIFont systemFontOfSize:16];
		lblMiddle.text = @"Turns STARS into rewards";
		[vMiddleBg addSubview:lblMiddle];
		
		sView = [[UIScrollView alloc] initWithFrame:CGRectZero];
		sView.backgroundColor = [UIColor clearColor];
		[self addSubview:sView];
		

		RewardItemsView *itemV = [[RewardItemsView alloc] initWithFrame:CGRectZero];
		itemV.delegate = self;
		itemV.backgroundColor = [UIColor clearColor];
		itemV.tag = 1;
		[sView addSubview:itemV];
		[itemV release];
    }
    return self;
}

-(void) rewardDidTouch: (RewardItem *) item index:(int)index {
	isAnimating = YES;
	detailingItem = item;
	showingDetailItemIndex = index;
	isShowingDetail = YES;
	
	[button setIsLoading:YES Animated:YES];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector:@selector(changeToDetailView)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.4];
	
	CGRect f = vMiddleBg.frame;
	f.origin.x = - self.frame.size.width;
	vMiddleBg.frame = f;
	
	f = sView.frame;
	f.origin.x = - self.frame.size.width;
	sView.frame = f;
	
	[UIView commitAnimations];
}


-(void) changeToDetailView {
	
	sView.hidden = vMiddleBg.hidden = YES;
	
	button.iconImage = [UIImage imageNamed:@"icon_back.png"];
	[button setIsLoading:NO Animated:YES];
	
	if(detailVC == nil) {
		RewardItemsView *v = (RewardItemsView *) [sView viewWithTag:1];
		
		detailVC = [[ItemDetailViewController alloc] initWithItems:v.rewardItems AndDisplayingItemIndex:showingDetailItemIndex];
		detailVC.delegate = self;
		[self addSubview:detailVC.view];
		
	}
	
	[detailVC presentDataOfItemAtIndex:showingDetailItemIndex];
	detailVC.view.frame = CGRectMake(self.frame.size.width, vMiddleBg.frame.origin.y, vMiddleBg.frame.size.width, self.frame.size.height - 100);
	[detailVC layoutSubview];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(setAnimationStopFlag)];
	[UIView setAnimationDuration:0.4];
	
	CGRect f = detailVC.view.frame;
	f.origin.x = 10;
	detailVC.view.frame = f;
	
	[UIView commitAnimations];
	
}

-(void)baseViewWillStartLoading:(BaseViewController *)viewController
{
	[button setIsLoading:YES Animated:YES];
}

-(void) baseViewDidEndLoading:(BaseViewController *)viewController {
	[button setIsLoading:NO Animated:YES];
}

-(void) setAnimationStopFlag {
	isAnimating = NO;
}

-(void) butBackDidTouch {
	if(isShowingDetail)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		
		CGRect f = detailVC.view.frame;
		f.origin.x = self.frame.size.width + 10;
		detailVC.view.frame = f;
		[UIView commitAnimations];
		
		[button setIsLoading:YES Animated:YES clockwise:NO completion:^(BOOL completed) {
            [self changeToRewardView];
        }];
	}
}

-(void) changeToRewardView {
	
	sView.hidden = vMiddleBg.hidden = NO;
	
	button.iconImage = [UIImage imageNamed:@"icon_gift.png"];
	[button setIsLoading:NO Animated:YES clockwise:NO completion:nil];
	
	isShowingDetail = NO;
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	
	CGRect f = vMiddleBg.frame;
	f.origin.x = 10;
	vMiddleBg.frame = f;
	
	f = sView.frame;
	f.origin.x = 10;
	sView.frame = f;
	
	[UIView commitAnimations];
}

-(void) layoutSubviews {
	if(!isAnimating)
	{
		vMiddleBg.frame = CGRectMake(10, 75, self.frame.size.width - 20, 30);
		
		CGRect f = CGRectMake(10, 110, self.frame.size.width - 20, self.frame.size.height - 110);
		
		if(!CGRectEqualToRect(sView.frame, f))
			sView.frame = CGRectMake(10, 110, self.frame.size.width - 20, self.frame.size.height - 110);

		RewardItemsView *v = (RewardItemsView *) [sView viewWithTag:1];
		v.frame = CGRectMake(0, 0, sView.frame.size.width, v.frame.size.height);
	}
}

-(void) setRewardItems: (NSArray *) items {
	
	RewardItemsView *v = (RewardItemsView *) [sView viewWithTag:1];
	[v setRewardItems:items];
	
	CGRect f = v.frame;
	int height = rowHeight * (int)ceil((float)[items count] / 2);
	f.size.height = height;
	v.frame = f;
	
	sView.contentSize = CGSizeMake(sView.frame.size.width, height);
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, NO);
	
	//Draw Bottom border
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1] CGColor]);
	
	CGContextMoveToPoint(context, 0, 70);
	CGContextAddLineToPoint(context, self.frame.size.width, 70);
	
	CGContextStrokePath(context);
}


-(void) dealloc {
	[lblMiddle release];
	[vMiddleBg release];
	
	[lblRewardTitle release];
	[button release];
	[super dealloc];
}

@end



