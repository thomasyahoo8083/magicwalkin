
#import "FavoritesViewController.h"

@implementation FavoritesViewController

-(id) init {
	self = [super init];
	
	if(self)
	{
		[self initTopTenItems];
		self.iconImage = [[UIImage imageNamed:@"icon_fav.png"] retain];
		self.title = @"FAVORITES";
	}
	return self;
}


-(void) initTopTenItems {
	Brand *b = [[Brand alloc] init];
	b.name = @"Adidas";
	b.logoURL = @"http://www.pixel77.com/wp-content/uploads/2012/01/adidas-logo.jpg";
	
	topTenItems[0] = [[PromotionItem alloc] initWithBrand:b];
	topTenItems[0].description = @"Big Sales! 20% Off of the Original Price";
	[topTenItems[0].imageUrls addObject:@"http://api.ning.com/files/aM7ET3wGQuLXpiWxSmA61ty04Vx0Cr881fmONRIprmCjGL5wnWqdVFRqUSCbDEI9RmgbRq1MHRjmKc03Dr0*Yowq5cMmr5in/adiRunvoucher2012.jpg"];
	[b release];
	
	
	
	b = [[Brand alloc] init];
	b.name = @"ZARA";
	b.logoURL = @"http://kalejdoskop.wroclaw.pl/wp-content/uploads/2011/12/zara-logo.jpg";
	topTenItems[1] = [[PromotionItem alloc] initWithBrand:b];
	topTenItems[1].description = @"ZARA New Year Sales";
	[topTenItems[1].imageUrls addObject:@"http://lh6.ggpht.com/_X9_qmS-o_Pc/TRgyoWocYvI/AAAAAAAAC5I/1sGEVmTOZ20/zara-New-Year-sale%5B9%5D.jpg"];
	[b release];
	
	for(int i=2; i<10; i++)
	{
		b = [[Brand alloc] init];
		b.name = @"ZARA";
		b.logoURL = @"http://kalejdoskop.wroclaw.pl/wp-content/uploads/2011/12/zara-logo.jpg";
		topTenItems[i] = [[PromotionItem alloc] initWithBrand:b];
		topTenItems[i].description = @"ZARA New Year Sales";
		[topTenItems[i].imageUrls addObject:@"http://lh6.ggpht.com/_X9_qmS-o_Pc/TRgyoWocYvI/AAAAAAAAC5I/1sGEVmTOZ20/zara-New-Year-sale%5B9%5D.jpg"];
		[b release];

	}
	
}

