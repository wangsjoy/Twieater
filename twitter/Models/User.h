//
//  User.h
//  twitter
//
//  Created by Sophia Joy Wang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

// User.h
#import <Foundation/Foundation.h>

@interface User : NSObject

// MARK: Properties

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;

// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// Add any additional properties here
@end
