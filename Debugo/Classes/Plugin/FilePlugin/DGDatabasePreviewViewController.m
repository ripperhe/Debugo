//
//  DGDatabasePreviewViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabasePreviewViewController.h"
#import "DGDatabaseOperation.h"
#import "DGDatabaseTableContentViewController.h"
#import "DGDatabaseTableInfoViewController.h"
#import "DGCommon.h"

@interface DGDatabasePreviewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DGDatabaseOperation *dbOperation;
@property (nonatomic, strong) NSArray <DGDatabaseTableInfo *>*tableArray;

@end

@implementation DGDatabasePreviewViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add share button
    dg_weakify(self)
    self.navigationItem.rightBarButtonItem = [[DGShareBarButtonItem alloc] initWithViewController:self shareFilePathsWhenClickedBlock:^NSArray<NSString *> * _Nonnull(DGShareBarButtonItem * _Nonnull item) {
        dg_strongify(self)
        return @[self.file.fileURL.path];
    }];

    self.tableArray = [self.dbOperation queryAllTableInfo];
}

- (void)setFile:(DGFile *)file {
    _file = file;
    
    self.title = file.displayName;
    if (file.fileURL) {
        self.dbOperation = [[DGDatabaseOperation alloc] initWithURL:file.fileURL];
    }
}

- (DGDatabasePreviewConfiguration *)previewConfiguration {
    if (!_previewConfiguration) {
        _previewConfiguration = [DGDatabasePreviewConfiguration new];
    }
    return _previewConfiguration;
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    cell.textLabel.text = self.tableArray[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DGDatabaseTableContentViewController *contentController = [[DGDatabaseTableContentViewController alloc] initWithDatabaseOperation:self.dbOperation table:self.tableArray[indexPath.row] previewConfiguration:self.previewConfiguration];
    [self.navigationController pushViewController:contentController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    DGDatabaseTableInfo *tableInfo = [self.tableArray objectAtIndex:indexPath.row];
    DGDatabaseTableInfoViewController *tableInfoVC = [[DGDatabaseTableInfoViewController alloc] initWithTable:tableInfo];
    [self.navigationController pushViewController:tableInfoVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"表";
}


@end
