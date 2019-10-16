//
//  DGColorPluginViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/26.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGColorPluginViewController.h"
#import "DGCommon.h"
#import "DGColorPlugin.h"

@interface DGColorPluginViewController ()

@property (nonatomic, weak) UIViewController *topViewController;

@end

@implementation DGColorPluginViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [DGColorPlugin pluginName];
    self.topViewController = dg_topViewController();
    
    dg_weakify(self)
    DGStaticProvider *provider = [DGStaticProvider new];

    [provider setViewForHeaderInSection:^UIView * _Nonnull(UITableView * _Nonnull tableView, NSInteger section, NSString * _Nonnull identifier) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[tableView dg_staticSectionForSection:section].headerIdentifier];
        if (!header) {
            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        }
        return header;
    }];
    [provider setHeightForHeaderInSection:^CGFloat(UITableView * _Nonnull tableView, NSInteger section) {
        return section == 0 ? 60 : 80;
    }];
    [provider setHeightForRowAtIndexPath:^CGFloat(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        return 50;
    }];
    
    [provider addSectionWithBlock:^(DGStaticSection * _Nonnull section) {
        [section setWillDisplayHeader:^(UITableViewHeaderFooterView *  _Nonnull header, NSInteger section) {
            header.textLabel.text = @"当前顶部控制器";
        }];
        [section addRowWithBlock:^(DGStaticRow * _Nonnull row) {
            [row setCreateCell:^UITableViewCell * _Nonnull(NSIndexPath * _Nonnull indexPath, NSString * _Nonnull identifier) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                return cell;
            }];
            [row setWillDisplay:^(UITableViewCell *  _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
                dg_strongify(self)
                if (self.topViewController) {
                    cell.textLabel.text = NSStringFromClass(self.topViewController.class);
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%p", self.topViewController];
                }else {
                    cell.textLabel.text = @"未知";
                    cell.detailTextLabel.text = nil;
                }
            }];
        }];
    }];
    
    [provider addSectionWithBlock:^(DGStaticSection * _Nonnull section) {
        [section setWillDisplayHeader:^(UITableViewHeaderFooterView *  _Nonnull header, NSInteger section) {
            header.textLabel.text = @"背景色渲染规则";
        }];
        [section addRowWithBlock:^(DGStaticRow * _Nonnull row) {
            [row setCreateCell:^UITableViewCell * _Nonnull(NSIndexPath * _Nonnull indexPath, NSString * _Nonnull identifier) {
                dg_strongify(self)
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"无", @"子视图", @"所有视图"]];
                dg_weakify(self)
                [segmentedControl dg_addReceiverForControlEvents:UIControlEventValueChanged handler:^(UISegmentedControl *  _Nonnull sender) {
                    dg_strongify(self)
                    kDGImpactFeedback
                    if (self.topViewController) {
                        self.topViewController.view.dg_renderType = sender.selectedSegmentIndex;
                    }
                }];
                [segmentedControl sizeToFit];
                segmentedControl.dg_centerY = 25;
                [cell addSubview:segmentedControl];
                cell.dg_extWeakObj = segmentedControl;
                return cell;
            }];
            [row setWillDisplay:^(UITableViewCell *  _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
                UISegmentedControl *segmentedControl = cell.dg_extWeakObj;
                segmentedControl.selectedSegmentIndex = self.topViewController.view.dg_renderType;
                segmentedControl.dg_x = cell.dg_safeAreaInsets.left + 20;
            }];
        }];
    }];
    
    [provider addSectionWithBlock:^(DGStaticSection * _Nonnull section) {
        [section setWillDisplayHeader:^(UITableViewHeaderFooterView *  _Nonnull header, NSInteger section) {
            header.textLabel.text = @"背景色类型";
        }];
        [section addRowWithBlock:^(DGStaticRow * _Nonnull row) {
            [row setCreateCell:^UITableViewCell * _Nonnull(NSIndexPath * _Nonnull indexPath, NSString * _Nonnull identifier) {
                dg_strongify(self)
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"随机色", @"半透明随机色", @"半透明红色"]];
                dg_weakify(self)
                [segmentedControl dg_addReceiverForControlEvents:UIControlEventValueChanged handler:^(UISegmentedControl *  _Nonnull sender) {
                    dg_strongify(self)
                    kDGImpactFeedback
                    if (self.topViewController) {
                        self.topViewController.view.dg_colorType = sender.selectedSegmentIndex;
                    }
                }];
                [segmentedControl sizeToFit];
                segmentedControl.dg_centerY = 25;
                [cell addSubview:segmentedControl];
                cell.dg_extWeakObj = segmentedControl;
                return cell;
            }];
            [row setWillDisplay:^(UITableViewCell *  _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
                UISegmentedControl *segmentedControl = cell.dg_extWeakObj;
                segmentedControl.selectedSegmentIndex = self.topViewController.view.dg_colorType;
                segmentedControl.dg_x = cell.dg_safeAreaInsets.left + 20;
            }];
        }];
    }];

    [self.tableView setAllowsSelection:NO];
    [self.tableView setDg_staticProvider:provider];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 刷新控制器
    self.topViewController = dg_topViewController();
    [self.tableView reloadData];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.tableView reloadData];
}

@end
