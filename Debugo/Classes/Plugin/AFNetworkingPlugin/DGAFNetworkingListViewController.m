//
//  DGAFNetworkingListViewController.m
//  Debugo
//

#import "DGAFNetworkingListViewController.h"
#import "DGAFNetworkingCell.h"
#import "DGAFNetworkingCenter.h"
#import "DGAFNetworkingDetailViewController.h"
#import "DGAFNetworkingLayout.h"
#import "DGTool.h"

@interface DGAFNetworkingListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *listTitle;
@property (nonatomic, copy) NSString *emptyMessage;
@property (nonatomic, strong) id<DGAFNetworkingRecordStore> store;
@property (nonatomic, copy) NSNotificationName changeNotificationName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, copy) NSArray<DGAFNetworkingRecord *> *records;

@end

@implementation DGAFNetworkingListViewController

- (instancetype)init {
    return [self initWithTitle:@"AFNetworking请求拦截"
                     emptyText:@"还没有请求\n业务方传入 AFURLSessionManager 后，对应请求会显示在这里"
                         store:DGAFNetworkingCenter.sharedCenter
        changeNotificationName:DGAFNetworkingRecordsDidChangeNotification];
}

- (instancetype)initWithTitle:(NSString *)title
                    emptyText:(NSString *)emptyText
                        store:(id<DGAFNetworkingRecordStore>)store
       changeNotificationName:(NSNotificationName)changeNotificationName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _listTitle = [title copy];
        _emptyMessage = [emptyText copy];
        _store = store;
        _changeNotificationName = [changeNotificationName copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.listTitle;
    self.view.backgroundColor = kDGBackgroundColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearRecords)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:108 / 255.0 green:92 / 255.0 blue:231 / 255.0 alpha:1];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 280;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(6, 0, 12, 0);
    [tableView registerClass:DGAFNetworkingCell.class forCellReuseIdentifier:NSStringFromClass(DGAFNetworkingCell.class)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    DGAFNetworkingPinEdges(tableView, self.view, UIEdgeInsetsZero);

    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.text = self.emptyMessage;
    emptyLabel.numberOfLines = 0;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont systemFontOfSize:15];
    emptyLabel.textColor = [UIColor grayColor];
    [self.view addSubview:emptyLabel];
    self.emptyLabel = emptyLabel;
    DGAFNetworkingDisableAutoresizing(emptyLabel);
    [NSLayoutConstraint activateConstraints:@[
        DGAFNetworkingConstraint(emptyLabel, NSLayoutAttributeCenterX, NSLayoutRelationEqual, self.view, NSLayoutAttributeCenterX, 0),
        DGAFNetworkingConstraint(emptyLabel, NSLayoutAttributeCenterY, NSLayoutRelationEqual, self.view, NSLayoutAttributeCenterY, 0),
        DGAFNetworkingConstraint(emptyLabel, NSLayoutAttributeLeft, NSLayoutRelationGreaterThanOrEqual, self.view, NSLayoutAttributeLeft, 32),
        DGAFNetworkingConstraint(self.view, NSLayoutAttributeRight, NSLayoutRelationGreaterThanOrEqual, emptyLabel, NSLayoutAttributeRight, 32),
    ]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecords) name:self.changeNotificationName object:nil];
    [self reloadRecords];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)reloadRecords {
    self.records = [self.store allRecords];
    self.emptyLabel.hidden = self.records.count > 0;
    [self.tableView reloadData];
}

- (void)clearRecords {
    [self.store clearRecords];
}

- (void)openDetail:(DGAFNetworkingRecord *)record {
    DGAFNetworkingDetailViewController *viewController = [[DGAFNetworkingDetailViewController alloc] initWithRecord:record];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DGAFNetworkingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(DGAFNetworkingCell.class) forIndexPath:indexPath];
    DGAFNetworkingRecord *record = self.records[indexPath.row];
    cell.modules = self.store.listModules;
    cell.record = record;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self openDetail:self.records[indexPath.row]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
