#import "NearByViewController.h"


@implementation NearByViewController

-(id) init {
	self = [super init];
	if(self)
	{
		shopManager = [[ShopManager alloc] init];
		shopManager.delegate = self;
		self.title = @"NEARBY";
		self.iconImage = [[UIImage imageNamed:@"icon_nearby.png"] retain];
		nearestShops = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) loadViewContent {
    
	[shopManager getNearestShopFromCurrentLocation];
}


-(void) shopManager:(ShopManager *)manager nearestShopUpdated:(NSArray *)shops {
	
	[nearestShops removeAllObjects];
	[nearestShops addObjectsFromArray:shops];
	
	[listView reloadData];
	
	if(self.delegate != nil)
		[self.delegate baseViewDidEndLoading: self];
}

-(void) shopManager:(ShopManager *)manager FailToUpdateLocationWithError:(NSError *)error {
    @throw [NSString stringWithFormat: @"Shop Manager cannot update location with error: %@", error.description];
}


-(void) loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	
	topBar = [[UIView alloc] initWithFrame:CGRectZero];
	topBar.backgroundColor = PurpleColor;
	[self.view addSubview:topBar];
	
	vLeft = [[UIBorderView alloc] initWithFrame:CGRectZero];
	vLeft.backgroundColor = [UIColor clearColor];
	vLeft.border = BorderRight;
	vLeft.borderColor = [UIColor whiteColor];
	vLeft.borderMargin = 2;
	[topBar addSubview:vLeft];
	
	UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 14, 14)];
	iv.image = [UIImage imageNamed:@"icon_list.png"];
	iv.contentMode = UIViewContentModeScaleAspectFit;
	[vLeft addSubview:iv];
	[iv release];
	
	lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 50, HeaderHeight)];
	lblLeft.backgroundColor = [UIColor clearColor];
	lblLeft.textColor = [UIColor whiteColor];
	lblLeft.text = @"LIST";
	[vLeft addSubview:lblLeft];
	
	vRight = [[UIBorderView alloc] initWithFrame:CGRectZero];
	vRight.backgroundColor = [UIColor clearColor];
	vRight.border = BorderLeft;
	vRight.borderColor = [UIColor whiteColor];
	vRight.borderMargin = 2;
	[topBar addSubview:vRight];
	
	
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(50, 4, 14, 14)];
	iv.image = [UIImage imageNamed:@"icon_map.png"];
	iv.contentMode = UIViewContentModeScaleAspectFit;
	[vRight addSubview:iv];
	[iv release];
	
	lblRight = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, HeaderHeight)];
	lblRight.backgroundColor = [UIColor clearColor];
	lblRight.textColor = [UIColor whiteColor];
	lblRight.text = @"MAP";
	[vRight addSubview:lblRight];
	
	vRight.alpha = 0.3;
	
	listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	listView.dataSource = self;
	listView.delegate = self;

	[self.view addSubview:listView];
	
	starImage = [[UIImage imageNamed:@"star.png"] retain];
	isChangingView = NO;
	showingList = YES;
}

-(void) layoutSubview {
	
	if(!isChangingView)
	{
		float width = self.view.frame.size.width;

		topBar.frame = CGRectMake(0, 0, width, HeaderHeight);
		listView.frame = CGRectMake(0, HeaderHeight, width, self.view.frame.size.height - HeaderHeight);
		vLeft.frame = CGRectMake(0, 0, 70, topBar.frame.size.height);
		vRight.frame = CGRectMake(width - 70, 0, 70, topBar.frame.size.height);
	}
	isChangingView = NO;
}

-(void) changeToListView {
	if(!showingList)
	{
		isChangingView = YES;
		listView.frame = CGRectMake(-self.view.frame.size.width, HeaderHeight, self.view.frame.size.width, self.view.frame.size.height - HeaderHeight);
		
		theMapView.alpha = 0;
		[UIView beginAnimations:nil context:nil];
		vLeft.alpha = 1;
		vRight.alpha = 0.3;
		
		CGRect frame = listView.frame;
		frame.origin.x += frame.size.width;
		listView.frame = frame;
		
		listView.alpha = 1;
		
		
		frame = theMapView.frame;
		frame.origin.x += frame.size.width;
		theMapView.frame = frame;
		
		theMapView.alpha = 0;
		
		[UIView commitAnimations];
		showingList = YES;
	}
	
}


-(void) addPinsToMap {
	int cnt = [nearestShops count];
	for(int i=0; i < cnt; i++)
	{
		Shop *shop = [nearestShops objectAtIndex:i];
		ShopAnnotation *annotation = [[ShopAnnotation alloc] initWithShop:shop];
		[theMapView addAnnotation:annotation];
		[annotation release];
	}

}

-(void) changeToMapView {
	
	if(showingList) 
	{
		if(theMapView == nil)
		{
			theMapView = [[MKMapView alloc] initWithFrame:CGRectZero];
			theMapView.layer.borderColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1].CGColor;
			theMapView.layer.borderWidth = 1;
			theMapView.showsUserLocation = YES;
			theMapView.delegate = self;
			[self.view addSubview:theMapView];
				
			[self addPinsToMap];
		}
		
		theMapView.frame = CGRectMake(self.view.frame.size.width, 32, self.view.frame.size.width, self.view.frame.size.height - 42);
		theMapView.alpha = 0;

		
		[UIView beginAnimations:nil context:nil];
		vLeft.alpha = 0.3;
		vRight.alpha = 1;
		
		CGRect frame = listView.frame;
		frame.origin.x -= frame.size.width;
		listView.frame = frame;
		
		listView.alpha = 0;
		
		frame = theMapView.frame;
		frame.origin.x -= frame.size.width;
		theMapView.frame = frame;
		theMapView.alpha = 1;
		
		[UIView commitAnimations];
		showingList = NO;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	vLeft.touchCallback = @selector(changeToListView);
	vLeft.touchCallbackTarget = self;
	
	vRight.touchCallback = @selector(changeToMapView);
	vRight.touchCallbackTarget = self;
}

