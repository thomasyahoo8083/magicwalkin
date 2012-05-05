#import "ImageManager.h"
#import "DiskCache.h"

#define kMaxDownloadConnections 10

static ImageManager *sharedInstance;


@interface ImageManager (Privates)
- (void)loadImageForClient:(id<ImageConsumer>)client;
- (BOOL)loadImageRemotelyForClient:(id<ImageConsumer>)request;
@end


@implementation ImageManager

-(id) init {
	self = [super init];
	if(self)
	{
		memCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)addClientToDownloadQueue:(id<ImageConsumer>)client {
	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImageForClient:) object:client];
	[thread start];
	[thread release];
}

- (void)loadImageForClient:(id<ImageConsumer>)client {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *cachedImage = [self cachedImageForClient:client];

    if (cachedImage) {
		[client renderImage:cachedImage];
    } else if (![self loadImageRemotelyForClient:client]) {
		NSLog(@"image download failed, trying again: %@", client);
		[self addClientToDownloadQueue:client];
	}
	[pool release];
}

- (UIImage *)cachedImageForClient:(id<ImageConsumer>)client {
	NSData *imageData = nil;
	UIImage *image = nil;
	
	NSURLRequest *request = [client request];
	NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
	
	if (cachedResponse) {
		NSLog(@"found cached image data for %@", [request URL]);
		imageData = [cachedResponse data];
		image = [UIImage imageWithData:imageData];
		return image;
	}
	
	
	
	if (image == nil && 
		(imageData = [[DiskCache sharedCache] imageDataInCacheForURLString:[[request URL] absoluteString]])) {
		NSURLResponse *response = [[[NSURLResponse alloc] initWithURL:[request URL] 
															 MIMEType:nil
												expectedContentLength:[imageData length] 
													 textEncodingName:nil] 
								   autorelease];
		[[DiskCache sharedCache] cacheImageData:imageData 
										 request:request 
										response:response];
		image = [UIImage imageWithData:imageData];
	}
	
	if (image == nil) {
		NSLog(@"unable to find image data in cache: %@", request);
	}
	
	return image;
}


- (BOOL)loadImageRemotelyForClient:(id<ImageConsumer>)client {
	
	NSURLResponse *response = nil;
	NSError *error = nil;

	NSURLRequest *request = [client request];
	NSData *imageData = [NSURLConnection sendSynchronousRequest:request 
											  returningResponse:&response 
														  error:&error];
	
	if (error != nil) {
		NSLog(@"ERROR RETRIEVING IMAGE at %@: %@", request, error);
		NSLog(@"User info: %@", [error userInfo]);
		if ([[error userInfo] objectForKey:NSUnderlyingErrorKey]) {
			NSLog(@"underlying error info: %@", [[[error userInfo] objectForKey:NSUnderlyingErrorKey] userInfo]);
		}

        NSInteger code = [error code];
        if (code == NSURLErrorUnsupportedURL ||
            code == NSURLErrorBadURL ||
            code == NSURLErrorBadServerResponse ||
            code == NSURLErrorRedirectToNonExistentLocation ||
            code == NSURLErrorFileDoesNotExist ||
            code == NSURLErrorFileIsDirectory ||
            code == NSURLErrorRedirectToNonExistentLocation) {
            // the above status codes are permanent fatal errors;
            // don't retry
            return YES;
        }
        [error autorelease];

	} else if (imageData != nil && response != nil) {
		[[DiskCache sharedCache] cacheImageData:imageData 
										 request:request
										response:response];
		
		UIImage *image = [UIImage imageWithData:imageData];
		if (image == nil) {
			NSLog(@"removing image data for: %@", [client request]);
			[[DiskCache sharedCache] clearCachedDataForRequest:[client request]];
		} else {
			[client renderImage:image];
			return YES;
		}

	} else {
		NSLog(@"Unknown error retrieving image %@ (response is null)", request);
	}
	return NO;
}

+ (ImageManager *)sharedManager {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}




@end
