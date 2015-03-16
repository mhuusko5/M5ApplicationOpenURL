//
//  M5ApplicationOpenURL.m
//  M5ApplicationOpenURL
//
//  Created by Mathew Huusko V.
//  Copyright (c) 2015 Mathew Huusko V. All rights reserved.
//

#import "M5ApplicationOpenURL.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import <objc/runtime.h>

@interface M5ApplicationOpenURLHandler : NSObject

#pragma mark - M5ApplicationOpenURLHandler (Private) -

#pragma mark Properties

@property (copy, readwrite) M5ApplicationOpenURLCallback callback;
@property (weak, readwrite) id target;
@property (assign, readwrite) SEL selector;

#pragma mark -

@end

@implementation M5ApplicationOpenURLHandler

#pragma mark - M5ApplicationOpenURLHandler (Private) -

#pragma mark Methods

- (BOOL)handleOpenURL:(NSURL *)URL application:(NSString *)application {
    if (self.callback) {
        return self.callback(URL, application);
    }
    
    if (self.target && self.selector && [self.target respondsToSelector:self.selector]) {
        return ((BOOL(*)(id, SEL, NSURL*, NSString*))[self.target methodForSelector:self.selector])(self.target, self.selector, URL, application);
    }
    
    return NO;
}

#pragma mark -

@end

@implementation M5ApplicationOpenURL

#pragma mark - M5ApplicationOpenURL -

#pragma mark Methods

+ (void)removeHandler:(id<NSObject>)handler {
    @synchronized(self) {
        [self.handlers removeObjectIdenticalTo:handler];
    }
}

+ (id<NSObject>)addHandlerWithTarget:(id)target selector:(SEL)selector {
    @synchronized(self) {
        M5ApplicationOpenURLHandler *handler = M5ApplicationOpenURLHandler.new;
        handler.target = target;
        handler.selector = selector;
        
        [self.handlers addObject:handler];
        
        return handler;
    }
}

+ (id<NSObject>)addHandlerWithCallback:(M5ApplicationOpenURLCallback)callback {
    @synchronized(self) {
        M5ApplicationOpenURLHandler *handler = M5ApplicationOpenURLHandler.new;
        handler.callback = callback;
        
        [self.handlers addObject:handler];
        
        return handler;
    }
}

#pragma mark -

#pragma mark - M5ApplicationOpenURL (Private) -

#pragma mark Methods

#if TARGET_OS_IPHONE
NS_INLINE NSPointerArray* M5ClassesConformingToProtocol(Protocol *protocol) {
    int classCount = objc_getClassList(NULL, 0);
    Class classes[sizeof(Class) * classCount];
    classCount = objc_getClassList(classes, classCount);
    
    NSPointerArray *classesArray = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsOpaqueMemory];
    
    while (--classCount >= 0) {
        Class clazz = classes[classCount];
        
        if (class_conformsToProtocol(clazz, protocol)) {
            [classesArray addPointer:(__bridge void *)(clazz)];
        }
    }
    
    return classesArray;
}
#else
+ (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSURL *URL = [NSURL URLWithString:[event paramDescriptorForKeyword:keyDirectObject].stringValue];
    
    for (M5ApplicationOpenURLHandler *handler in M5ApplicationOpenURL.handlers) {
        if ([handler handleOpenURL:URL application:nil]) {
            return;
        }
    }
}
#endif

#pragma mark Properties

+ (NSMutableArray *)handlers {
    __block NSMutableArray *handlers;
    
    @synchronized(self) {
        handlers = objc_getAssociatedObject(self, @selector(handlers));
        
        if (!handlers) {
            objc_setAssociatedObject(self, @selector(handlers), (handlers = NSMutableArray.new), OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    return handlers;
}

#pragma mark -

#pragma mark - NSObject -

#pragma mark Methods

+ (void)load {
    #if TARGET_OS_IPHONE
    for (Class delegateClass in M5ClassesConformingToProtocol(@protocol(UIApplicationDelegate))) {
        @synchronized(delegateClass) {
            SEL openURLSelector = @selector(application:openURL:sourceApplication:annotation:);
            
            __block IMP oldOpenURL = nil;
            IMP newOpenURL = (IMP)imp_implementationWithBlock(^BOOL(id self, UIApplication *application, NSURL *url, NSString *sourceApplication, id annotation) {
                @synchronized(M5ApplicationOpenURL.class) {
                    for (M5ApplicationOpenURLHandler *handler in M5ApplicationOpenURL.handlers) {
                        if ([handler handleOpenURL:url application:sourceApplication]) {
                            return YES;
                        }
                    }
                }
                
                if (oldOpenURL) {
                    return ((BOOL(*)(id, SEL, UIApplication*, NSURL*, NSString*, id))oldOpenURL)(self, openURLSelector, application, url, sourceApplication, annotation);
                }
                
                return NO;
            });
            
            Method openURLMethod = class_getInstanceMethod(delegateClass, openURLSelector);
            if (openURLMethod) {
                oldOpenURL = method_setImplementation(openURLMethod, newOpenURL);
            } else {
                const char *methodTypes = [NSString stringWithFormat: @"%s%s%s%s%s%s%s", @encode(BOOL), @encode(id), @encode(SEL), @encode(UIApplication*), @encode(NSURL*), @encode(NSString*), @encode(id)].UTF8String;
                
                class_addMethod(delegateClass, openURLSelector, newOpenURL, methodTypes);
            }
        }
    }
    #else
    [NSAppleEventManager.sharedAppleEventManager setEventHandler:self andSelector:@selector(handleGetURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    #endif
}

#pragma mark -

@end
