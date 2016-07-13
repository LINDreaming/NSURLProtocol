//
//  MyURLProtocol.h
//  NSURLProtocolExample
//
//  Created by Linxi on 16/7/11.
//  Copyright © 2016年 Rocir Santiago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyURLProtocol : NSURLProtocol
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSURLResponse *response;
@end
