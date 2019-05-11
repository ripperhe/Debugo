//
//  DGActionSubViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/22.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGActionSubViewController.h"
#import "DGAssistant.h"

static NSString *kDGCellID = @"kDGCellID";

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
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGAction *action = [self.actions objectAtIndex:indexPath.row];
    if (action.autoClose) {
        [DGAssistant.shared closeDebugViewControllerContainerWindow];
    }
    action.handler(action, self);
}

@end
