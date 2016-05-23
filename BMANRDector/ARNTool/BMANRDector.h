//
//  ARNReportTool.h
//  ANRReporter
//
//  Created by wuyunfeng on 16/5/18.
//  Copyright © 2016年 wyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMANRDector : NSObject

+ (instancetype)sharedInstance;

- (void)install;

- (void)installTolerance:(long)tolerance;

- (void)uninstall;

@end
