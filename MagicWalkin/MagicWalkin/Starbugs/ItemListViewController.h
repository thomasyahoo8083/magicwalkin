#import <Foundation/Foundation.h>
#import "Shop.h"
#import "Constant.h"
#import "BaseViewController.h"
#import "ItemDetailViewController.h"

@interface ItemListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
	UITableView *mainTableView;
	NSArray *_items;
}


-(id) initWithItems: (NSArray *) items;

@end
