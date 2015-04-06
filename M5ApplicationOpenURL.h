//
//  M5ApplicationOpenURL.h
//  M5ApplicationOpenURL
//
//  Created by Mathew Huusko V.
//  Copyright (c) 2015 Mathew Huusko V. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^M5ApplicationOpenURLCallback)(NSURL *URL, NSString *sourceApplication);

@interface M5ApplicationOpenURL : NSObject

#pragma mark - M5ApplicationOpenURL -

#pragma mark Methods

/** Removes an already added handler, else does nothing. */
+ (void)removeHandler:(id<NSObject>)handler;

/** Adds/returns handler which will call a selector (e.g. '- (BOOL)handleOpenURL:(NSURL *)URL fromApp:(NSString *)sourceApp;') on a (weakly held) target object. */
+ (id<NSObject>)addHandlerWithTarget:(id)target selector:(SEL)selector;

/** Adds/returns handler which will call a (copied) block. */
+ (id<NSObject>)addHandlerWithCallback:(RAMApplicationOpenURLCallback)callback;

#pragma mark -

@end
