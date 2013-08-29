#import <UIKit/UIKit.h>
#import "DFSupplementaryViewsDatasource.h"

@interface DFDatePickerView : UIView
@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) UIColor *monthHeaderColor;
@property (nonatomic) UIFont *monthHeaderFont;
@property (nonatomic) NSObject<DFSupplementaryViewsDatasource> *supplementaryDatasource;

- (instancetype) initWithCalendar:(NSCalendar *)calendar;

- (void)scrollToDate:(NSDate *)date
      atScollPostion:(UICollectionViewScrollPosition)scrollPosition
            animated:(BOOL)animated;

- (void)clearSelectionAnimated:(BOOL)animated;

@end
