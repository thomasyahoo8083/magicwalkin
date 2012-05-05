//
//  ThreadHTTPGet.m
//  eSave
//
//  Created by Micro Cheng on 24/06/2010.
//  Copyright 2010 Legato Technologies Ltd. All rights reserved.
//

#import "ThreadHTTPGet.h"

@interface SimpleAppDelegate : NSObject {   
}
//-(void) showNetworkBusy;
//-(void) hideNetworkBusy;

@end 

@implementation ThreadHTTPGet

@synthesize connection;
@synthesize tmpFilePath;
@synthesize fileStream;
@synthesize targetFilePath;
@synthesize myTag;
@synthesize delegate;
@synthesize bCallBack;
@synthesize bSaveFile;
@synthesize bUploadFile;

- (void) EndConnection:(BOOL) normalClose {
	//SimpleAppDelegate *appD = (SimpleAppDelegate*)[[UIApplication sharedApplication] delegate];
	//[appD hideNetworkBusy];
    
	if (self.connection != nil)
	{
		[self.connection cancel];
		self.connection = nil;
	}
	if (self.fileStream != nil)
	{
		[self.fileStream close];
		self.connection = nil;
	}
	if (self.bUploadFile) {
		NSLog(@"End Connection");
		NSData *tData = [NSData dataWithContentsOfFile:self.tmpFilePath];
		[self.delegate didFinishHttpUpload:normalClose tagInfo:self.myTag data:tData];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:self.tmpFilePath error:NULL];
		self.tmpFilePath = nil;
	} else if (self.tmpFilePath != nil)
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (normalClose)
		{
			if (bSaveFile) {
                [fileManager removeItemAtPath:self.targetFilePath error:NULL];
				[fileManager moveItemAtPath:self.tmpFilePath toPath:self.targetFilePath error:NULL];
				[self.delegate didFinishHttpSave:normalClose tagInfo:self.myTag];
			}
			else if (bCallBack)
			{
				NSData *tData = [NSData dataWithContentsOfFile:self.tmpFilePath];
				[self.delegate didFinishHttpGet:normalClose tagInfo:self.myTag data:tData];
			}
		}
		else if (bCallBack)
		{
			if (bSaveFile)
				[self.delegate didFinishHttpSave:normalClose tagInfo:self.myTag];
			else
				[self.delegate didFinishHttpGet:normalClose tagInfo:self.myTag data:nil];
		}
		
		[fileManager removeItemAtPath:self.tmpFilePath error:NULL];
		self.tmpFilePath = nil;
	}
	self.bUploadFile=NO;
	self.bCallBack=NO;
	self.bSaveFile=NO;
}

- (void) connection:(NSURLConnection *) tConnection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse * httpResponse;
	//    NSString *          contentTypeHeader;
	
	httpResponse = (NSHTTPURLResponse *) response;
	if ((httpResponse.statusCode / 100) != 2) {
		[self EndConnection:NO];
	}
	NSLog(@"HTTP Response: %d",httpResponse.statusCode);
}

- (void) connection:(NSURLConnection *) tConnection didReceiveData:(NSData *) tData {
    //#pragma unused(theConnection)
    NSInteger       dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
	
    assert(tConnection == self.connection);
    
    dataLength = [tData length];
    dataBytes  = [tData bytes];
	
    bytesWrittenSoFar = 0;
	if (dataLength > 0) {
		do {
			bytesWritten = [self.fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
			assert(bytesWritten != 0);
			if (bytesWritten == -1) {
				[self EndConnection:NO];
				break;
			} else {
				bytesWrittenSoFar += bytesWritten;
			}
		} while (bytesWrittenSoFar != dataLength);	
	}
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
	[self EndConnection:NO];
	NSLog(@"error:%d - %@",[error code],[error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
	[self EndConnection:YES];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
    assert(result != nil);
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

-(void) Open:(NSString *)URLPath tagInfo:(NSString *)tTag timeOut:(float) defTimeout {
	NSURL *url =[NSURL URLWithString:URLPath];
	NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:defTimeout];
	
	self.myTag = [[NSString alloc] initWithString:tTag];
	
	self.bCallBack=YES;
	self.bSaveFile=NO;
	
	self.tmpFilePath = [self pathForTemporaryFileWithPrefix:@"Get"];
	self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.tmpFilePath append:NO];
	[self.fileStream open];
	//SimpleAppDelegate *appD = (SimpleAppDelegate*)[[UIApplication sharedApplication] delegate];
	//[appD showNetworkBusy];
	self.connection = [NSURLConnection connectionWithRequest:req delegate:self];	
}

-(void) Open:(NSString *)URLPath tagInfo:(NSString *)tTag {
	[self Open:[NSString stringWithString:URLPath] tagInfo:[NSString stringWithString:tTag] timeOut:18.0];
}

-(void) Open:(NSString *) URLPath savePath:(NSString *) saveName tagInfo:(NSString *) tTag timeOut:(float) defTimeout{
	NSURL *url =[NSURL URLWithString:URLPath];
	NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:defTimeout];
	
	self.targetFilePath = [[NSString alloc] initWithString:saveName];
	self.myTag = [[NSString alloc] initWithString:tTag];
    
	self.bCallBack=YES;
	self.bSaveFile=YES;
	
	self.tmpFilePath = [self pathForTemporaryFileWithPrefix:@"Get"];
	self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.tmpFilePath append:NO];
	[self.fileStream open];
	//SimpleAppDelegate *appD = (SimpleAppDelegate*)[[UIApplication sharedApplication] delegate];
	//[appD showNetworkBusy];
	
	self.connection = [NSURLConnection connectionWithRequest:req delegate:self];
	[self.connection start];
}

