//
//  DGActionViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGActionViewController.h"
#import "DGEntrance.h"
#import "DGActionSubViewController.h"
#import "DGActionPlugin.h"
#import "DGCommon.h"
#import "Debugo.h"

@interface DGActionViewController ()

@property (nonatomic, strong) NSMutableArray<NSArray<DGAction *>*> *dataArray;

@end

@implementation DGActionViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = [DGActionPlugin pluginName];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_dataArray) {
        // 进页面刷新
        _dataArray = nil;
        [self configTableView];
        [self.tableView reloadData];
    }
}

- (void)configTableView {
    // table footer
    if (!self.dataArray.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"现在还没有指令，请添加指令~";
        self.tableView.tableFooterView = label;
    }else {
        self.tableView.tableFooterView = nil;
    }
}

#pragma mark - getter
- (NSMutableArray <NSArray <DGAction *>*>*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        // 当前用户指令
        __block NSArray<DGAction *> *currentActions =  nil;
        // 其他用户指令
        __block NSMutableArray<DGAction *> *otherActions = [NSMutableArray array];
        // 匿名指令
        NSArray<DGAction *> *anonymousActions = [DGActionPlugin shared].anonymousActionDic.reverseSortedValues;
        // 共享指令
        NSArray<DGAction *> *commonActions = [DGActionPlugin shared].configuration.getAllCommonActions.copy;

        // 赋值
        NSMutableDictionary<NSString *,DGOrderedDictionary<NSString *,DGAction *> *> *usersActionsDic = DGActionPlugin.shared.usersActionsDic.mutableCopy;
        
        NSArray *sortedKeys = [usersActionsDic.allKeys sortedArrayUsingComparator:Debugo.sortUserComparator];
        [sortedKeys enumerateObjectsUsingBlock:^(NSString *_Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            DGOrderedDictionary<NSString *,DGAction *> * _Nonnull obj = usersActionsDic[key];
            if (dg_current_user().length && [key isEqualToString:dg_current_user()]) {
                // current
                currentActions = obj.reverseSortedValues;
            }else {
                // other
                static NSArray <NSString *>*_persons = nil;
                static NSMutableDictionary *_cachedPersonsDic = nil;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    _persons = @[@"👮‍♀️", @"👷🏿‍♀️", @"💂🏽‍♀️", @"👨🏽‍🌾", @"👨🏻‍🍳", @"🕵🏾‍♂️", @"👩🏽‍🏭", @"👨🏼‍💻", @"👩🏾‍🏫", @"👩🏻‍💻", @"🧝‍♀️", @"🧜🏾‍♀️", @"🤦🏼‍♀️", @"🤷🏻‍♂️", @"🙆🏼‍♂️", @"🙇🏿‍♂️", @"🧜🏿‍♂️", @"👩‍🚒"];
                    _cachedPersonsDic = [NSMutableDictionary dictionary];
                });
                NSString *title = [_cachedPersonsDic objectForKey:key];
                if (!title.length) {
                    title = [_persons[arc4random()%_persons.count] stringByAppendingFormat:@" %@", key];
                    [_cachedPersonsDic setObject:title forKey:key];
                }
                DGAction *action = [DGAction actionWithTitle:title autoClose:NO handler:^(DGAction * _Nonnull action) {
                    DGActionSubViewController *subVC = [[DGActionSubViewController alloc] initWithActions:action.dg_extStrongObj];
                    subVC.title = action.title;
                    [action.viewController.navigationController pushViewController:subVC animated:YES];
                }];
                action.dg_extStrongObj = obj.reverseSortedValues;
                [otherActions addObject:action];
            }
        }];
        
        /**
         经实践，最方便的指令展示规则如下
         1. 如果有当前用户指令：第一组展示当前用户指令，第二组展示共享指令，第三组展示匿名指令和其他用户指令
         2. 如果没有当前用户指令:
         2.1. 如果有其他用户指令：第一组展示共享指令，第二组展示匿名指令和其他用户指令
         2.2. 如果没有其他用户指令：第一组展示匿名指令，第二组展示共享指令
         PS: 以上展示规则中，如果没有的，直接跳过
         */

        if (currentActions.count) {
            // 有当前用户指令
            currentActions.dg_extCopyObj = dg_current_user();
            [_dataArray addObject:currentActions];
            
            if (commonActions.count) {
                commonActions.dg_extCopyObj = @"共享指令";
                [_dataArray addObject:commonActions];
            }

            if (anonymousActions.count) {
                // 将匿名指令添加到其他指令数组中，并且从二级页面展开
                DGAction *action = [DGAction actionWithTitle:@"👨🏿‍💻 匿名用户" autoClose:NO handler:^(DGAction * _Nonnull action) {
                    DGActionSubViewController *subVC = [[DGActionSubViewController alloc] initWithActions:action.dg_extStrongObj];
                    subVC.title = action.title;
                    [action.viewController.navigationController pushViewController:subVC animated:YES];
                }];
                action.dg_extStrongObj = anonymousActions;
                [otherActions insertObject:action atIndex:0];
            }
            if (otherActions.count) {
                otherActions.dg_extCopyObj = @"其他用户指令";
                [_dataArray addObject:otherActions];
            }
        }else {
            // 无当前用户指令
            if (otherActions.count) {
                // 有其他用户指令
                if (commonActions.count) {
                    commonActions.dg_extCopyObj = @"共享指令";
                    [_dataArray addObject:commonActions];
                }
                
                if (anonymousActions.count) {
                    // 将匿名指令添加到其他指令数组中，并且从二级页面展开
                    DGAction *action = [DGAction actionWithTitle:@"👨🏿‍💻 匿名用户" autoClose:NO handler:^(DGAction * _Nonnull action) {
                        DGActionSubViewController *subVC = [[DGActionSubViewController alloc] initWithActions:action.dg_extStrongObj];
                        subVC.title = action.title;
                        [action.viewController.navigationController pushViewController:subVC animated:YES];
                    }];
                    action.dg_extStrongObj = anonymousActions;
                    [otherActions insertObject:action atIndex:0];
                }
                if (otherActions.count) {
                    otherActions.dg_extCopyObj = @"其他用户指令";
                    [_dataArray addObject:otherActions];
                }
            }else {
                // 无其他用户指令
                if (anonymousActions.count) {
                    [_dataArray addObject:anonymousActions];
                }
                
                if (commonActions.count) {
                    commonActions.dg_extCopyObj = @"共享指令";
                    [_dataArray addObject:commonActions];
                }
            }
        }
    }
    return _dataArray;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.detailTextLabel.textColor = kDGHighlightColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DGAction *action = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = action.title;
    if (action.dg_extStrongObj) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    kDGImpactFeedback
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGAction *action = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (action.autoClose) {
        [DGEntrance.shared closeDebugWindow];
    }
    action.viewController = self;
    action.handler(action);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataArray objectAtIndex:section].dg_extCopyObj;
}

// https://stackoverflow.com/questions/18912980/uitableview-titleforheaderinsection-shows-all-caps/39504215#39504215
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).textLabel.text = self.dataArray[section].dg_extCopyObj;
    }
}

@end
