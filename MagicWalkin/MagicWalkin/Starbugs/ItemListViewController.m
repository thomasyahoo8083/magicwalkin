#import "ItemListViewController.h"

@implementation ItemListViewController

-(id) initWithItems: (NSArray *) items {
	self = [super init];
	if(self)
	{
		_items = [items retain];
		self.title = @"DEALS & FINDS";
		self.iconImage = [UIImage imageNamed:@"icon_back.png"];
	} 
	
	return self;
}


-(void) loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	mainTableView.delegate = self;
	mainTableView.dataSource = self;
	mainTableView.rowHeight = 100;
	[self.view addSubview:mainTableView];
}

-(void) layoutSubview {
	mainTableView.frame = self.view.frame;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"DEALS & FINDS";
}

-(float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return HeaderHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *v = [[[UIView alloc] initWithFrame:CGRectZero ] autorelease];
	v.backgroundColor = PurpleColor;
	
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, HeaderHeight)];
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textColor = [UIColor whiteColor];
	lbl.text = [self tableView:tableView titleForHeaderInSection:section];
	[v addSubview:lbl];
	[lbl release];
	
	return v;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		
		UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, tableView.rowHeight - 10, tableView.rowHeight - 10)];
		img.contentMode = UIViewContentModeScaleAspectFill;
		img.clipsToBounds = YES;
		img.tag = 1;
		[cell.contentView addSubview:img];	
		[img release];
		
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(tableView.rowHeight, 5, tableView.frame.size.width - tableView.rowHeight - 20, 24)];
		lbl.tag = 2;
		lbl.backgroundColor = [UIColor clearColor];
		lbl.font = [UIFont boldSystemFontOfSize:14];
		[cell.contentView addSubview:lbl];
		CGRect f = lbl.frame;
		[lbl release];
		
		UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(f.origin.x - 7, 
																	  f.origin.y + f.size.height - 7, 
																	  f.size.width , 
																	  tableView.rowHeight - f.origin.y - f.size.height)];
		tv.tag = 3;
		tv.textColor = [UIColor colorWithRed:0.4 green:.4 blue:.4 alpha:1];
		tv.userInteractionEnabled = NO;
		[cell.contentView addSubview:tv];
		[tv release];
		
		img = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 15, (tableView.rowHeight - 15) / 2, 15, 15)];
		img.contentMode = UIViewContentModeScaleAspectFit;
		img.image = [UIImage imageNamed:@"icon_arrow.png"];
		img.clipsToBounds = YES;
		[cell.contentView addSubview:img];	
		[img release];
		
	}
	
	Item *item = [_items objectAtIndex:indexPath.row];
	
	UIImageView *img = (UIImageView *) [cell.contentView viewWithTag:1];
	img.image = [UIImage imageNamed:[item.imageUrls  objectAtIndex:0]];
	
	UILabel *lbl = (UILabel *) [cell.contentView viewWithTag:2];
	lbl.text = item.name;
	
	UITextView *tv = (UITextView *)[cell.contentView viewWithTag:3];
	tv.text = item.description;
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ItemDetailViewController *tmp = [[ItemDetailViewController alloc] initWithItems:_items AndDisplayingItemIndex:indexPath.row];
	BaseViewHeaderInfo info = {self.headerInfo.imageURL, self.headerInfo.title, @"Hot Item Details"};
	tmp.headerInfo = info;
	tmp.headerStyle = self.headerStyle;
	
	[self pushViewController:tmp];
	[tmp release];
}

-(void) viewDidUnload {
	[mainTableView release];
	[super viewDidUnload];
}


-(void) dealloc {
	
	[mainTableView release];
	[_items release];
	
	[super dealloc];
}

@end
