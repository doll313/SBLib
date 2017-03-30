/*
 #####################################################################
 # File    : TableViewIndex.m
 # Project : SBLib
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
    if (title.length > 0) {
        NSString *tempTitle = [title copy];

        //获取首字母
        if (self.isFirstLetter) {
            tempTitle = [self pinyinFirstLetter:tempTitle];
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
        return @"#";
    }
}

//系统获取首字母
- (NSString *)pinyinFirstLetter:(NSString*)sourceString {
    NSMutableString *source = [sourceString mutableCopy];
    if (source.length > 0) {

        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);//这一行是去声调的

        NSString *text = [source substringToIndex:1];
        if ([text isFirstLetter]) {
            return text;
        }
    }

    return @"#";
}

//判断是不是字母
- (BOOL)isLetter:(NSString *)str {
    if ([str characterAtIndex:0] >= 'a' && [str characterAtIndex:0] <= 'z') {
        return YES;
    }
    if ([str characterAtIndex:0] >= 'A' && [str characterAtIndex:0] <= 'Z') {
        return YES;
    }

    return NO;
}

//  添加数据
- (void)appendResult:(DataItemResult *)result {
    BOOL hasEmoji = NO;     //有符号

    NSMutableSet *lettersSet = [[NSMutableSet alloc] init];
    for (DataItemDetail *item in result.dataList) {
        //获取首字母
        NSString *str = [item getString:self.indexKey];
        NSString *it = [self fetchFirstIndexTitle:str];
        [item setString:it forKey:__KEY_CELL_INDEXTITLE];

        //是字母
        if ([self isLetter:it]) {
            [lettersSet addObject:it];
        }
        else {
            hasEmoji = YES;
        }
    }

    self.compositorArray = [[lettersSet allObjects] sortedArrayUsingSelector:@selector(compare:)];

    //为了把# 放在最后
    if (hasEmoji) {
        self.compositorArray = [self.compositorArray arrayByAddingObject:@"#"];
    }

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
    SBTableData *tableData = [self dataOfSection:section];
    NSUInteger rowCount = [tableData.tableDataResult count];

    //无数据，加载完毕
    if (rowCount == 0) {
        //空单元格
        return 1;
    }
    //无加载情况，显示数等于数据个数
    return rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrTableData count];
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
        return self.sectionIndexTitles(self);
    }
    return self.compositorArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (self.fetchIndexTitle) {
        return self.fetchIndexTitle(self, title, index);
    }
    return index;
}
@end
