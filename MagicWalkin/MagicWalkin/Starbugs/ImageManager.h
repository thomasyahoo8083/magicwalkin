
@protocol ImageConsumer <NSObject>
- (NSURLRequest *)request;
- (void)renderImage:(UIImage *)image;
@end


@interface ImageManager : NSObject {
	@private
	NSMutableDictionary *memCache;
}

+ (ImageManager *) sharedManager;

- (void)addClientToDownloadQueue:(id<ImageConsumer>)client;
- (UIImage *)cachedImageForClient:(id<ImageConsumer>)client;

@end
