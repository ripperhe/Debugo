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

- (instancetype)initWithTable:(DGDatabaseTableInfo *)table
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self->_table = table;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.table.name;
    // For set lineBreakMode
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.navigationItem.titleView = titleLabel;

    self.dataArray = @[
                       @{kCellTitle:@"name", kCellValue:self.table.name?:@"null"},
                       @{kCellTitle:@"tbl_name", kCellValue:self.table.tbl_name?:@"null"},
                       @{kCellTitle:@"type", kCellValue:self.table.type?:@"null"},
                       @{kCellTitle:@"rootpage", kCellValue:@(self.table.rootpage)},
                       @{kCellTitle:@"sql", kCellValue:self.table.sql?:@"null"},
                       ];
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
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
        cell.detailTextLabel.numberOfLines = 0;
    }
    NSDictionary *data = self.dataArray[indexPath.row];
    cell.textLabel.text = data[kCellTitle];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", data[kCellValue]];
    return cell;
}

@end
