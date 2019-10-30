//
//  DGActionSubViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/22.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGActionSubViewController.h"
#import "DGEntrance.h"
#import "DGCommon.h"

@interface DGActionSubViewController ()

@property (nonatomic, strong) NSArray <DGAction *>*actions;

@end

@implementation DGActionSubViewController

- (instancetype)initWithActions:(NSArray<DGAction *> *)actions {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.actions = actions.copy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kDGCellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDGCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDGCellID];
        cell.detailTextLabel.textColor = kDGHighlightColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DGAction *action = [self.actions objectAtIndex:indexPath.row];
    cell.textLabel.text = action.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    kDGImpactFeedback
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGAction *action = [self.actions objectAtIndex:indexPath.row];
    if (action.autoClose) {
        [DGEntrance.shared closeDebugWindow];
    }
    action.viewController = self;
    action.handler(action);
}

@end
