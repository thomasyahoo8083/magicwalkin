#import "ShopDetailsViewController.h"

@interface PinAnnotation : NSObject <MKAnnotation>

-(id) initWithCoordinate: (CLLocationCoordinate2D) coor;


@end


@implementation PinAnnotation
@synthesize coordinate=_coordinate;

-(id) initWithCoordinate: (CLLocationCoordinate2D) coor {
	self = [super init];
	_coordinate = coor;
	return self;
}

@end

@interface FindAndDealsBgView : UIView

@property (nonatomic, assign) int rowCnt;
@property (nonatomic, assign) int colCnt;

@end

@implementation FindAndDealsBgView

@synthesize rowCnt, colCnt;

-(void) drawRect:(CGRect)rect {
	
	//float width = self.frame.size.width;
	float height = self.frame.size.height; 
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, NO);
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor );
	
	if(rowCnt >= 2)
	{
		CGContextMoveToPoint(context, 0, height / 2);
		CGContextAddLineToPoint(context, self.frame.size.width, height / 2);
	}
	/*
	int x = width / colCnt;
	for(int i=0; i<colCnt - 1; i++)
	{
		CGContextMoveToPoint(context, x, 0);
		CGContextAddLineToPoint(context, x, height);
		x += width / colCnt;
	}
	 */
	
	CGContextStrokePath(context);
}

@end

@interface FindAndDealsView : UIButton
{
	UILabel *lblTitle;
	UIImageView *img;
	UILabel *lblDescription;
}

@property (nonatomic, retain) PromotionItem *item;
-(id) initWithItem: (PromotionItem *) theItem;

@end

@implementation FindAndDealsView
@synthesize item;

-(id) initWithItem:(PromotionItem *)theItem {
	item = [theItem retain];
	self = [super initWithFrame:CGRectZero ];
	if(self)
	{
		lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
		lblTitle.text = item.name;
		lblTitle.backgroundColor = [UIColor clearColor];
		lblTitle.font = [UIFont boldSystemFontOfSize:13];
		[self addSubview:lblTitle];
		
		UIImageView *imgV  = [[UIImageView alloc] initWithFrame:CGRectZero];
		imgV.tag = 1;
		imgV.contentMode = UIViewContentModeScaleAspectFit;
		imgV.image = [UIImage imageNamed:@"icon_arrow.png"];
		[self addSubview:imgV];
		[imgV release];
		
		img = [[UIImageView alloc] initWithFrame:CGRectZero];
		img.contentMode = UIViewContentModeScaleAspectFill;
		img.clipsToBounds = YES;
		img.image = [UIImage imageNamed:[theItem.imageUrls objectAtIndex:0]];
		[self addSubview:img];
		
		lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
		lblDescription.text = theItem.shortDescription;
		lblDescription.font = [UIFont systemFontOfSize:10];
		lblDescription.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
		lblDescription.textColor = PurpleColor;
		[img addSubview:lblDescription];
	}
	return self;
}

-(void) layoutSubviews {
	CGRect f = self.frame;
	lblTitle.frame = CGRectMake(0, 0, f.size.width, 20);
	img.frame = CGRectMake(0, 25, f.size.width, f.size.height - 25);
	lblDescription.frame = CGRectMake(0, img.frame.size.height - 25, img.frame.size.width, 25);
	
	UIView *v = [self viewWithTag:1];
	v.frame = CGRectMake(f.size.width - 15, 3, 15, 15);
}


-(void) dealloc {
	[img release];
	[lblTitle release];
	[lblDescription release];
	[item release];
	[super dealloc];
}

@end


@implementation ShopDetailsViewController
@synthesize shop;

-(UIView *) navigationHeaderView {
	UIView *v = [super navigationHeaderView];
	
	AsyncImageView *imgV = (AsyncImageView *)[v viewWithTag:1];
	imgV.imageURL = shop.brand.logoURL;
	[imgV loadImage];
	
	
	UILabel *lbl = (UILabel *)[v viewWithTag:2];
	lbl.text = shop.brand.name;
	
	lbl = (UILabel *)[v viewWithTag:3];
	lbl.text = @"Shop Details";
	
	return v;
}

