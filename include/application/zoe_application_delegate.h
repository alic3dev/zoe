#if target_os_ios

#ifndef __zoe_application_delegate_h
#define __zoe_application_delegate_h

#import <UIKit/UIKit.h>

@interface zoe_application_delegate: UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;

@end

#endif
#endif
