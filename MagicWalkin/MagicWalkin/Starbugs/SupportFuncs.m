//
//  SupportFuncs.m
//  Henry
//

#import "SupportFuncs.h"
#import <sqlite3.h>
#import "Constant.h"

@implementation SupportFuncs

#pragma mark - Image Methods
+ (UIImage*)imageNamed:(NSString*)inputPath {
    UIImage     *img = nil;
    NSRange     rangeHTTP;
    
    rangeHTTP = [inputPath rangeOfString:@"http://"];      
    if (rangeHTTP.length)
        img = [UIImage imageNamed:@"MissingCross.png"];
    else {
        img = [UIImage imageWithContentsOfFile:inputPath];
        if (!img) {
            img = [UIImage imageNamed:inputPath];
            if (!img)
                img = [UIImage imageNamed:@"MissingCross.png"];
        }
    }
    
    return img;
}

#pragma mark - String Methods
+ (NSString*) charToString:(char*) c{
	NSString *s = @"";
	s = (c)?[NSString stringWithUTF8String:c]:@"";
	return s;
}

#pragma mark - Resources Methods
+ (NSString *) makeURLPath:(NSString *) name Ext:(NSString *) ext {
	NSBundle *bundle    = [NSBundle mainBundle];
	NSString *path      = [bundle bundlePath];
	NSString *filePath  = [NSBundle pathForResource:name ofType:ext inDirectory:path];
	return [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString * ) loadTextResource:(NSString *) name {
	NSBundle    *bundle     = [NSBundle mainBundle];
	NSString    *path       = [bundle bundlePath];
	NSString    *filePath   = [NSBundle pathForResource:name ofType:@"txt" inDirectory:path];
	NSData      *data       = [NSData dataWithContentsOfFile:filePath];
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

#pragma mark - Document Folder Methods
// Returns the path to the application's Documents directory.
+ (NSString *) applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void) createEditableCopyOfFileIfNeeded: (NSString *) filename {
    NSLog(@"{createEditableCopyOfFileIfNeed} filename = %@", filename);
	NSFileManager   *fileManager        = [NSFileManager defaultManager];
	NSString        *documentDirectory  = [self applicationDocumentsDirectory];
	NSString        *writableFilePath   = [documentDirectory stringByAppendingPathComponent:filename];
	
    NSLog(@"{createEditableCopyOfFileIfNeed} writableFilePath = %@", writableFilePath);
	BOOL fileExists = [fileManager fileExistsAtPath:writableFilePath];
	if (!fileExists) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
        NSLog(@"Default Path = %@",defaultDBPath);
		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableFilePath error:&error];
		if (!success) {
			NSAssert1(0, @"Failed to create file with message '%@'.", [error localizedDescription]);
		} else
            NSLog(@"{createEditableCopyOfFileIfNeed} Done");   
	}    
}

+ (BOOL) deleteFile: (NSString *) filename {
    NSLog(@"{deleteFile} filename = %@", filename);
    NSError         *error;
	NSFileManager   *fileManager        = [NSFileManager defaultManager];
	NSString        *documentDirectory  = [self applicationDocumentsDirectory];
	NSString        *writableFilePath   = [documentDirectory stringByAppendingPathComponent:filename];
	
	BOOL fileExists = [fileManager fileExistsAtPath:writableFilePath];
    if (!fileExists) {
        NSLog(@"{deleteFile} NOT EXISTS");
        return TRUE;
    } else {
        BOOL success = [fileManager removeItemAtPath:writableFilePath error:&error];
        if (!success)
            NSLog(@"{deleteFile} Error = %@", [error localizedDescription]);
        return success;
    }
}

+ (BOOL) isDatabaseVersionChanged: (NSString *) filename {
    NSLog(@"{isDatabaseVersionChanged} filename = %@", filename);
    NSFileManager   *fileManager        = [NSFileManager defaultManager];
	NSString        *documentDirectory  = [self applicationDocumentsDirectory];
	NSString        *writableDBPath     = [documentDirectory stringByAppendingPathComponent:filename];
    NSString        *defaultDBPath      = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    sqlite3         *writableDB, *bundleDB;
    sqlite3_stmt    *statement;
    NSString        *sql;
    NSString        *writableDBVersion, *bundleDBVersion;
    
    writableDBVersion   =   [NSString stringWithString:@""];
    bundleDBVersion     =   [NSString stringWithString:@""];
    if ([fileManager fileExistsAtPath:writableDBPath] && sqlite3_open([writableDBPath UTF8String], &writableDB) == SQLITE_OK){
        sql = [NSString stringWithFormat: @"SELECT Version FROM DBVersion"];      
        sqlite3_prepare_v2(writableDB, [sql UTF8String],  - 1, &statement, NULL);  
        if (sqlite3_step(statement) == SQLITE_ROW) {
            writableDBVersion = [self charToString:(char *)sqlite3_column_text(statement, 0)];
        } else 
            writableDBVersion = [NSString stringWithString:@""]; 
        sqlite3_finalize(statement);
        sqlite3_close(writableDB);
    }
    
    if (sqlite3_open([defaultDBPath  UTF8String], &bundleDB) == SQLITE_OK){
        sql = [NSString stringWithFormat: @"SELECT Version FROM DBVersion"];      
        sqlite3_prepare_v2(bundleDB, [sql UTF8String],  - 1, &statement, NULL);  
        if (sqlite3_step(statement) == SQLITE_ROW) {
            bundleDBVersion	= [self charToString:(char *)sqlite3_column_text(statement, 0)];
        } else
            bundleDBVersion = [NSString stringWithString:@""];
        sqlite3_finalize(statement);
        sqlite3_close(bundleDB);
    }
    
    if ([writableDBVersion compare:bundleDBVersion] != NSOrderedSame) {
        NSLog(@"{isDatabaseVersionChanged} Changed");
        return TRUE;
    } else {
        NSLog(@"{isDatabaseVersionChanged} Same");
        return FALSE;        
    }
}

