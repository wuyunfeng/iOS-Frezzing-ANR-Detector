//
//  ARNReportTool.m
//  ANRReporter
//
//  Created by wuyunfeng on 16/5/18.
//  Copyright © 2016年 wyf && BaiDu Map Iphone Team All rights reserved.
//

#import "BMANRDector.h"
#include <unistd.h>
#include <sys/select.h>
#import "PLCrashReporterConfig.h"
#import "PLCrashReporter.h"
#import "PLCrashReport.h"
#import "PLCrashReportTextFormatter.h"
#import <pthread.h>
#import <UIKit/UIKit.h>
@implementation BMANRDector
{
    int _readFd;
    int _writeFd;
    NSThread *_backgroudThread;
    volatile BOOL _exitStatus;
    NSTimer *_timer;
    thread_t _mainThreadTid;
    
    long _tolerance;
    BMANRStackTraceMode _traceMode;
    BMANRSearchMode _searchMode;
    BOOL _enterBackground;
    BOOL _enterForeground;
}

static BMANRDector *sInstance;

+ (instancetype)sharedInstance{
    if (sInstance == nil) {
        sInstance = [[[self class] alloc] init];
    }
    return sInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        int fds[2];
        int result = pipe(fds);
        NSAssert(result == 0, @"pipe failure");
        _readFd = fds[0];
        _writeFd = fds[1];
        
        _traceMode = BMANRStackTraceLive;
        _searchMode = BMANRSearchModeANR;
        _enterBackground = NO;
        _enterForeground = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)install
{
    [self installTolerance:6.0];

}

- (void)installTolerance:(long)tolerance
{
    [self installTraceMode:_traceMode tolerance:tolerance searchMode:BMANRSearchModeANR];
}

- (void)installTraceMode:(BMANRStackTraceMode)traceMode tolerance:(long)tolerance searchMode:(BMANRSearchMode)searchMode
{
    _tolerance = tolerance;
    _exitStatus = YES;
    _mainThreadTid = pthread_mach_thread_np(pthread_self());
    _backgroudThread = [[NSThread alloc] initWithTarget:self selector:@selector(trapToKernel) object:nil];
    [_backgroudThread start];
    long interval = tolerance >> 1;
    if (interval < 1) {
        interval = 1;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(wakeFormKernel) userInfo:nil repeats:YES];
    _traceMode = traceMode;
    _searchMode = searchMode;
}

- (void)applicationEnterForeground
{
    if (_enterBackground) {
        _enterForeground = YES;
    }
}

- (void)applicationEnterBackground
{
    _enterBackground = YES;
}


- (void)uninstall
{
    _exitStatus = NO;
    [_timer invalidate];
    close(_writeFd);
    close(_readFd);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    sInstance = nil;
}

- (void)dealloc
{
    close(_readFd);
    close(_writeFd);
}

- (void)trapToKernel
{
    fd_set fd_sets;
    int max_fd = -1;
    struct timeval tv;
    tv.tv_sec = _tolerance;
    tv.tv_usec = 0;
    while (_exitStatus) {
        FD_ZERO(&fd_sets);
        FD_SET(_readFd, &fd_sets);
        if (max_fd < _readFd) {
            max_fd = _readFd;
        }
        //this use kevent can better (later will use)
        int ret = select(max_fd + 1, &fd_sets, NULL, NULL, &tv);
        if (ret < 0) {
            NSLog(@"********* select error **********");
            continue;
        } else if(0 == ret) {
            if (!_enterForeground) {
                if (_traceMode == BMANRStackTraceLive) {
                    [self dumpProccessStackTrace];
                } else if (_traceMode == BMANRStackTraceCrash){
                    NSAssert(NO, @"Check The CrashLog");
                }
                _enterForeground = NO;
                _enterBackground = NO;
            }
        } else {
            if (FD_ISSET(_readFd, &fd_sets)) {//must
                NSLog(@".....sleep.....");
                [self nativePoll];
            }
        }
    }
}

- (void)nativePoll
{
    char buffer[2];
    ssize_t nRead;
    do {
        nRead = read(_readFd, buffer, sizeof(buffer));
    } while ((nRead == -1 && errno == EINTR) || nRead == sizeof(buffer));
}

- (void)wakeFormKernel
{
    ssize_t nWrite;
    do {
        nWrite = write(_writeFd, "s", 1);
    } while (nWrite == -1 && errno == EINTR);
    
    if (nWrite != 1) {
        if (errno != EAGAIN) {
            NSLog(@"Could not write wake signal, errno=%d", errno);
        }
    }
    NSLog(@".....wakeup.....");
}

// may cost long time to dump process stacktrace
- (void)dumpProccessStackTrace
{
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc]
                                     initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                     symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
    
    NSData *data = [crashReporter generateLiveReport];
    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
    NSString *stackTrace = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                                  withTextFormat:PLCrashReportTextFormatiOS];
    NSLog(@"**************************May Happen ANR，please wait for Process StackTrace!!!*************************");
    NSLog(@"%@", stackTrace);
    NSLog(@"***************************************************end***********************************************");
}



@end
