/*
 #####################################################################
 # File    : TableViewIndex.m
 # Project : GubaModule
 # Created : 14-6-11
 # DevTeam : eastmoney
 # Author  : Thomas
 # Notes   : 
 #####################################################################
 ### Change Logs   ###################################################
 #####################################################################
 ---------------------------------------------------------------------
 # Date  :
 # Author:
 # Notes :
 #
 #####################################################################
 */

#import "SBIndexTableView.h"
#import "SBDataTableCell.h"

@implementation SBIndexTableView

- (id)initWithStyle:(BOOL)isGrouped {
    self = [super initWithStyle:NO];
    if (self != nil) {
        self.compositorArray = [[NSArray alloc] init];
        _listDataCellClass = [SBDataTableCell class];
        _indexKey = __KEY_CELL_INDEXTITLE; //默认为title，也可以传值进去
        self.sectionIndexBackgroundColor = [UIColor clearColor];//section索引的背景色
    }
    return self;
}

- (void)dealloc {
}

//获取首字母
- (NSString *)fetchFirstIndexTitle:(NSString *)title {
    if (title.length >= 1) {
        NSString *tempTitle = [title copy];

        //获取首字母
        if (self.isFirstLetter) {
            tempTitle = [tempTitle sb_cnFirstLetter];
            if (self.isIndexUppercase) {
                tempTitle = [tempTitle uppercaseString];
            }
        }
        else {
            tempTitle = [tempTitle lowercaseString];
            tempTitle = [tempTitle substringToIndex:1];
        }
        return tempTitle;
    }
    else {
        return @"*";
    }
}

//  添加数据
- (void)appendResult:(DataItemResult *)result {
    NSMutableSet *lettersSet = [[NSMutableSet alloc] init];
    for (DataItemDetail *item in result.dataList) {
        //获取首字母
        NSString *str = [item getString:self.indexKey];
        NSString *firstLetter = [self fetchFirstIndexTitle:str];
        [item setString:firstLetter forKey:__KEY_CELL_INDEXTITLE];
        [lettersSet addObject:firstLetter];
    }
    
    self.compositorArray = [[lettersSet allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = (NSString *)obj1;
        NSString *string2 = (NSString *)obj2;

        if ([string1 isEqualToString:@"#"] || [string1 isEqualToString:@"*"]) {
            return NSOrderedDescending;
        }
        //
        if (string2 < string1)
            return NSOrderedDescending;
        return NSOrderedAscending;
    }];

    [self clearTableData];//由于一开始加过一次数据，所以需要先把数据移除

    if (self.compositorArray.count > 0) {
        //组合成DataItemResult类型
        for (NSString *compositor in self.compositorArray) {
            DataItemResult *dataResult = [[DataItemResult alloc] init];
            for (DataItemDetail *item in result.dataList) {
                //获取首字母
                NSString *indexTitle = [item getString:__KEY_CELL_INDEXTITLE];
                if ([compositor isEqualToString:indexTitle]) {
                    [dataResult.dataList addObject:item];
                }
            }
            dataResult.maxCount = result.dataList.count;
            dataResult.statusCode = result.statusCode;

            SBTableData *viewData = [[SBTableData alloc] init];
            viewData.mDataCellClass = _listDataCellClass;// 先赋值，否则运行addSectionWithData判空会出错
            viewData.hasHeaderView = YES;
            viewData.headerTitle = compositor;
            viewData.httpStatus = SBHttpTaskStateFinished;
            [viewData.tableDataResult appendItems:dataResult];
            [self addSectionWithData:viewData];
        }
    }
    else {
        DataItemResult *dataResult = [[DataItemResult alloc] init];
        dataResult.maxCount = 0;
        dataResult.statusCode = result.statusCode;

        SBTableData *viewData = [[SBTableData alloc] init];
        viewData.mDataCellClass = _listDataCellClass;// 先赋值，否则运行addSectionWithData判空会出错
        if (self.listEmptyCellClass) {
            viewData.mEmptyCellClass = self.listEmptyCellClass;
        }

        if (self.listErrorCellClass) {
            viewData.mErrorCellClass = self.listErrorCellClass;
        }

        viewData.httpStatus = SBHttpTaskStateFinished;
        [viewData.tableDataResult appendItems:dataResult];
        [self addSectionWithData:viewData];
    }

}

#pragma mark -
#pragma mark datasource method

//  重写父类的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //没有分段
    if (self.compositorArray.count == 0) {
        return 1;
    }

    return  [[self dataOfSection:section].tableDataResult.dataList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(1, [self.compositorArray count]);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = self.compositorArray[section];
    return title ? title : @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;//这个不nil   titleForHeaderInSection 不执行
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.compositorArray.count > 0 ? 20.0f : 0;
}

//表尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

/** view已经停止滚动 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //加载下一页
    if (![scrollView isKindOfClass:[SBTableView class]]) {
        return;
    }

    if (self.endDecelerating) {
        self.endDecelerating(self);
    }
}

#pragma mark -
#pragma mark delegate method

//  返回索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.sectionIndexTitles) {
        return self.sectionIndexTitles(tableView);
    }
    return self.compositorArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (self.fetchIndexTitle) {
        return self.fetchIndexTitle(tableView, title, index);
    }
    return index;
}
@end
