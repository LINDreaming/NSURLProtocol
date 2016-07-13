//
//  MyURLProtocol.m
//  NSURLProtocolExample
//
//  Created by Linxi on 16/7/11.
//  Copyright © 2016年 Rocir Santiago. All rights reserved.
//

#import "MyURLProtocol.h"
#import "AppDelegate.h"
#import "CachedURLResponse.h"


@interface MyURLProtocol()<NSURLConnectionDelegate>
@property(nonatomic, strong)NSURLConnection *connection;

@end

@implementation MyURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    
    static NSUInteger requestCount = 0;
    NSLog(@"Request #%u:URL = %@",requestCount++,request.URL.absoluteString);
    
    if ([NSURLProtocol propertyForKey:@"MyURLProtocolHandledKey" inRequest:request]) {
        return NO;
    }
    return YES;
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:request.URL];
    [newRequest addValue:@"ceshi445" forHTTPHeaderField:@"Authorization"];
    [newRequest addValue:@"token1239" forHTTPHeaderField:@"token"];

    NSLog(@"headr== %@",newRequest.allHTTPHeaderFields);
    return newRequest;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    // 1.
//    CachedURLResponse *cachedResponse = [self cachedResponseForCurrentRequest];
//    if (cachedResponse) {
//        NSLog(@"serving response from cache");
//        
//        // 2.
//        NSData *data = cachedResponse.data;
//        NSString *mimeType = cachedResponse.mimeType;
//        NSString *encoding = cachedResponse.encoding;
//        
//        // 3.
//        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
//                                                            MIMEType:mimeType
//                                               expectedContentLength:data.length
//                                                    textEncodingName:encoding];
//        
//        // 4.
//        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//        [self.client URLProtocol:self didLoadData:data];
//        [self.client URLProtocolDidFinishLoading:self];
//    }else{
    
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"MyURLProtocolHandledKey" inRequest:newRequest];
        self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
 //   }
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.response = response;
    self.mutableData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
      [self saveCachedResponse];
}
- (void)saveCachedResponse {
    NSLog(@"saving cached response");
    
    // 1.
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    // 2.
    CachedURLResponse *cachedResponse = [NSEntityDescription insertNewObjectForEntityForName:@"CachedURLResponse"
                                                                      inManagedObjectContext:context];
    cachedResponse.data = self.mutableData;
    cachedResponse.url = self.request.URL.absoluteString;
    cachedResponse.timestamp = [NSDate date];
    cachedResponse.mimeType = self.response.MIMEType;
    cachedResponse.encoding = self.response.textEncodingName;
    
    // 3.
    NSError *error;
    BOOL const success = [context save:&error];
    if (!success) {
        NSLog(@"Could not cache the response.");
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

- (CachedURLResponse *)cachedResponseForCurrentRequest {
    // 1.
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    // 2.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CachedURLResponse"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // 3.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", self.request.URL.absoluteString];
    [fetchRequest setPredicate:predicate];
    
    // 4.
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    // 5.
    if (result && result.count > 0) {
        return result[0];
    }
    
    return nil;
}

@end