-(void) loadView {
	self.view = [[UIScrollView alloc] initWithFrame:CGRectZero];
	
	vTopTenFaves = [[UIBorderView alloc] initWithFrame:CGRectZero];
	vTopTenFaves.border = BorderBottom;
	vTopTenFaves.backgroundColor = [UIColor clearColor];
	vTopTenFaves.autoresizesSubviews = YES;
	[self.view addSubview:vTopTenFaves];
	
	//Top Bar
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vTopTenFaves.frame.size.width, HeaderHeight)];
	v.backgroundColor = PurpleColor;
	v.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	v.autoresizesSubviews = YES;
	[vTopTenFaves addSubview:v];
	[v release];
	
	UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, HeaderHeight)];
	l.text = @"TOP 10 FAVES";
	l.textColor = [UIColor whiteColor];
	l.backgroundColor = [UIColor clearColor];
	l.font = [UIFont systemFontOfSize:15];
	[v addSubview:l];
	
	UIBorderView *bv = [[UIBorderView alloc] initWithFrame:CGRectMake(240, 0, 60, HeaderHeight)];
	bv.backgroundColor = [UIColor clearColor];
	bv.border = BorderLeft;
	bv.borderMargin = 2;
	bv.borderColor = [UIColor whiteColor];
	[v addSubview:bv];
	[bv release];
	
	lblTopTenRank = [[UILabel alloc] initWithFrame:bv.frame];
	lblTopTenRank.backgroundColor = [UIColor clearColor];
	lblTopTenRank.textColor = [UIColor whiteColor];
	lblTopTenRank.text = @"NO.1";
	lblTopTenRank.font = [UIFont systemFontOfSize:15];
	lblTopTenRank.textAlignment = UITextAlignmentCenter;
	[v addSubview:lblTopTenRank];
	
	
	svtopTen = [[UIScrollView alloc] initWithFrame:CGRectZero];
	svtopTen.backgroundColor = [UIColor clearColor];
	svtopTen.pagingEnabled = YES;
	svtopTen.showsHorizontalScrollIndicator = NO;
	svtopTen.showsVerticalScrollIndicator = NO;
	svtopTen.delegate = self;
	svtopTen.autoresizesSubviews = YES;
	[vTopTenFaves addSubview:svtopTen];
	
	
	for(int i=0; i<10; i++)
	{
		NSString *url = [topTenItems[i].imageUrls objectAtIndex:0];
		AsyncImageView *iv = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		iv.contentMode = UIViewContentModeScaleAspectFill;
		iv.imageURL = url;
		[svtopTen addSubview:iv];
		
		if(i == 0)
			[iv loadImage];
		
		[iv release];
	}
	
	vTopTenOverlay = [[UIView alloc] initWithFrame:CGRectZero];
	vTopTenOverlay.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.8];
	[vTopTenFaves addSubview:vTopTenOverlay];

	ivTopTenOverlayLogo = [[AsyncImageView alloc] initWithFrame:CGRectMake(2, 2, 25, 25)];
	ivTopTenOverlayLogo.backgroundColor = [UIColor clearColor];
	ivTopTenOverlayLogo.imageURL = topTenItems[0].brand.logoURL;
	ivTopTenOverlayLogo.contentMode = UIViewContentModeScaleAspectFit;
	[ivTopTenOverlayLogo loadImage];
	[vTopTenOverlay addSubview:ivTopTenOverlayLogo];

	lblTopTenOverlayBrand = [[UILabel alloc] initWithFrame:CGRectMake(30, 4, 70, 20)];
	lblTopTenOverlayBrand.textColor = [UIColor blackColor];
	lblTopTenOverlayBrand.backgroundColor = [UIColor clearColor];
	lblTopTenOverlayBrand.font = [UIFont boldSystemFontOfSize:13];
	lblTopTenOverlayBrand.text = topTenItems[0].brand.name;
	[vTopTenOverlay addSubview:lblTopTenOverlayBrand];

	lblTopTenOverlayDescription = [[UILabel alloc] initWithFrame:CGRectMake(100, 4, 200, 20)];
	lblTopTenOverlayDescription.textColor = PurpleColor;
	lblTopTenOverlayDescription.backgroundColor = [UIColor clearColor];
	lblTopTenOverlayDescription.font = [UIFont boldSystemFontOfSize:12];
	lblTopTenOverlayDescription.adjustsFontSizeToFitWidth = YES;
	lblTopTenOverlayDescription.textAlignment = UITextAlignmentRight;
	lblTopTenOverlayDescription.text = topTenItems[0].description;
	[vTopTenOverlay addSubview:lblTopTenOverlayDescription];
	
	topTenPageControl = [[SBPageControl alloc] initWithFrame:CGRectZero];
	topTenPageControl.numberOfPages = 10;
	topTenPageControl.backgroundColor = [UIColor clearColor];
	topTenPageControl.defersCurrentPageDisplay = YES;
	topTenPageControl.currentPage = 0;
	[self.view addSubview:topTenPageControl];
	
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if(scrollView == svtopTen)
	{
		int page = svtopTen.contentOffset.x / svtopTen.frame.size.width;
		lblTopTenRank.text = [NSString stringWithFormat:@"NO.%d", page+1];
		topTenPageControl.currentPage = page;
		ivTopTenOverlayLogo.imageURL = topTenItems[page].brand.logoURL;
		[ivTopTenOverlayLogo loadImage];
		lblTopTenOverlayBrand.text = topTenItems[page].brand.name;
		lblTopTenOverlayDescription.text = topTenItems[page].description;
		
		AsyncImageView *v = (AsyncImageView *) [svtopTen.subviews objectAtIndex:page];
		[v loadImage];
	}
}

-(void) layoutSubview {
	float width = self.view.frame.size.width;
	
	vTopTenFaves.frame = CGRectMake(0, 0, width, 142);
	topTenPageControl.frame = CGRectMake(0, 142,  width, 20);
	svtopTen.frame = CGRectMake(0, HeaderHeight, vTopTenFaves.frame.size.width, vTopTenFaves.frame.size.height - 29);
	lblTopTenOverlayDescription.frame = CGRectMake(svtopTen.frame.size.width - 200, 2, 200, 20);
	
	CGRect rect = svtopTen.frame;
	rect.origin.y = rect.origin.y + rect.size.height - 25;
	rect.size.height = 25;
	vTopTenOverlay.frame = rect;
	
	int cnt = [svtopTen.subviews count];
	for(int i=0; i<cnt; i++)
	{
		UIView *v = [svtopTen.subviews objectAtIndex:i];
		v.frame = CGRectMake(i * svtopTen.frame.size.width, 0, svtopTen.frame.size.width, svtopTen.frame.size.height);
	}
	
	svtopTen.contentSize = CGSizeMake(svtopTen.frame.size.width * 10, svtopTen.frame.size.height);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
	
	[lblTopTenRank release];
	[svtopTen release];
	
	[ivTopTenOverlayLogo release];
	[lblTopTenOverlayBrand release];
	[lblTopTenOverlayDescription release];
	
	[vTopTenOverlay release];
	[vTopTenFaves release];
	[topTenPageControl release];
	
	[super viewDidUnload];
}

-(void) dealloc {
	[self.iconImage release];
	[super dealloc];
}


@end
