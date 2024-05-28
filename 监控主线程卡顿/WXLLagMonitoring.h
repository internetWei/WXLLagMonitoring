//
//  WXLLagMonitoring.h
//  监听主线程RunLoop卡顿
//
//  Created by LL on 2024/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXLLagMonitoring : NSObject

+ (instancetype)lagMonitoring;

/// 开始监控主线程卡顿，如果主线程发生了卡顿，会通过 block 回调，回调发生在子线程。
- (void)startMonitor:(void (^)(void))block;

/// 停止监控。
- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
