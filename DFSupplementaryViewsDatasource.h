//
//  DFSupplementaryViewsDatasource.h
//  DayFlow
//
//  Created by Andrew F. Dreher on 8/29/13.
//  Copyright (c) 2013 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DFSupplementaryViewsDatasource <NSObject>

@optional
- (NSString *)titleForMonthWithDate:(NSDate *)date;

@end
