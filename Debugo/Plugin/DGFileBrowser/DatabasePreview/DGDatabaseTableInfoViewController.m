//
//  DGDatabaseTableInfoViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/10.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabaseTableInfoViewController.h"

static NSString *kCellID = @"cell";
static NSString *kCellTitle = @"title";
static NSString *kCellValue = @"value";

@interface DGDatabaseTableInfoViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DGDatabaseTableInfoViewController

- (instancetype)initWithTable:(DGDatabaseTableInfo *)table {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.table = table;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[
                       @{kCellTitle:@"name", kCellValue:self.table.name?:@"null"},
                       @{kCellTitle:@"tbl_name", kCellValue:self.table.tbl_name?:@"null"},
                       @{kCellTitle:@"type", kCellValue:self.table.type?:@"null"},
                       @{kCellTitle:@"rootpage", kCellValue:@(self.table.rootpage)},
                       @{kCellTitle:@"sql", kCellValue:self.table.sql?:@"null"},
                       ];
}

- (void)setTable:(DGDatabaseTableInfo *)table {
    _table = table;
    
    self.title = table.name;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 0;
    }
    NSDictionary *data = self.dataArray[indexPath.row];
    cell.textLabel.text = data[kCellTitle];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", data[kCellValue]];
    return cell;
}

@end
