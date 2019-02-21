//
//  FTPopOverMenu.h
//  FTPopOverMenu
//
//  Created by liufengting on 16/4/5.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

#import <UIKit/UIKit.h>

///------------------------------------------------
/// Code From FTPopOverMenu 2.0.0 https://github.com/liufengting/FTPopOverMenu
///------------------------------------------------

/**
 *  DGPopOverMenuDoneBlock
 *
 *  @param selectedIndex SlectedIndex
 */
typedef void (^DGPopOverMenuDoneBlock)(NSInteger selectedIndex);
/**
 *  DGPopOverMenuDismissBlock
 */
typedef void (^DGPopOverMenuDismissBlock)(void);

/**
 *  -----------------------DGPopOverMenuModel-----------------------
 */
@interface DGPopOverMenuModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id image;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithTitle:(NSString *)title image:(id)image selected:(BOOL)selected;

@end

/**
 *  -----------------------DGPopOverMenuConfiguration-----------------------
 */
@interface DGPopOverMenuConfiguration : NSObject

@property (nonatomic, assign) CGFloat menuTextMargin;// Default is 6.
@property (nonatomic, assign) CGFloat menuIconMargin;// Default is 6.
@property (nonatomic, assign) CGFloat menuRowHeight;
@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) BOOL ignoreImageOriginalColor;// Default is 'NO', if sets to 'YES', images color will be same as textColor.
@property (nonatomic, assign) BOOL allowRoundedArrow;// Default is 'NO', if sets to 'YES', the arrow will be drawn with round corner.
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *selectedCellBackgroundColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat shadowOffsetX;
@property (nonatomic, assign) CGFloat shadowOffsetY;

/**
 *  defaultConfiguration
 *
 *  @return curren configuration
 */
+ (DGPopOverMenuConfiguration *)defaultConfiguration;

@end

/**
 *  -----------------------DGPopOverMenuCell-----------------------
 */
@interface DGPopOverMenuCell : UITableViewCell

@end
/**
 *  -----------------------DGPopOverMenuView-----------------------
 */
@interface DGPopOverMenuView : UIControl

@end

/**
 *  -----------------------DGPopOverMenu-----------------------
 */
@interface DGPopOverMenu : NSObject

//    menuArray supports following context:
//    1. image name (NSString, only main bundle),
//    2. image (UIImage),
//    3. image remote URL string (NSString),
//    4. image remote URL (NSURL),
//    5. model (DGPopOverMenuModel, select state support)

/**
 show method with sender without images

 @param sender sender
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray *)menuArray
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock;

/**
 show method with sender and image resouce Array

 @param sender sender
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray *)menuArray
            imageArray:(NSArray *)imageArray
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock;

/**
 show method with sender, image resouce Array and configuration

 @param sender sender
 @param menuArray menuArray
 @param imageArray imageArray
 @param configuration configuration
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray *)menuArray
            imageArray:(NSArray *)imageArray
         configuration:(DGPopOverMenuConfiguration *)configuration
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock;

/**
 show method for barbuttonitems with event without images

 @param event event
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray *)menuArray
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock;

/**
 show method for barbuttonitems with event and imageArray

 @param event event
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray *)menuArray
            imageArray:(NSArray *)imageArray
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock;


/**
 show method for barbuttonitems with event, imageArray and configuration

 @param event event
 @param menuArray menuArray
 @param imageArray imageArray
 @param configuration configuration
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray *)menuArray
            imageArray:(NSArray *)imageArray
         configuration:(DGPopOverMenuConfiguration *)configuration
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock;
/**
 show method with SenderFrame without images

 @param senderFrame senderFrame
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray *)menuArray
                   doneBlock:(DGPopOverMenuDoneBlock)doneBlock
                dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock;

/**
 show method with SenderFrame and image resouce Array

 @param senderFrame senderFrame
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray *)menuArray
                  imageArray:(NSArray *)imageArray
                   doneBlock:(DGPopOverMenuDoneBlock)doneBlock
                dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock;

/**
 show method with SenderFrame, image resouce Array and configuration
 
 @param senderFrame senderFrame
 @param menuArray menuArray
 @param imageArray imageArray
 @param configuration configuration
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray *)menuArray
                  imageArray:(NSArray *)imageArray
               configuration:(DGPopOverMenuConfiguration *)configuration
                   doneBlock:(DGPopOverMenuDoneBlock)doneBlock
                dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock;
/**
 *  dismiss method
 */
+ (void) dismiss;

@end
