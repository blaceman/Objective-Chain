//
//  OCACommand.h
//  Objective-Chain
//
//  Created by Martin Kiss on 30.12.13.
//  Copyright © 2014 Martin Kiss. All rights reserved.
//

#import "OCAProducer.h"





/// Command is a Producer, that allows explicit sending of values.
@interface OCACommand : OCAProducer



#pragma mark Creating Command

- (instancetype)init;
+ (instancetype)command;


#pragma mark Using Command

- (void)sendValue:(id)value;
- (void)finishWithError:(NSError *)error;



@end


