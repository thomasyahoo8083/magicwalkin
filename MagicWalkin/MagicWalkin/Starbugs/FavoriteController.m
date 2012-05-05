#import "FavoriteController.h"

@implementation FavoriteController



-(void) loadView {
	fvc = [[FavoritesViewController alloc] init];
	
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view.backgroundColor = [UIColor clearColor];
	
	navController = [[UINavigationController alloc] initWithRootViewController:fvc];
	navController.toolbarHidden = YES;
	navController.navigationBarHidden = YES;
	navController.view.backgroundColor = [UIColor clearColor];
	[self.view addSubview:navController.view];
}

-(UINavigationController *) navigationController {
    return navController;
}

-(void) layoutSubview {
    navController.view.frame = self.view.bounds;
	fvc.view.frame = navController.view.bounds;
	[fvc layoutSubview];
}

-(void) loadViewContent {
    [fvc loadViewContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)viewDidUnload
{
	[fvc release];
	[navController release];
	
    [super viewDidUnload];
}

-(void) dealloc {
	[fvc release];
	[navController release];
	[super dealloc];
}

@end