#pragma mark - Get Area Methods

+ (NSMutableArray *) getArea:  (NSString *) filename byAreaGroup: (NSString *) areaGroupID {
	NSLog(@"{getArea} filename = %@", filename);
	
	NSString        *documentDirectory  = [self applicationDocumentsDirectory];
	NSString        *path				= [documentDirectory stringByAppendingPathComponent:filename];
    
	sqlite3			*database;
    sqlite3_stmt    *statement;
    NSString        *sql;
	
	// Open the database.
	if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		NSLog(@"Opening Database");
	} else {
		//Call close to properly clean up
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database: '%s'.", sqlite3_errmsg(database));
	}
	
	// The array of products that we weill create
	NSMutableArray *area = [[[NSMutableArray alloc] init] autorelease];
	
	sql = [NSString stringWithFormat: @"SELECT * FROM Area WHERE AreaGroupID=%@;",areaGroupID];      
	
	/*
     // The SQL statement that we plan on executing against the database
     const char *sql = "SELECT product.ID,product.Name, \
     Manufacturer.name,product.details,product.price,\
     product.quantityonhand,country.country, \
     product.image FROM Product,Manufacturer, \
     Country where manufacturer.manufacturerid=product.manufacturerid \
     and product.countryoforiginid=country.countryid";
	 */
	
	// Prepare the statement to compile the SQL query into byte-code
	int sqlResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
	
	if (sqlResult == SQLITE_OK) {
		NSLog(@"sqlResult: %d",sqlResult);
		// Step through the results - once for each row.
		while (sqlite3_step(statement) == SQLITE_ROW) {
			// allocate a Product object to add to products array
			NSMutableDictionary *areaDictionary = [[NSMutableDictionary alloc] init];
			
			// The second parameter is the column index (0 based) in the resutl set.
			char *areaID = (char *)sqlite3_column_text(statement, 0);
			char *areaGroupID = (char *)sqlite3_column_text(statement, 1);			
			char *areaChineseName = (char *)sqlite3_column_text(statement, 2);
			char *areaEnglishName = (char *)sqlite3_column_text(statement, 3);
			char *areaStatus = (char *)sqlite3_column_text(statement, 4);
			char *areaModifyTime = (char *)sqlite3_column_text(statement, 5);			
			char *areaCreateTime = (char *)sqlite3_column_text(statement, 6);
            
			
			[areaDictionary setObject:[NSString stringWithUTF8String:areaID] forKey:@"areaID"];
			[areaDictionary setObject:[NSString stringWithUTF8String:areaGroupID] forKey:@"areaGroupID"];
			[areaDictionary setObject:[NSString stringWithUTF8String:areaChineseName] forKey:@"areaChineseName"];
			[areaDictionary setObject:[NSString stringWithUTF8String:areaEnglishName] forKey:@"areaEnglishName"];
			[areaDictionary setObject:[NSString stringWithUTF8String:areaStatus] forKey:@"areaStatus"];
			[areaDictionary setObject:[NSString stringWithUTF8String:areaModifyTime] forKey:@"areaModifyTime"];			
			[areaDictionary setObject:[NSString stringWithUTF8String:areaCreateTime] forKey:@"areaCreateTime"];
			
			//NSString *testChineseChar = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];			
			//NSLog(@"testChineseChar is: %@",testChineseChar);
			
			// Set all the attributes of the product
            /*			product.ID = sqlite3_column_int(statement, 0);
             product.name = (name) ? [NSString stringWithUTF8String:name] : @"";
             product.manufacturer = (manufactruer) ? [NSString stringWithUTF8String:manufactruer] : @"";
             product.details = (details) ? [NSString stringWithUTF8String:details] : @"";
             product.price = sqlite3_column_double(statement, 4);
             product.quantity = sqlite3_column_int(statement, 5);
             product.countryOnOrigin = (countryOfOrgin) ? [NSString stringWithUTF8String:countryOfOrgin] : @"";
             product.image = (image) ? [NSString stringWithUTF8String:image] : @"";
             */
			
			// Add the areaDictionary to the area array
			[area addObject:areaDictionary];
			
			// Release the local product object because the object is retained when we add it to the array
			[areaDictionary release];
		}
		
		// finalize the statement to release its resources
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else {
		NSLog(@"Problem with the database:");
		NSLog(@"%d",sqlResult);
	}
	
	// return products array
	return area;
	
}

