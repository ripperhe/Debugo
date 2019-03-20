//
//  DGFileListViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGFileListViewController.h"
#import "DGFileParser.h"
#import "DGPreviewManager.h"
#import "DGDefaultPreviewViewController.h"
#import "DGFileInfoViewController.h"
#import "DGBase.h"

@interface DGFileListViewController ()<UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>

// TableView
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;

// Data
@property (nonatomic, strong) NSArray <DGFBFile *>*files;
@property (nonatomic, strong) NSURL *initialURL;
@property (nonatomic, weak) DGFileParser *parser;
@property (nonatomic, strong) DGPreviewManager *previewManager;
@property (nonatomic, strong) NSMutableArray <NSMutableArray <DGFBFile *>*>*sections;

// Search controller
@property (nonatomic, strong) NSArray <DGFBFile *>*filteredFiles;
@property (nonatomic, strong) UISearchController *searchController;

// Navigation
@property (nonatomic, assign) BOOL showCancelButton;

// Fix
@property (nonatomic, assign) BOOL originalNavigationBarTranslucent;
@property (nonatomic, assign) BOOL hasChangeNavigationBarTranslucent;

@end

@implementation DGFileListViewController

#pragma mark - Lifecycle

- (instancetype)initWithInitialURL:(NSURL *)initialURL
{
    return [self initWithInitialURL:initialURL showCancelButton:YES];
}

- (instancetype)initWithInitialURL:(NSURL *)initialURL showCancelButton:(BOOL)showCancelButton
{
    self = [super init];
    if (self) {
        
        // TODO: Search 新方案
        self.edgesForExtendedLayout = UIRectEdgeNone;

        // Set initial path
        self.initialURL = initialURL;
        self.title = initialURL.lastPathComponent;
        
        // Set search controller delegates
        self.searchController.searchResultsUpdater = self;
        self.searchController.searchBar.delegate = self;
        self.searchController.delegate = self;
        
        // navigationItem
        __weak typeof(self) weakSelf = self;
        DGShareBarButtonItem *shareBarButtonItem = [[DGShareBarButtonItem alloc] initWithViewController:self clickedShareURLsBlock:^NSArray<NSURL *> * _Nonnull(DGShareBarButtonItem * _Nonnull item) {
            return @[weakSelf.initialURL];
        }];

        self.showCancelButton = showCancelButton;
        if (showCancelButton) {
            // Add dismiss button
            UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
            self.navigationItem.rightBarButtonItems = @[dismissButton, shareBarButtonItem];
        }else {
            self.navigationItem.rightBarButtonItem = shareBarButtonItem;
        }
        
        // For set lineBreakMode
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = self.title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableView];
    [self prepareData];
    
    // Set search bar
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Register for 3D touch
    [self registerFor3DTouch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Scroll to hide search bar
    self.tableView.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height);
    
    // Make sure navigation bar is visible
    if (self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Fix
    if (self.hasChangeNavigationBarTranslucent) {
        self.navigationController.navigationBar.translucent = self.originalNavigationBarTranslucent;
        self.hasChangeNavigationBarTranslucent = NO;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - event
- (void)dismiss:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data

- (void)prepareData
{
    if (self.initialURL) {
        __weak typeof(self) weakSelf = self;
        self.files = [self.parser filesForDirectory:self.initialURL errorHandler:^(NSError *error) {
            if (!error) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:OKAction];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            });
        }];
        [self indexFiles];
    }
}

- (void)indexFiles
{
    [self.sections removeAllObjects];
    for (int i = 0; i < self.collation.sectionTitles.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        [self.sections addObject:array];
    }
    NSArray *sortedObjects = [self.collation sortedArrayFromArray:self.files collationStringSelector:@selector(displayName)];
    for (id object in sortedObjects) {
        NSInteger sectionNumber = [self.collation sectionForObject:object collationStringSelector:@selector(displayName)];
        [[self.sections objectAtIndex:sectionNumber] addObject:object];
    }
}

