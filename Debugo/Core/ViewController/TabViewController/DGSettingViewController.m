//
//  DGSettingViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//
#import "DGSettingViewController.h"
#import "DGAssistant.h"
#import "DGCache.h"

typedef NS_ENUM(NSUInteger, DGSettingType) {
    // monitor
    DGSettingTypeFPS,
    DGSettingTypeTouches,
    DGSettingTypeNetwork,
    DGSettingTypeLOG,
};

@interface DGSettingViewController ()

@property (nonatomic, strong) NSArray <NSArray *>*dataArray;

@end

@implementation DGSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self getZoomImage] style:UIBarButtonItemStyleDone target:self action:@selector(clickZoom:)];
}

#pragma mark - getter
- (NSArray<NSArray *> *)dataArray
{
    if (!_dataArray) {
        NSArray *monitorArray = @[
                                  @(DGSettingTypeFPS),
                                  @(DGSettingTypeTouches),
                                  ];
        monitorArray.dg_copyExtObj = @"Monitor";
        
        _dataArray = @[monitorArray];
    }
    return _dataArray;
}

- (UIImage *)getZoomImage {
    return [DGBundle imageNamed:DGAssistant.shared.configuration.isFullScreen ? @"zoom_smaller" : @"zoom_bigger"];
}

#pragma mark - event
- (void)clickZoom:(UIBarButtonItem *)sender
{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }
    BOOL value = !DGAssistant.shared.configuration.isFullScreen;
    DGAssistant.shared.configuration.isFullScreen = value;
    self.navigationItem.rightBarButtonItem.image = [self getZoomImage];
    DGAssistant.shared.debugViewController.isFullScreen = value;
    [DGCache.shared.settingPlister setBool:value forKey:kDGSettingIsFullScreen];
}

- (void)swithValueChanged:(UISwitch *)sender
{
    BOOL value = sender.isOn;
    NSIndexPath *indexPath = sender.dg_strongExtObj;
    DGSettingType type = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (type) {
        case DGSettingTypeFPS: {
            DGAssistant.shared.configuration.isOpenFPS = value;
            [DGAssistant.shared refreshDebugBubbleWithIsOpenFPS:value];
            [DGCache.shared.settingPlister setBool:value forKey:kDGSettingIsOpenFPS];
        }
            break;
        case DGSettingTypeTouches: {
            DGAssistant.shared.configuration.isShowTouches = value;
            DGTouchMonitor.shared.shouldDisplayTouches = value;
            [DGCache.shared.settingPlister setBool:value forKey:kDGSettingIsShowTouches];
        }
            break;
        case DGSettingTypeNetwork: {
        }
            break;
        case DGSettingTypeLOG: {
        }
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] init];
        [switchView addTarget:self action:@selector(swithValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGSettingType type = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    UISwitch *switchView = (UISwitch *)cell.accessoryView;
    switchView.dg_strongExtObj = indexPath;

    switch (type) {
        case DGSettingTypeFPS: {
            cell.textLabel.text = @"FPS";
            cell.detailTextLabel.text = @"Display FPS number on debug bubble";
            switchView.on = DGAssistant.shared.configuration.isOpenFPS;
        }
            break;
        case DGSettingTypeTouches: {
            cell.textLabel.text = @"Touches";
            cell.detailTextLabel.text = @"Display touches on screen";
            switchView.on = DGAssistant.shared.configuration.isShowTouches;
        }
            break;
        case DGSettingTypeNetwork: {
            cell.textLabel.text = @"Network";
            cell.detailTextLabel.text = @"Monitor network requests";
            
        }
            break;
        case DGSettingTypeLOG: {
            cell.textLabel.text = @"Log";
            cell.detailTextLabel.text = @"View log in browser";
        }
            break;
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dataArray objectAtIndex:section].dg_copyExtObj;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
