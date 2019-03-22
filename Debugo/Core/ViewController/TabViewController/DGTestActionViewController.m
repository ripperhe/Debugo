//
//  DGTestActionViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGTestActionViewController.h"
#import "DGAssistant.h"
#import "DGTestActionSubViewController.h"

static NSString *kDGCellID = @"kDGCellID";

@interface DGTestActionViewController ()

@property (nonatomic, strong) NSMutableArray <NSArray <DGTestAction *>*>*dataArray;

@end

@implementation DGTestActionViewController

- (void)dealloc
{
    DGLogFunction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_dataArray) {
        // 进页面刷新
        _dataArray = nil;
        [self configTableView];
        [self.tableView reloadData];
    }
}

- (void)configTableView
{
    // table header
    if ([[DGDebugo shared].delegate respondsToSelector:@selector(debugoTestActionViewControllerTableHeaderView)]) {
        UIView *headerView = [[DGDebugo shared].delegate debugoTestActionViewControllerTableHeaderView];
        if (headerView) {
            self.tableView.tableHeaderView = headerView;
        }else {
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        }
    }
    
    // table footer
    if (!self.dataArray.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Please add test actions.";
        self.tableView.tableFooterView = label;
    }else {
        self.tableView.tableFooterView = nil;
    }
}

#pragma mark - getter
- (NSMutableArray <NSArray <DGTestAction *>*>*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        NSMutableDictionary<NSString *,DGOrderedDictionary<NSString *,DGTestAction *> *> *usersTestActionsDic = DGAssistant.shared.usersTestActionsDic.mutableCopy;
        
        // current
        __block NSArray <DGTestAction *>*currentActions =  nil;
        // #
        __block NSMutableArray <DGTestAction *>*otherActions = [NSMutableArray array];
        [usersTestActionsDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DGOrderedDictionary<NSString *,DGTestAction *> * _Nonnull obj, BOOL * _Nonnull stop) {
            if (DGDebugo.shared.currentUser.length && [key isEqualToString:DGDebugo.shared.currentUser]) {
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
                DGTestAction *action = [DGTestAction actionWithTitle:title autoClose:NO handler:^(DGTestAction * _Nonnull action, UIViewController * _Nonnull actionVC) {
                    DGTestActionSubViewController *subVC = [[DGTestActionSubViewController alloc] initWithActions:action.dg_strongExtObj];
                    subVC.title = action.title;
                    [actionVC.navigationController pushViewController:subVC animated:YES];
                }];
                action.dg_strongExtObj = obj.reverseSortedValues;
                [otherActions addObject:action];
            }
        }];
        
        // common action
        NSArray *commonActions = [DGAssistant shared].configuration.commonTestActions.copy;
        // anonymous
        NSArray *anonymousActions = [DGAssistant shared].anonymousTestActionDic.reverseSortedValues;
        
        if (currentActions.count) {
            currentActions.dg_copyExtObj = DGDebugo.shared.currentUser;
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
                DGTestAction *action = [DGTestAction actionWithTitle:@"🙈 anonymous" autoClose:NO handler:^(DGTestAction * _Nonnull action, UIViewController * _Nonnull actionVC) {
                    DGTestActionSubViewController *subVC = [[DGTestActionSubViewController alloc] initWithActions:action.dg_strongExtObj];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGTestAction *action = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = action.title;
    if (action.dg_strongExtObj) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGTestAction *action = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (action.autoClose) {
        [DGAssistant.shared closeDebugViewControllerContainerWindow];
    }
    action.handler(action, self);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dataArray objectAtIndex:section].dg_copyExtObj;
}

@end