#pragma mark - Get District Methods

+ (NSMutableArray *) getDistrict:  (NSString *) filename byArea: (NSString *) areaID {
	NSLog(@"{getDistrict} filename = %@", filename);
	
	NSString        *documentDirectory  = [self applicationDocumentsDirectory];
	NSString        *path				= [documentDirectory stringByAppendingPathComponent:filename];
	
	sqlite3			*database;
    sqlite3_stmt    *statement;
    NSString        *sql;
	
	// Open the database.
	if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		NSLog(@"Opening Database");
	} else {
		//Call close to properly clean up
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database: '%s'.", sqlite3_errmsg(database));
	}
	
	// The array of products that we weill create
	NSMutableArray *district = [[[NSMutableArray alloc] init] autorelease];
    
	if ([areaID isEqualToString:@"all"]) {
		sql = @"SELECT * FROM District;";
	} else {
		sql = [NSString stringWithFormat: @"SELECT * FROM District WHERE AreaID=%@;",areaID];      
	}
	// Prepare the statement to compile the SQL query into byte-code
	int sqlResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
	
	if (sqlResult == SQLITE_OK) {
		NSLog(@"sqlResult: %d",sqlResult);
		// Step through the results - once for each row.
		while (sqlite3_step(statement) == SQLITE_ROW) {
			// allocate a Product object to add to products array
			NSMutableDictionary *districtDictionary = [[NSMutableDictionary alloc] init];
			
			// The second parameter is the column index (0 based) in the resutl set.
			char *districtID = (char *)sqlite3_column_text(statement, 0);
			char *areaID = (char *)sqlite3_column_text(statement, 1);			
			char *districtChineseName = (char *)sqlite3_column_text(statement, 2);
			char *districtEnglishName = (char *)sqlite3_column_text(statement, 3);
			char *districtLatitude = (char *)sqlite3_column_text(statement, 4);			
			char *districtLongitude = (char *)sqlite3_column_text(statement, 5);
			char *districtAllowNTTaxi = (char *)sqlite3_column_text(statement, 6);
			char *districtMileageCreditsMultiplier = (char *)sqlite3_column_text(statement, 7);
			char *districtStatus = (char *)sqlite3_column_text(statement, 8);			
			char *districtModifyTime = (char *)sqlite3_column_text(statement, 9);
			char *districtCreateTime = (char *)sqlite3_column_text(statement, 10);			
			
			
			[districtDictionary setObject:[NSString stringWithUTF8String:districtID] forKey:@"districtID"];
			[districtDictionary setObject:[NSString stringWithUTF8String:areaID] forKey:@"areaID"];
			[districtDictionary setObject:[NSString stringWithUTF8String:districtChineseName] forKey:@"districtChineseName"];
			[districtDictionary setObject:[NSString stringWithUTF8String:districtEnglishName] forKey:@"districtEnglishName"];
			[districtDictionary setObject:[NSString stringWithUTF8String:districtLatitude] forKey:@"districtLatitude"];
			[districtDictionary setObject:[NSString stringWithUTF8String:districtLongitude] forKey:@"districtLongitude"];			
			[districtDictionary setObject:[NSString stringWithUTF8String:districtAllowNTTaxi] forKey:@"districtAllowNTTaxi"];
			[districtDictionary setObject:[NSString stringWithUTF8String:districtMileageCreditsMultiplier] forKey:@"districtMileageCreditsMultiplier"];
			[districtDictionary setObject:[NSString stringWithUTF8String:districtStatus] forKey:@"districtStatus"];
			[districtDictionary setObject:[NSString stringWithUTF8String:districtModifyTime] forKey:@"districtModifyTime"];			
			[districtDictionary setObject:[NSString stringWithUTF8String:districtCreateTime] forKey:@"districtCreateTime"];						
			
			// Add the areaDictionary to the area array
			[district addObject:districtDictionary];
			
			// Release the local product object because the object is retained when we add it to the array
			[districtDictionary release];
		}
		
		// finalize the statement to release its resources
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else {
		NSLog(@"Problem with the database:");
		NSLog(@"%d",sqlResult);
	}
	
	// return products array
	return district;
	
}

#pragma mark - dealloc

- (void)dealloc
{
    NSLog(@"[SupportFuncs]{dealloc}");
    [super dealloc];
}

@end