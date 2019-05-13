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
    // general
    DGSettingTypeTabBar,
    // monitor
    DGSettingTypeFPS,
    DGSettingTypeTouches,
    // apple
    DGSettingTypeDebugging,
};

@interface DGSettingViewController ()

@property (nonatomic, strong) NSArray <NSArray *>*dataArray;

@end

@implementation DGSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - getter
- (NSArray<NSArray *> *)dataArray {
    if (!_dataArray) {
        NSArray *generalArray = @[
                                  @(DGSettingTypeTabBar),
                                  ];
        generalArray.dg_copyExtObj = @"General";
        NSArray *monitorArray = @[
                                  @(DGSettingTypeFPS),
                                  @(DGSettingTypeTouches),
                                  ];
        monitorArray.dg_copyExtObj = @"Monitor";
        NSArray *appleArray = @[
                                @(DGSettingTypeDebugging),
                                ];
        appleArray.dg_copyExtObj = @"Apple";
        _dataArray = @[generalArray, monitorArray, appleArray];
    }
    return _dataArray;
}

#pragma mark - event

- (void)swithValueChanged:(UISwitch *)sender {
    BOOL value = sender.isOn;
    NSIndexPath *indexPath = sender.dg_strongExtObj;
    DGSettingType type = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    switch (type) {
        case DGSettingTypeTabBar: {
            DGAssistant.shared.configuration.isShowBottomBarWhenPushed = value;
            [DGCache.shared.settingPlister setBool:value forKey:kDGSettingIsShowBottomBarWhenPushed];
        }
            break;
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
        default:
            break;
    }
}

- (void)buttonClicked:(UIButton *)sender {
    NSIndexPath *indexPath = sender.dg_strongExtObj;
    DGSettingType type = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];

    switch (type) {
        case DGSettingTypeDebugging: {
            [sender setTitle:@"已开启" forState:UIControlStateNormal];
            [sender sizeToFit];
            sender.enabled = NO;
            [DGAssistant.shared closeDebugWindow];
            [DGDebuggingOverlay showDebuggingInformation];
            break;
        }
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
    DGSettingType type = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    NSString *identfier = nil;
    switch (type) {
        case DGSettingTypeTabBar:
        case DGSettingTypeFPS:
        case DGSettingTypeTouches:
            identfier = @"switch";
            break;
        case DGSettingTypeDebugging:
            identfier = @"button";
            break;
        default:
            NSAssert(0, @"identifier 异常");
            identfier = @"cell";
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([identfier isEqualToString:@"switch"]) {
            UISwitch *switchView = [[UISwitch alloc] init];
            [switchView addTarget:self action:@selector(swithValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
        }else if ([identfier isEqualToString:@"button"]) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.tintColor = kDGHighlightColor;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = button;
            
        }
    }
    cell.accessoryView.dg_strongExtObj = indexPath;
    switch (type) {
        case DGSettingTypeTabBar: {
            cell.textLabel.text = @"TabBar";
            cell.detailTextLabel.text = @"Show bottom bar when pushed";
            ((UISwitch *)cell.accessoryView).on = DGAssistant.shared.configuration.isShowBottomBarWhenPushed;
        }
            break;
        case DGSettingTypeFPS: {
            cell.textLabel.text = @"FPS";
            cell.detailTextLabel.text = @"Display FPS number on debug bubble";
            ((UISwitch *)cell.accessoryView).on = DGAssistant.shared.configuration.isOpenFPS;
        }
            break;
        case DGSettingTypeTouches: {
            cell.textLabel.text = @"Touches";
            cell.detailTextLabel.text = @"Display touches on screen";
            ((UISwitch *)cell.accessoryView).on = DGAssistant.shared.configuration.isShowTouches;
        }
            break;
        case DGSettingTypeDebugging: {
            NSArray *debugInfoComponents = @[@"U", @"IDe", @"bug", @"gin", @"gInfor", @"ma", @"ti", @"onO", @"ver", @"lay"];
            cell.textLabel.text = [debugInfoComponents componentsJoinedByString:@""];
            cell.detailTextLabel.text = @"Apple 内部的调试工具";
            UIButton *button = (UIButton *)cell.accessoryView;
            if ([DGDebuggingOverlay isShowing]) {
                [button setTitle:@"已开启" forState:UIControlStateNormal];
                button.enabled = NO;
            }else {
                [button setTitle:@"开启" forState:UIControlStateNormal];
                button.enabled = YES;
            }
            [button sizeToFit];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataArray objectAtIndex:section].dg_copyExtObj;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
