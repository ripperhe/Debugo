//
//  DGAccountViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGAccountViewController.h"
#import "DGAssistant.h"

@interface DGAccountViewController ()

@property (nonatomic, strong) NSMutableArray <NSArray <DGAccount *>*>*dataArray;

@end

@implementation DGAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (DGAssistant.shared.configuration.accountEnvironmentIsBeta) {
        self.title = @"Login (beta)";
    }else{
        self.title = @"Login (official)";
    }
    
    // table footer
    if (!self.dataArray.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Please add account information.";
        self.tableView.tableFooterView = label;
    }else {
        self.tableView.tableFooterView = nil;
    }
}

#pragma mark - data
- (NSMutableArray<NSArray<DGAccount *> *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        NSArray *temporaryArray = DGAssistant.shared.temporaryAccountDic.reverseSortedValues;
        if (temporaryArray.count) {
            temporaryArray.dg_copyExtObj = @"Temporary";
            [_dataArray addObject:temporaryArray];
        }
        
        NSArray *commonArray = DGAssistant.shared.currentCommonAccountArray.copy;
        if (commonArray.count) {
            commonArray.dg_copyExtObj = @"Common";
            [_dataArray addObject:commonArray];
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
    DGAccount *account = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = kDGHighlightColor;
    }
    cell.textLabel.text = account.username;
    cell.detailTextLabel.text = account.password;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGAccount *account = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [DGAssistant.shared removeLoginWindow];
    if ([DGDebugo.shared.delegate respondsToSelector:@selector(debugoLoginAccount:)]) {
        [DGDebugo.shared.delegate debugoLoginAccount:account];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataArray objectAtIndex:section].dg_copyExtObj;
}

@end
