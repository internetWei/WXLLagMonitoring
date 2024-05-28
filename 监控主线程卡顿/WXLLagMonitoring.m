//
//  WXLLagMonitoring.m
//  监听主线程RunLoop卡顿
//
//  Created by LL on 2024/5/23.
//

#import "WXLLagMonitoring.h"
#import <QuartzCore/QuartzCore.h>

static const int64_t watchDog = 60 * NSEC_PER_MSEC;

@interface WXLLagMonitoring ()

@property (nonatomic, assign) CFRunLoopActivity lastActivity;

@property (nonatomic, assign) CFTimeInterval lastTime;

/// 卡顿时捕获的时间
@property (nonatomic, assign) CFTimeInterval captureTime;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, assign) CFRunLoopObserverRef observer;

@end

@implementation WXLLagMonitoring

+ (instancetype)lagMonitoring {
    return [[self alloc] init];
}

- (void)startMonitor:(void (^)(void))block {
    if (self.observer) { return; }
    
    __weak typeof(self) weakSelf = self;
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        weakSelf.lastActivity = activity;
        weakSelf.lastTime = CACurrentMediaTime();
        !weakSelf.semaphore ?: dispatch_semaphore_signal(weakSelf.semaphore);
    });
    self.observer = observer;
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    
    self.semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        do {
            intptr_t result = dispatch_semaphore_wait(weakSelf.semaphore, dispatch_walltime(NULL, watchDog));
            if (weakSelf.observer == nil) { return; }
            if (result == 0) { continue; }
            
            // APP 超过 60 ms 无响应，可能发生了卡顿。
            if (weakSelf.lastActivity == kCFRunLoopBeforeWaiting || weakSelf.lastActivity == kCFRunLoopExit) {
                // 正常情况，不算卡顿。
                continue;
            }
            
            // 防止重复捕获同一个卡顿。
            if (weakSelf.captureTime == weakSelf.lastTime) { continue; }
            weakSelf.captureTime = weakSelf.lastTime;
            
            !block ?: block();
        } while (1);
    });
}


- (void)stopMonitor {
    if (self.observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
    }
    
    self.observer = nil;
    self.lastActivity = kNilOptions;
    self.lastTime = 0;
    self.captureTime = 0;
    self.semaphore = nil;
}

- (void)dealloc {
    [self stopMonitor];
    NSLog(@"%s", __func__);
}

@end


