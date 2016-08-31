//
//  LogProvider.m
//  PhotoCloud
//
//  Created by liupeng on 31/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

#import "LogProvider.h"

@implementation LogProvider
+(void)writeLogFile:(NSString* )message {
    NSString *applicationCacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSDateFormatter* formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString* logFolder = [applicationCacheDirectory stringByAppendingPathComponent:@"SKPhotoCloudUploadLog"];
    NSString* finalPath = [logFolder stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.log",[formate stringFromDate:[NSDate new]]]];
    NSFileHandle *output = [NSFileHandle fileHandleForWritingAtPath:finalPath];
    if(output == nil) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:logFolder]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:logFolder withIntermediateDirectories:YES attributes:nil error:Nil];
        }
        [[NSFileManager defaultManager] createFileAtPath:finalPath contents:nil attributes:nil];
        output = [NSFileHandle fileHandleForWritingAtPath:finalPath];
    } else {
        [output seekToEndOfFile];
    }
    [output writeData:[[NSString stringWithFormat:@"%@\r\n", message] dataUsingEncoding:NSUTF8StringEncoding]];
    [output closeFile];
}
@end
