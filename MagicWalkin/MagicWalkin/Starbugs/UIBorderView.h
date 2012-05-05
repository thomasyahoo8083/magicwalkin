#import <UIKit/UIKit.h>

typedef enum
{
	BorderTop = 1,
	BorderRight = 2,
	BorderBottom = 4,
	BorderLeft = 8
} BorderType;

typedef uint8_t Border;



@interface UIBorderView : UIView
{

}


@property (nonatomic, retain) id touchCallbackTarget;
@property (nonatomic, assign) SEL touchCallback;

@property (nonatomic, assign) Border border;
@property (nonatomic, assign) int borderMargin;
@property (nonatomic, assign) float borderWidth;
@property (nonatomic, retain) UIColor *borderColor;
@end
