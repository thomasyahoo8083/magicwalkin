#import "ProfilePanel.h"

@implementation ProfilePanel


-(id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self)
	{
		self.userInteractionEnabled = YES;
		ivProfilePic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_picture.png"]];
		[self addSubview:ivProfilePic];
		
		lblUsername = [[UILabel alloc] initWithFrame:CGRectZero];
		lblUsername.backgroundColor = [UIColor clearColor];
		lblUsername.textColor = PurpleColor;
		lblUsername.font = [UIFont systemFontOfSize:20];
		lblUsername.text = @"Joe Yeung";
		lblUsername.adjustsFontSizeToFitWidth = YES;
		[self addSubview:lblUsername];
		
		ivLevel = [[UIImageView alloc] initWithFrame:CGRectZero];
		ivLevel.image = [UIImage imageNamed:@"icon_LV_base.png"];
		[self addSubview:ivLevel];
		
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 50, 20)];
		l.font = [UIFont systemFontOfSize:10];
		l.textAlignment = UITextAlignmentCenter;
		l.textColor = [UIColor whiteColor];
		l.backgroundColor = [UIColor clearColor];
		l.text = @"LEVEL";
		[ivLevel addSubview:l];
		[l release];
		
		lblLevel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 50, 25)];
		lblLevel.font = [UIFont systemFontOfSize:24];
		lblLevel.textAlignment = UITextAlignmentCenter;
		lblLevel.textColor = [UIColor whiteColor];
		lblLevel.backgroundColor = [UIColor clearColor];
		lblLevel.text = @"99";
		[ivLevel addSubview:lblLevel];
		
		lblNoOfCheckin = [[UILabel alloc] initWithFrame: CGRectZero];
		lblNoOfCheckin.font = [UIFont systemFontOfSize:24];
		lblNoOfCheckin.textAlignment = UITextAlignmentCenter;
		lblNoOfCheckin.textColor = PurpleColor;
		lblNoOfCheckin.backgroundColor = [UIColor clearColor];
		lblNoOfCheckin.text = @"22";
		[self addSubview:lblNoOfCheckin];
		
		
		lblNoOfScanned = [[UILabel alloc] initWithFrame: CGRectZero];
		lblNoOfScanned.font = [UIFont systemFontOfSize:24];
		lblNoOfScanned.textAlignment = UITextAlignmentCenter;
		lblNoOfScanned.textColor = PurpleColor;
		lblNoOfScanned.backgroundColor = [UIColor clearColor];
		lblNoOfScanned.text = @"13";
		[self addSubview:lblNoOfScanned];
		
		lblNoOfRedeem = [[UILabel alloc] initWithFrame: CGRectZero];
		lblNoOfRedeem.font = [UIFont systemFontOfSize:24];
		lblNoOfRedeem.textAlignment = UITextAlignmentCenter;
		lblNoOfRedeem.textColor = PurpleColor;
		lblNoOfRedeem.backgroundColor = [UIColor clearColor];
		lblNoOfRedeem.text = @"27";
		[self addSubview:lblNoOfRedeem];

		ivScan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_scan.png"]];
		ivScan.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:ivScan];
		
		ivCheckin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_checkin.png"]];
		ivCheckin.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:ivCheckin];
		
		ivRedeem = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_redeem.png"]];
		ivRedeem.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:ivRedeem];
		
		ivMore = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_more.png"]];
		ivMore.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:ivMore];
		
		UIColor *fontColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1];
		
		lblScan = [[UILabel alloc] initWithFrame:CGRectZero];
		lblScan.font = [UIFont systemFontOfSize:12];
		lblScan.backgroundColor = [UIColor clearColor];
		lblScan.textAlignment = UITextAlignmentCenter;
		lblScan.text = @"SCANNED";
		lblScan.textColor = fontColor;
		[self addSubview:lblScan];
		
		lblCheckin = [[UILabel alloc] initWithFrame:CGRectZero];
		lblCheckin.font = [UIFont systemFontOfSize:12];
		lblCheckin.backgroundColor = [UIColor clearColor];
		lblCheckin.text = @"CHECK-IN";
		lblCheckin.textAlignment = UITextAlignmentCenter;
		lblCheckin.textColor = fontColor;
		[self addSubview:lblCheckin];

		lblRedeem = [[UILabel alloc] initWithFrame:CGRectZero];
		lblRedeem.font = [UIFont systemFontOfSize:12];
		lblRedeem.backgroundColor = [UIColor clearColor];
		lblRedeem.text = @"REDEEMED";
		lblRedeem.textAlignment = UITextAlignmentCenter;
		lblRedeem.textColor = fontColor;
		[self addSubview:lblRedeem];
		
		lblMore = [[UILabel alloc] initWithFrame:CGRectZero];
		lblMore.font = [UIFont systemFontOfSize:12];
		lblMore.backgroundColor = [UIColor clearColor];
		lblMore.text = @"MORE";
		lblMore.textAlignment = UITextAlignmentCenter;
		lblMore.textColor = fontColor;
		[self addSubview:lblMore];
		
		
		imageArrow = [[UIImage imageNamed:@"profile_down_arrow.png"] retain]; 
												
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect
{
	float width = self.frame.size.width;
	float height = self.frame.size.height; 
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, NO);

	//Draw Bottom border
	CGContextSetLineWidth(context, 5);
	CGContextSetStrokeColorWithColor(context, PurpleColor.CGColor );
	
	CGContextMoveToPoint(context, 0, self.frame.size.height - 3);
	CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - 3);

	CGContextStrokePath(context);
	
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:.63 green:0.63 blue:0.63 alpha:1].CGColor);
	
	
	//DRAW vertical line
	CGContextMoveToPoint(context, 0, 75);
	CGContextAddLineToPoint(context, self.frame.size.width, 75);
	
	CGContextMoveToPoint(context, width / 4 , 83);
	CGContextAddLineToPoint(context, width / 4, height - 12);
	
	CGContextMoveToPoint(context, width / 2 , 83);
	CGContextAddLineToPoint(context, width / 2, height - 12);
	
	CGContextMoveToPoint(context, width * 3 / 4 , 83);
	CGContextAddLineToPoint(context, width * 3/ 4, height - 12);
	
	CGContextStrokePath(context);
	
	//Draw Seperator
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:.88 green:0.88 blue:0.88 alpha:1].CGColor);
	
	int margin = 10;
	int y = 110;
	
	CGContextMoveToPoint(context, margin, y);
	CGContextAddLineToPoint(context, width / 4 - margin, y);
	
	CGContextMoveToPoint(context, width / 4 + margin, y);
	CGContextAddLineToPoint(context, width / 2 - margin, y);
	
	CGContextMoveToPoint(context, width / 2 + margin, y);
	CGContextAddLineToPoint(context, width * 3 / 4 - margin, y);
	
	CGContextStrokePath(context);
	
    /*
	[imageArrow drawInRect:CGRectMake(((width / 4) - 9) / 2, 175, 9, 4.5)];
	[imageArrow drawInRect:CGRectMake( (width / 4) + ((width / 4) - 9) / 2, 175, 9, 4)];
	[imageArrow drawInRect:CGRectMake( (width / 2) + ((width / 4) - 9) / 2, 175, 9, 4)];
	[imageArrow drawInRect:CGRectMake( (width * 3 / 4) + ((width / 4) - 9) / 2, 175, 9, 4)];
	*/
}