-(void) Open:(NSString *) URLPath savePath:(NSString*)saveName tagInfo:(NSString *)tTag {
	[self Open:[NSString stringWithString:URLPath] savePath:[NSString stringWithString:saveName] tagInfo:[NSString stringWithString:tTag] timeOut:18.0];
}

-(void) Open:(NSString *) URLPath savePath:(NSString *) saveName timeOut:(float) defTimeout{
	NSURL *url =[NSURL URLWithString:URLPath];
	NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:defTimeout];
	
	self.targetFilePath = [[NSString alloc] initWithString:saveName];
	self.bCallBack=NO;
	self.bSaveFile=YES;
	
	self.tmpFilePath = [self pathForTemporaryFileWithPrefix:@"Get"];
	self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.tmpFilePath append:NO];
	[self.fileStream open];
	
	//SimpleAppDelegate *appD = (SimpleAppDelegate*)[[UIApplication sharedApplication] delegate];
	//[appD showNetworkBusy];
	self.connection = [NSURLConnection connectionWithRequest:req delegate:self];
	[self.connection start];
}

-(void) Open:(NSString *) URLPath savePath:(NSString *) saveName {
	[self Open:[NSString stringWithString:URLPath] savePath:[NSString stringWithString:saveName] timeOut:60.0];
}

-(void) PostData:(NSString *) URLPath DataString:(NSString *) oData tag:(NSString *) tTag timeOut:(float) defTimeout{
	
	NSURL *url =[NSURL URLWithString:URLPath];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:defTimeout];
	NSData *postData = [oData dataUsingEncoding:NSUTF8StringEncoding];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	self.myTag = [[NSString alloc] initWithString:tTag];
	
	self.bCallBack=YES;
	self.bSaveFile=NO;
	
	self.tmpFilePath = [self pathForTemporaryFileWithPrefix:@"Get"];
	self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.tmpFilePath append:NO];
	[self.fileStream open];
	//SimpleAppDelegate *appD = (SimpleAppDelegate*)[[UIApplication sharedApplication] delegate];
	//[appD showNetworkBusy];
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	[self.connection start];
}

- (void) PostData:(NSString *)URLPath DataString:(NSString *)oData tag:(NSString *)tTag {
	[self PostData:URLPath DataString:oData tag:tTag timeOut:60.0];
}

- (void)postUpload:(NSString *)url
				  :(NSDictionary *)requestData
				  :(NSString *)filePath
                  :(NSString *)contentType
                  :(NSString *)tTag
{
	NSURL *theURL = [NSURL URLWithString:url];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL 
															  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
														  timeoutInterval:180.0f];
    
	self.bUploadFile=YES;
	self.myTag = [[NSString alloc] initWithString:tTag];
	[theRequest setHTTPMethod:@"POST"];
	
	// define post boundary...
	NSString *boundary = [[[NSProcessInfo processInfo] globallyUniqueString] substringToIndex:10];
	NSString *boundaryString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[theRequest addValue:boundaryString forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue:@"test.jpg" forHTTPHeaderField: @"Filename-Header"];
	
	// define boundary separator...
	NSString *boundarySeparator = [NSString stringWithFormat:@"--%@\r\n", boundary];
	
	//adding the body...
	NSMutableData *postBody = [NSMutableData data];
	
	NSLog(@"before params");
	// adding params...
	for (id key in requestData) {
		NSString *formDataName = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
		NSString *formDataValue = [NSString stringWithFormat:@"%@\r\n", [requestData objectForKey:key]];
		[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[formDataName dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[formDataValue dataUsingEncoding:NSUTF8StringEncoding]];
		NSLog(@"%@ %@",key,[requestData objectForKey:key]);
	}
	NSLog(@"before file");
	// if file is defined, upload it...
	if (filePath) {
		NSArray *split = [filePath componentsSeparatedByString:@"/"];
		NSString *fileName = (NSString*)[split lastObject];
		NSData *fileContent = [NSData dataWithContentsOfFile:filePath options:0 error:nil];
		
		[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"inFile\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",contentType]
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:fileContent];
	}
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",boundary]
						  dataUsingEncoding:NSUTF8StringEncoding]];
	[theRequest setHTTPBody:postBody];	
	
	self.tmpFilePath = [self pathForTemporaryFileWithPrefix:@"Get"];
	self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.tmpFilePath append:NO];
	[self.fileStream open];
	//SimpleAppDelegate *appD = (SimpleAppDelegate*)[[UIApplication sharedApplication] delegate];
	//[appD showNetworkBusy];
	NSLog(@"%@",theRequest);
	NSLog(@"Start posting");
	self.connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
	[self.connection start];
}

-(void) Close {
	[self EndConnection:NO];
	if (self.targetFilePath)
	{
		[self.targetFilePath release];
		self.targetFilePath = nil;
	}
	if (self.myTag)
	{
		[self.myTag release];
		self.myTag=nil;
	}
}

-(void) dealloc {
    NSLog(@"[ThreadHTTPGet]{dealloc} - START");
	[self EndConnection:NO];
	if (self.targetFilePath)
	{
		[self.targetFilePath release];
		self.targetFilePath = nil;
	}
	if (self.myTag)
	{
		[self.myTag release];
		self.myTag=nil;
	}
    [super dealloc];
    NSLog(@"[ThreadHTTPGet]{dealloc} - END");
}

@end
