//
//  CustomPlugin2ViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "CustomPlugin2ViewController.h"
#import "CustomPlugin2.h"
#import "DGStaticProvider.h"
#import "DGCommon.h"

@implementation CustomPlugin2ViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [CustomPlugin2 pluginName];
    
    DGStaticProvider *provider = [DGStaticProvider new];
    [provider addSectionWithBlock:^(DGStaticSection * _Nonnull section) {
        [section addRowWithBlock:^(DGStaticRow * _Nonnull row) {
            [row setCreateCell:^UITableViewCell * _Nonnull(NSIndexPath * _Nonnull indexPath, NSString * _Nonnull identifier) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.textLabel.text = @"是否开启自定义工具2";
                UISwitch *switchView = [UISwitch new];
                [switchView setOn:[CustomPlugin2 pluginSwitch]];
                [switchView dg_addReceiverForControlEvents:UIControlEventValueChanged handler:^(UISwitch *  _Nonnull sender) {
                    [CustomPlugin2 setPluginSwitch:sender.isOn];
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