- (DGFBFile *)fileForIndexPath:(NSIndexPath *)indexPath
{
    DGFBFile *file = nil;
    if (self.searchController.isActive) {
        file = [self.filteredFiles objectAtIndex:indexPath.row];
    }else{
        file = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    return file;
}

- (void)filterContentForSearchText:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(DGFBFile *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.displayName.lowercaseString containsString:searchText.lowercaseString];
    }];
    self.filteredFiles = [self.files filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (UILocalizedIndexedCollation *)collation
{
    if (!_collation) {
        _collation = [UILocalizedIndexedCollation currentCollation];
    }
    return _collation;
}

- (DGFileParser *)parser
{
    return DGFileParser.shareInstance;
}

- (DGPreviewManager *)previewManager
{
    if (!_previewManager) {
        _previewManager = [[DGPreviewManager alloc] init];
    }
    return _previewManager;
}

- (NSMutableArray<NSMutableArray<DGFBFile *> *> *)sections
{
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchController.searchBar.backgroundColor = UIColor.whiteColor;
        searchController.dimsBackgroundDuringPresentation = NO;
        _searchController = searchController;
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.isActive) {
        return 1;
    }
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.isActive) {
        return self.filteredFiles.count;
    }
    return [self.sections objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    DGFBFile *selectedFile = [self fileForIndexPath:indexPath];
    cell.textLabel.text = selectedFile.displayName;
    cell.detailTextLabel.text = selectedFile.simpleInfo;
    cell.imageView.image = selectedFile.image;
    if (selectedFile.isDirectory) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    DGFBFile *selectedFile = [self fileForIndexPath:indexPath];
    DGFileInfoViewController *fileInfoVC = [[DGFileInfoViewController alloc] initWithFile:selectedFile];
    [self.navigationController pushViewController:fileInfoVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGFBFile *selectedFile = [self fileForIndexPath:indexPath];
    self.searchController.active = NO;
    if (selectedFile.isDirectory) {
        DGFileListViewController *fileListViewController = [[DGFileListViewController alloc] initWithInitialURL:selectedFile.fileURL showCancelButton:self.showCancelButton];
        fileListViewController.allowEditing = self.allowEditing;
        fileListViewController.didSelectFile = self.didSelectFile;
        fileListViewController.databaseFileUIConfig = self.databaseFileUIConfig;
        [self.navigationController pushViewController:fileListViewController animated:YES];
    }else{
        if (self.didSelectFile) {
            [self dismiss:nil];
            self.didSelectFile(selectedFile);
        }else{
            DGDatabaseUIConfig *config = nil;
            if (selectedFile.type == DGFBFileTypeDB && self.databaseFileUIConfig) {
                config = self.databaseFileUIConfig(selectedFile);
            }
            UIViewController *filePreview = [self.previewManager previewViewControllerForFile:selectedFile fromNavigation:YES uiConfig:config];
            [self.navigationController pushViewController:filePreview animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.isActive) {
        return nil;
    }
    
    if ([self.sections objectAtIndex:section].count > 0) {
        return [self.collation.sectionTitles objectAtIndex:section];
    }else{
        return nil;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.isActive) {
        return nil;
    }
    return self.collation.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.searchController.isActive) {
        return 0;
    }
    return [self.collation sectionForSectionIndexTitleAtIndex:index];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DGFBFile *selectedFile = [self fileForIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        [selectedFile deleteWithErrorHandler:^(NSError *error) {
            if (!error) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:OKAction];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            });
        }];
        
        [self prepareData];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.allowEditing;
}

#pragma mark - UIViewControllerPreviewingDelegate

- (void)registerFor3DTouch
{
    if (@available(iOS 9.0, *)) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
        }
    }
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    if (@available(iOS 9.0, *)) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        if (indexPath) {
            DGFBFile *selectedFile = [self fileForIndexPath:indexPath];
            DGDatabaseUIConfig *config = nil;
            if (selectedFile.type == DGFBFileTypeDB && self.databaseFileUIConfig) {
                config = self.databaseFileUIConfig(selectedFile);
            }
            previewingContext.sourceRect = [self.tableView rectForRowAtIndexPath:indexPath];
            if (selectedFile.isDirectory == NO) {
                return [self.previewManager previewViewControllerForFile:selectedFile fromNavigation:NO uiConfig:config];
            }
        }
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    DGDefaultPreviewViewController *previewTransitionViewController = (DGDefaultPreviewViewController *)viewControllerToCommit;
    if ([previewTransitionViewController isKindOfClass:[DGDefaultPreviewViewController class]]) {
        [self.navigationController pushViewController:previewTransitionViewController.quickLookPreviewController animated:YES];
    }else{
        [self.navigationController pushViewController:viewControllerToCommit animated:YES];
    }
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    // Fix searchbar 消失的问题
    // 参考：https://blog.csdn.net/yejiajun945/article/details/51698603
    self.originalNavigationBarTranslucent = self.navigationController.navigationBar.translucent;
    self.hasChangeNavigationBarTranslucent = YES;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.navigationController.navigationBar.translucent = self.originalNavigationBarTranslucent;
    self.hasChangeNavigationBarTranslucent = NO;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchBar.text];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self filterContentForSearchText:searchController.searchBar.text];
}

@end
