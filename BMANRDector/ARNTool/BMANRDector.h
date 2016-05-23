//
//  ARNReportTool.h
//  ANRReporter
//
//  Created by wuyunfeng on 16/5/18.
//  Copyright © 2016年 wyf && BaiDu Map Iphone Team All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BMANRStackTraceMode)
{
    BMANRStackTraceLive = 0,
    BMANRStackTraceCrash = 1,
    BMANRStackTraceReserved
};

typedef NS_ENUM(NSInteger, BMANRSearchMode)
{
    BMANRSearchModeANR = 0,
    BMANRSearchModeBinarySeach = 1,
    BMANRSearchModeTcpFlowControl = 2
};


@interface BMANRDector : NSObject

+ (instancetype)sharedInstance;

- (void)install;

- (void)installTolerance:(long)tolerance;

- (void)installTraceMode:(BMANRStackTraceMode)traceMode tolerance:(long)tolerance searchMode:(BMANRSearchMode)searchMode;

- (void)uninstall;

@end
