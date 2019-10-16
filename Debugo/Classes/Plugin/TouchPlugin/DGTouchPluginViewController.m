//
//  DGTouchPluginViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/12.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGTouchPluginViewController.h"
#import "DGCommon.h"
#import "DGTouchPlugin.h"

@implementation DGTouchPluginViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [DGTouchPlugin pluginName];
    
    DGStaticProvider *provider = [DGStaticProvider new];
    [provider addSectionWithBlock:^(DGStaticSection * _Nonnull section) {
        [section addRowWithBlock:^(DGStaticRow * _Nonnull row) {
            [row setCreateCell:^UITableViewCell * _Nonnull(NSIndexPath * _Nonnull indexPath, NSString * _Nonnull identifier) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.textLabel.text = @"是否开启触摸监听";
                UISwitch *switchView = [UISwitch new];
                [switchView setOn:[DGTouchPlugin pluginSwitch]];
                [switchView dg_addReceiverForControlEvents:UIControlEventValueChanged handler:^(UISwitch *  _Nonnull sender) {
                    [DGTouchPlugin setPluginSwitch:sender.isOn];
                }];
                cell.accessoryView = switchView;
                return cell;
            }];
            [row setHeight:60];
        }];
        [section setHeaderHeight:20];
    }];
    self.tableView.allowsSelection = NO;
    self.tableView.bounces = NO;
    [self.tableView setDg_staticProvider:provider];
    [self.tableView reloadData];
}

@end
