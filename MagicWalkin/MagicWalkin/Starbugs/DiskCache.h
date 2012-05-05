
@interface DiskCache : NSObject {
@private
	NSString *_cacheDir;
	NSUInteger _cacheSize;
}

@property (nonatomic, readonly) NSUInteger sizeOfCache;
@property (nonatomic, readonly) NSString *cacheDir;

+ (DiskCache *)sharedCache;

- (NSData *)imageDataInCacheForURLString:(NSString *)urlString;

- (void)cacheImageData:(NSData *)imageData   
			   request:(NSURLRequest *)request
			  response:(NSURLResponse *)response;

- (void)clearCachedDataForRequest:(NSURLRequest *)request;


@end