-(void) layoutSubviews {
	float width = self.frame.size.width;
	
	ivProfilePic.frame =  CGRectMake(10, 15, 50, 50);
	lblUsername.frame = CGRectMake(70, 12, width - 100, 25);
	ivLevel.frame = CGRectMake(width - 60, 15, 50, 50);
	
	lblNoOfCheckin.frame = CGRectMake(0, 80, width / 4, 25);
	lblNoOfScanned.frame = CGRectMake(width / 4, 80, width / 4 , 25);
	lblNoOfRedeem.frame = CGRectMake(width / 2, 80, width / 4 , 25);
	
	lblCheckin.frame = CGRectMake(0, 150, width / 4, 25);
	lblScan.frame = CGRectMake(width / 4, 150, width / 4, 25);
	lblRedeem.frame = CGRectMake(width / 2, 150, width / 4, 25);
	lblMore.frame = CGRectMake(width * 3 / 4, 150, width / 4, 25);
	
	ivCheckin.frame = CGRectMake((width / 4 - 24) / 2 , 120, 24, 26);
	ivScan.frame = CGRectMake((width / 4) + (width / 4 - 24) / 2 , 120, 24, 26);
	ivRedeem.frame = CGRectMake((width / 2) + (width / 4 - 24) / 2 , 120, 24, 26);
	ivMore.frame = CGRectMake((width * 3 / 4) + (width / 4 - 24) / 2 , 120, 24, 26);
	
}

-(void) dealloc {
	[lblUsername release];
	[ivProfilePic release];
	[ivLevel release];
	[lblLevel release];
	[lblNoOfCheckin release];
	[lblNoOfScanned release];
	[lblNoOfRedeem release];
	
	[ivMore release];
	[ivScan release];
	[ivRedeem release];
	[ivCheckin release];
	
	[lblCheckin release];
	[lblRedeem release];
	[lblScan release];
	[lblMore release];
	
	[imageArrow release];
	
	[super dealloc];
}

@end