- (void)viewDidUnload
{
	[listView release];
	[topBar release];
	[vLeft release];
	[lblLeft release];
	
	[vRight release];
	[lblRight release];
	
	[theMapView release];
	[starImage release];
	[shopManager release];
	
	[super viewDidUnload];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Shop *shop = [nearestShops objectAtIndex:indexPath.row];
	
	if([shop.address length] < 65)
		return 60;
	else {
		return 70;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [nearestShops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
	
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
		UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 75, (height - 55) / 2 , 55, 55)];
		v.image = starImage;
		v.tag = 7;
		v.contentMode = UIViewContentModeScaleAspectFit;
		[cell.contentView addSubview:v];
		[v release];
		
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 75, (height - 55) / 2, 55, 57)];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textColor = [UIColor whiteColor];
		lbl.textAlignment = UITextAlignmentCenter;
		lbl.font = [UIFont boldSystemFontOfSize:14];
		lbl.tag = 5;
		[cell.contentView addSubview:lbl];
		[lbl release];
		
		v = [[AsyncImageView alloc] initWithFrame:CGRectMake(3, 5, 45, 45)];
		v.tag = 1;
		v.contentMode = UIViewContentModeScaleAspectFit;
		[cell.contentView addSubview:v];
		[v release];
		
		v = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 15, (height - 15) / 2, 15, 15)];
		v.image = [UIImage imageNamed:@"icon_arrow.png"];
		v.contentMode = UIViewContentModeScaleAspectFit;
		[cell.contentView addSubview:v];
		v.tag = 6;
		[v release];
		
		/*
		UIBorderView *bv = [[UIBorderView alloc] initWithFrame:CGRectMake(70, 10, 150, 20)];
		bv.border = BorderBottom;
		bv.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
		bv.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:bv];
		[bv release];
		*/
        
		lbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 150, 20)];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textColor = [UIColor blackColor];
		lbl.tag = 2;
		lbl.font = [UIFont boldSystemFontOfSize:16];
		[cell.contentView addSubview:lbl];
		[lbl release];
		
		
		
		UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(62, 15, 170, height - 25)];
		tv.userInteractionEnabled = NO;
		tv.backgroundColor = [UIColor clearColor];
		tv.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
		tv.font = [UIFont systemFontOfSize:10];
		tv.tag = 3;
		[cell.contentView addSubview:tv];
		[tv release];
		
		
	}
	
	Shop *shop = [nearestShops objectAtIndex:indexPath.row];
	AsyncImageView *logoView = (AsyncImageView *) [cell.contentView viewWithTag:1];
	logoView.imageURL = shop.brand.logoURL;
	[logoView loadImage];
	
	UILabel *lblName = (UILabel *) [cell.contentView viewWithTag:2];
	lblName.text = shop.brand.name;
	
	UITextView *lblAddress = (UITextView *) [cell.contentView viewWithTag:3];
	CGRect f = lblAddress.frame;
	f.size.height = height - f.origin.y;
	lblAddress.frame = f;
	lblAddress.text = shop.address;
	
	UILabel *lblTotalStar = (UILabel *) [cell.contentView viewWithTag:5];
	lblTotalStar.text = [NSString stringWithFormat:@"%d", shop.totalStarCanEarnToday];
	
	UIImageView *lblarrow = (UIImageView *) [cell.contentView viewWithTag:6];
	f = lblarrow.frame;
	f.origin.y = (height - f.size.height) / 2;
	lblarrow.frame = f;
	
	UIView *v = [cell.contentView viewWithTag:5];
	f = v.frame;
	f.origin.y = (height - f.size.height) / 2;
	v.frame = f;
	
	v = [cell.contentView viewWithTag:1];
	f = v.frame;
	f.origin.y = (height - f.size.height) / 2;
	v.frame = f;
	
	v = [cell.contentView viewWithTag:7];
	f = v.frame;
	f.origin.y = (height - f.size.height) / 2;
	v.frame = f;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	isChangingView = YES;
	Shop *shop = [nearestShops objectAtIndex:indexPath.row];
	BaseViewController *tmp = [[ShopDetailsViewController alloc] initWithShop:shop];
	[self pushViewController:tmp];
	[tmp release];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if([annotation isKindOfClass:[ShopAnnotation class]])
	{
		ShopAnnotationView *anView = (ShopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"shop"];
		if(anView == nil)
		{
			anView = [[ShopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"shop"];
		}
			
		return anView;
	}
	else {
		return nil;
	}
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	
	if([view isKindOfClass:[ShopAnnotationView class]])
	{
		ShopAnnotationView *v = (ShopAnnotationView *) view;
		ShopAnnotation *anno = (ShopAnnotation *) v.annotation;
		ShopDetailsViewController *tmp = [[ShopDetailsViewController alloc] initWithShop:anno.shop];
		[self pushViewController:tmp];
		[tmp release];
		
	}
}



@end
