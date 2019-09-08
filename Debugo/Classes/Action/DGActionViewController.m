//
//  DGActionViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGActionViewController.h"
#import "DGAssistant.h"
#import "DGActionSubViewController.h"
#import "DGActionManager.h"

static NSString *kDGCellID = @"kDGCellID";

@interface DGActionViewController ()

@property (nonatomic, strong) NSMutableArray <NSArray <DGAction *>*>*dataArray;

@end

@implementation DGActionViewController

- (void)dealloc {
    DGLogFunction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self configTableView];
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
        label.text = @"Please add actions.";
        self.tableView.tableFooterView = label;
    }else {
        self.tableView.tableFooterView = nil;
    }
}

#pragma mark - getter
- (NSMutableArray <NSArray <DGAction *>*>*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        NSMutableDictionary<NSString *,DGOrderedDictionary<NSString *,DGAction *> *> *usersActionsDic = DGActionManager.shared.usersActionsDic.mutableCopy;
        
        // current
        __block NSArray <DGAction *>*currentActions =  nil;
        // #
        __block NSMutableArray <DGAction *>*otherActions = [NSMutableArray array];
        [usersActionsDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DGOrderedDictionary<NSString *,DGAction *> * _Nonnull obj, BOOL * _Nonnull stop) {
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
                DGAction *action = [DGAction actionWithTitle:title autoClose:NO handler:^(DGAction * _Nonnull action, UIViewController * _Nonnull actionVC) {
                    DGActionSubViewController *subVC = [[DGActionSubViewController alloc] initWithActions:action.dg_strongExtObj];
                    subVC.title = action.title;
                    [actionVC.navigationController pushViewController:subVC animated:YES];
                }];
                action.dg_strongExtObj = obj.reverseSortedValues;
                [otherActions addObject:action];
            }
        }];
        
        // common action
        NSArray *commonActions = [DGActionManager shared].commonActions.copy;
        // anonymous
        NSArray *anonymousActions = [DGActionManager shared].anonymousActionDic.reverseSortedValues;
        
        if (currentActions.count) {
            currentActions.dg_copyExtObj = dg_current_user();
            [_dataArray addObject:currentActions];
        }
        
        if (commonActions.count) {
            commonActions.dg_copyExtObj = @"Common";
            [_dataArray addObject:commonActions];
        }
        
        if (!_dataArray.count) {
            if (anonymousActions.count) {
                anonymousActions.dg_copyExtObj = @"🙈 anonymous";
                [_dataArray addObject:anonymousActions];
            }
        }else {
            if (anonymousActions.count) {
                DGAction *action = [DGAction actionWithTitle:@"🙈 anonymous" autoClose:NO handler:^(DGAction * _Nonnull action, UIViewController * _Nonnull actionVC) {
                    DGActionSubViewController *subVC = [[DGActionSubViewController alloc] initWithActions:action.dg_strongExtObj];
                    subVC.title = action.title;
                    [actionVC.navigationController pushViewController:subVC animated:YES];
                }];
                action.dg_strongExtObj = anonymousActions;
                [otherActions insertObject:action atIndex:0];
            }
        }
        
        if (otherActions.count) {
            otherActions.dg_copyExtObj = @"#";
            [_dataArray addObject:otherActions];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDGCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDGCellID];
        cell.detailTextLabel.textColor = kDGHighlightColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DGAction *action = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = action.title;
    if (action.dg_strongExtObj) {
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
        [DGAssistant.shared closeDebugWindow];
    }
    action.handler(action, self);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataArray objectAtIndex:section].dg_copyExtObj;
}

@end
