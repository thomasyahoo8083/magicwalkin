//
//  ThreadHTTPGet.h
//  eSave
//
//  Created by Micro Cheng on 24/06/2010.
//  Copyright 2010 Legato Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ThreadHTTPGetDelegate;

@interface ThreadHTTPGet : NSObject {
	id <ThreadHTTPGetDelegate> delegate;
	NSURLConnection *connection;
    NSString *tmpFilePath;
	NSString *targetFilePath;
    NSOutputStream *fileStream;	
	NSString *myTag;
	BOOL bCallBack;
	BOOL bSaveFile;
	BOOL bUploadFile;
}

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, assign) NSString *tmpFilePath;
@property (nonatomic, assign) NSString *targetFilePath;
@property (nonatomic, retain) NSOutputStream *fileStream;
@property (nonatomic, assign) NSString *myTag;
@property (nonatomic, assign) BOOL bCallBack;
@property (nonatomic, assign) BOOL bSaveFile;
@property (nonatomic, assign) BOOL bUploadFile;
@property (nonatomic, assign) id<ThreadHTTPGetDelegate> delegate;

-(void) Close;
-(void) Open:(NSString *)URLPath savePath:(NSString *) saveName tagInfo:(NSString *) tTag timeOut:(float) defTimeout;
-(void) Open:(NSString *)URLPath savePath:(NSString *) saveName tagInfo:(NSString *) tTag;
-(void) Open:(NSString *)URLPath savePath:(NSString *) saveName;
-(void) Open:(NSString *)URLPath tagInfo:(NSString*) tTag;
-(void) Open:(NSString *)URLPath savePath:(NSString *) saveName timeOut:(float) defTimeout;
-(void) Open:(NSString *)URLPath tagInfo:(NSString*) tTag timeOut:(float) defTimeout;
-(void) PostData:(NSString *) URLPath DataString:(NSString *) oData tag:(NSString *) tTag timeOut:(float) defTimeout;
-(void) PostData:(NSString *) URLPath DataString:(NSString *) oData tag:(NSString *) tTag;
- (void)postUpload:(NSString *)url
				  :(NSDictionary *)requestData
				  :(NSString *)filePath
				  :(NSString *) contentType
				  :(NSString *)tTag;
@end

@protocol ThreadHTTPGetDelegate
-(void) didFinishHttpGet:(BOOL)bNormal tagInfo:(NSString *) tTag data:(NSData *) tData;
-(void) didFinishHttpSave:(BOOL)bNormal tagInfo:(NSString *) tTag;
-(void) didFinishHttpUpload:(BOOL) bNormal tagInfo:(NSString *) tTag data:(NSData *) tData;
@end