-(id) initWithShop:(Shop *)theShop {
    self = [super init];
    if(self)
    {
        shop = [theShop retain];
		self.iconImage = [[UIImage imageNamed:@"icon_back.png"] retain];
		self.title = theShop.brand.name;
		starImage = [[UIImage imageNamed:@"star.png"] retain];
		self.headerStyle = BaseViewHeaderImageAndSubtitleStyle;
		BaseViewHeaderInfo info = {shop.brand.logoURL, shop.brand.name, @"Shop Details"};
		self.headerInfo = info;
    }
    return self;
}

-(void) loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    
	mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	mainTableView.delegate = self;
	mainTableView.dataSource = self;
	[self.view addSubview:mainTableView];
	
	
	mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
	mapView.layer.borderColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1].CGColor;
	mapView.layer.borderWidth = 1;
	mapView.tag = 2;
	mapView.delegate = self;
	mapView.userInteractionEnabled = NO;

}

-(MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id<MKAnnotation>)annotation {
	MKAnnotationView *v = [mv dequeueReusableAnnotationViewWithIdentifier:@"pin"];
	
	if([annotation isKindOfClass:[PinAnnotation class]])
	{
		if(v == nil)
		{
			v = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
			((MKPinAnnotationView *)v).pinColor = MKPinAnnotationColorRed;
			v.canShowCallout = NO;
			v.userInteractionEnabled = NO;
		}
	}
	return v;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
	if(sv == svDealsAndFinds)
	{
		int page = sv.contentOffset.x / sv.frame.size.width;
		findAndDealsPageControl.currentPage = page;
	}
}

-(void) layoutSubview {
	mainTableView.frame = self.view.bounds;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0)
		return @"COLLECT STARS";
	else if(section == 1)
		return @"DEALS & FINDS";
	else
		return @"SHOP INFO";
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0)
		return 3;
	else
		return 1;
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0)
		return 60;
	else if(indexPath.section == 1)
		return [shop.dealsAndFindItems count] > 2 ? 330 : 180;
	else 
	{
		if(shop.contactNo == nil || [shop.contactNo isEqualToString:@""])
			return 230;
		else
			return 260;
	}
}

-(float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 26;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *v = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	v.backgroundColor = PurpleColor;
	
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 200, HeaderHeight)];
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textColor = [UIColor whiteColor];
	lbl.text = [self tableView:tableView titleForHeaderInSection:section];
	[v addSubview:lbl];
	[lbl release];
	
	UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 25, tableView.frame.size.width, 1)];
	border.backgroundColor = [UIColor whiteColor];
	[v addSubview:border];
	[border release];
	
	
	if(section == 1)
	{
		UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 24, 0, 24, 24)];
		img.image = [UIImage imageNamed:@"icon_arrow.png"];
		img.contentMode = UIViewContentModeScaleAspectFit;
		[v addSubview:img];
		[img release];
		
		UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HeaderHeight)];
		[b addTarget:self action:@selector(changeToFindAndDealsDetail) forControlEvents:UIControlEventTouchUpInside];
		[v addSubview:b];
		[b release];
	}
	
	return v;

}

-(void) focusShopLocation {
	[mapView setCenterCoordinate:CLLocationCoordinate2DMake(shop.latitude, shop.longitude) animated:YES];
}

-(void) changeToFindAndDealsDetail {
	ItemListViewController *tmp = [[ItemListViewController alloc] initWithItems:shop.dealsAndFindItems];
	BaseViewHeaderInfo info = {shop.brand.logoURL, shop.brand.name, @"Deals And Finds"};
	tmp.headerInfo = info;
	
	tmp.headerStyle = BaseViewHeaderImageAndSubtitleStyle;
	
	[self pushViewController:tmp];
	[tmp release];
}


