#import <UIKit/UIKit.h>

@interface DFDatePickerView : UIView
@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) UIColor *monthHeaderColor;
@property (nonatomic) UIFont *monthHeaderFont;

- (instancetype) initWithCalendar:(NSCalendar *)calendar;

- (void)scrollToDate:(NSDate *)date
      atScollPostion:(UICollectionViewScrollPosition)scrollPosition
            animated:(BOOL)animated;

- (void)clearSelectionAnimated:(BOOL)animated;

@end
