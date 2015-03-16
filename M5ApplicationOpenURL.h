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

+ (void)removeHandler:(id<NSObject>)handler;
+ (id<NSObject>)addHandlerWithTarget:(id)target selector:(SEL)selector; //e.g. - (BOOL)handleOpenURL:(NSURL *)URL fromApp:(NSString *)sourceApp;
+ (id<NSObject>)addHandlerWithCallback:(M5ApplicationOpenURLCallback)callback;

#pragma mark -

@end
