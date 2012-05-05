#import "NearByController.h"

@implementation NearByController


-(void) loadView {
	fvc = [[NearByViewController alloc] init];
	[fvc setDelegate:self];
    
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view.backgroundColor = [UIColor clearColor];
	
	navController = [[UINavigationController alloc] initWithRootViewController:fvc];
	navController.toolbarHidden = YES;
	navController.navigationBarHidden = YES;
	navController.view.clipsToBounds = NO;
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