-(void) dealsAndFindItemsDidTouch: (FindAndDealsView *) view {
	ItemDetailViewController *tmp = [[ItemDetailViewController alloc] initWithItems:shop.dealsAndFindItems AndDisplayingItemIndex:view.tag - 2];
	tmp.headerStyle = BaseViewHeaderImageAndSubtitleStyle;
	BaseViewHeaderInfo info = {shop.brand.logoURL, shop.brand.name, @"Hot Item Details"};
	tmp.headerInfo = info;
	
	[self pushViewController:tmp];
	[tmp release];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
	
	if(indexPath.section == 0)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"starCell"];
		if(cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"starCell"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 57, 2, 52, 52)];
			v.image = starImage;
			v.contentMode = UIViewContentModeScaleAspectFit;
			[cell.contentView addSubview:v];
			[v release];
			
			UILabel *lbl = [[UILabel alloc] initWithFrame:v.frame];
			lbl.backgroundColor = [UIColor clearColor];
			lbl.textColor = [UIColor whiteColor];
			lbl.textAlignment = UITextAlignmentCenter;
			lbl.font = [UIFont boldSystemFontOfSize:14];
			lbl.tag = 4;
			[cell.contentView addSubview:lbl];
			[lbl release];
			
			UIImageView *instructionTypeImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 54, 54)];
			instructionTypeImg.tag = 1;
			instructionTypeImg.contentMode = UIViewContentModeScaleAspectFit;
			[cell.contentView addSubview:instructionTypeImg];
			[instructionTypeImg release];
			
			lbl = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 170, 20)];
			lbl.backgroundColor = [UIColor clearColor];
			lbl.font = [UIFont boldSystemFontOfSize:15];
			lbl.tag = 2;
			[cell.contentView addSubview:lbl];
			[lbl release];
			
			UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(65, 30, 170, 2)];
			tmp.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
			[cell.contentView addSubview:tmp];
			[tmp release];
			
			lbl = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 170, 20)];
			lbl.backgroundColor = [UIColor clearColor];
			lbl.textColor = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];
			lbl.font = [UIFont systemFontOfSize:13];
			lbl.tag = 3;
			[cell.contentView addSubview:lbl];
			[lbl release];
		}
		UIImageView *img = (UIImageView *) [cell.contentView viewWithTag:1];
		UILabel *lbl = (UILabel *) [cell.contentView viewWithTag:2];
		UILabel *sublbl = (UILabel *) [cell.contentView viewWithTag:3];
		UILabel *starLbl = (UILabel *) [cell.contentView viewWithTag:4];
		
		if(indexPath.row == 0)
		{
			img.image = [UIImage imageNamed:@"icon_instantreward.png"];
			lbl.text = @"1 Instant Surprise";
			sublbl.text = @"Secret";
			starLbl.text = @"15";
		}
		else if(indexPath.row == 1)
		{
			img.image = [UIImage imageNamed:@"icon_walkin.png"];
			lbl.text = @"Walk in";
			sublbl.text = @"Walk in for 60 Stars";
			starLbl.text = @"60";
		}
		else
		{
			img.image = [UIImage imageNamed:@"icon_scan.png"];
			lbl.text = @"5 Scan";
			sublbl.text = @"5 Items to Scan";
			starLbl.text = @"30";
		}

		return cell;
	}
	else if(indexPath.section == 1)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"findAndDeals"];
		if(cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"findAndDeals"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			float height = [self tableView:tableView heightForRowAtIndexPath:indexPath] - HeaderHeight;
			
			svDealsAndFinds = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
			svDealsAndFinds.backgroundColor = [UIColor clearColor];
			svDealsAndFinds.delegate = self;
			svDealsAndFinds.pagingEnabled = YES;
			[cell.contentView addSubview:svDealsAndFinds];
			
			CGRect f = svDealsAndFinds.frame;
			
			findAndDealsPageControl = [[SBPageControl alloc] initWithFrame:CGRectMake(f.origin.x, 
																					  f.size.height + f.origin.y - 10, 
																					  f.size.width, 
																					  HeaderHeight)];
			findAndDealsPageControl.hidesForSinglePage = YES;
			findAndDealsPageControl.backgroundColor = [UIColor clearColor];
			findAndDealsPageControl.defersCurrentPageDisplay = YES;
			[cell.contentView addSubview:findAndDealsPageControl];
			
			int y = 0; 
			int x = 0;
			int margin = 5;
			float width;
			
			int cnt = [shop.dealsAndFindItems count];
			
			if(cnt > 1)
				width = svDealsAndFinds.frame.size.width / 2 - 2 * margin;
			else
			{
				width = svDealsAndFinds.frame.size.width;
				margin = 0;
			}
			
			
			if(cnt > 2)
				height = svDealsAndFinds.frame.size.height / 2 - 2 * margin - 10;
			else
			{
				height = svDealsAndFinds.frame.size.height;
				if(cnt == 1)
					margin = 0;
			}
			
			for(int i=0; i<cnt; i++)
			{
				x = i * (width + 2 * margin); 
				if(cnt % 4 != 0)
				{
					if(i > cnt / 2)
					{
						y = height + margin / 2 + 15;
						x = (i - cnt / 2 - 1) * (width + 2 * margin);
					}
				}
				else {
					if(i >= cnt / 2)
					{
						y = height + margin / 2 + 15;
						x = (i - cnt / 2) * (width + 2 * margin);
					}
				}
				
				CGRect f = CGRectMake(x + margin, y + margin, width, height);
				FindAndDealsView *fdv = [[FindAndDealsView alloc] initWithItem:[shop.dealsAndFindItems objectAtIndex:i]];
				fdv.tag = i + 2;
				[fdv addTarget:self action:@selector(dealsAndFindItemsDidTouch:) forControlEvents:UIControlEventTouchUpInside];
				fdv.frame = f;
				[svDealsAndFinds addSubview:fdv];
				[fdv release];
			}

			if(cnt % 4 != 0)
				svDealsAndFinds.contentSize = CGSizeMake(svDealsAndFinds.frame.size.width * ((cnt / 4) + 1), svDealsAndFinds.frame.size.height);
			else
				svDealsAndFinds.contentSize = CGSizeMake(svDealsAndFinds.frame.size.width * cnt / 4, svDealsAndFinds.frame.size.height);

			f = svDealsAndFinds.bounds;
			f.size.width = svDealsAndFinds.contentSize.width;
			
			FindAndDealsBgView *bg = [[FindAndDealsBgView alloc] initWithFrame:f];
			bg.backgroundColor = [UIColor clearColor];
			bg.rowCnt = cnt >= 3 ? 2 : 1;
			bg.colCnt = cnt / 4 + 1;
			[svDealsAndFinds addSubview:bg];
			[svDealsAndFinds sendSubviewToBack:bg];
			[bg release];
			
			findAndDealsPageControl.numberOfPages = svDealsAndFinds.contentSize.width / svDealsAndFinds.frame.size.width;
			
			
			
		}
		return cell;
	}
	else
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopInfo"];
		if(cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"shopInfo"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
			img.image = [UIImage imageNamed:@"detail_icon_shopaddress.png"];
			img.contentMode = UIViewContentModeScaleAspectFit;
			[cell.contentView addSubview:img];
			[img release];
			
			UIButton *button = [[UIButton alloc] initWithFrame:img.frame];
			[button addTarget:self action:@selector(focusShopLocation) forControlEvents:UIControlEventTouchDown];
			[cell.contentView addSubview:button];
			[button release];
			
			
			UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(60, 5, tableView.frame.size.width - 60, 50)];
			tv.backgroundColor = [UIColor clearColor];
			tv.userInteractionEnabled = NO;
			tv.text = shop.address;
			tv.font = [UIFont systemFontOfSize:12];
			[cell.contentView addSubview:tv];
			tv.tag = 1;
			[tv release];
			
			
			mapView.frame = CGRectMake(0, 60, tableView.frame.size.width, tableView.frame.size.width / 2);
			[cell.contentView addSubview:mapView];
			
			CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(shop.latitude, shop.longitude);
			PinAnnotation *annotation = [[PinAnnotation alloc] initWithCoordinate:coor];
			[mapView addAnnotation:annotation];
			[mapView setRegion:MKCoordinateRegionMake(coor, MKCoordinateSpanMake(0.001, 0.001)) animated:NO];
			
			if(shop.contactNo != nil)
			{
				UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 70 + tableView.frame.size.width / 2, tableView.frame.size.width, 30)];
				[but setImage:[UIImage imageNamed:@"button_call.png"] forState:UIControlStateNormal];
				but.tag = 3;
				[cell.contentView addSubview:but];
				[but release];
				
				UILabel *lbl = [[UILabel alloc] initWithFrame:but.frame];
				lbl.backgroundColor = [UIColor clearColor];
				lbl.textColor = [UIColor whiteColor];
				lbl.textAlignment = UITextAlignmentCenter;
				lbl.font = [UIFont boldSystemFontOfSize:16];
				lbl.text = @"Call";
				lbl.tag = 4;
				[cell.contentView addSubview:lbl];
				[lbl release];
			}
			

		}
		
		return cell;
	}
}


- (void)viewDidUnload
{
	[mapView release];
	[svDealsAndFinds release];
	[findAndDealsPageControl release];
	[mainTableView release];
    [super viewDidUnload];
}


-(void) dealloc {
  	[mapView release];
	[svDealsAndFinds release];
	[findAndDealsPageControl release];
    [mainTableView release];
	
	[shop release];
	
	[starImage release];
	starImage = nil;
	
	[self.iconImage release];
	self.iconImage = nil;
    
    [super dealloc];
}

@end
