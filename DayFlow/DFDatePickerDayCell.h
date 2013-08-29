#import <UIKit/UIKit.h>
#import "DayFlow.h"

@interface DFDatePickerDayCell : UICollectionViewCell

@property (nonatomic, assign) DFDatePickerDate date;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, assign) BOOL hasActivity;

@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *cellColor;

@end
