//
//  LogProvider.h
//  PhotoCloud
//
//  Created by liupeng on 31/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LogProvider : NSObject

+(void)writeLogFile:(NSString* )message;

@end
