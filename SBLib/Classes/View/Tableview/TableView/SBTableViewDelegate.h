//
//  SBTableViewDelegate.h
//  SBModule
//
//  Created by roronoa on 16/5/2.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

//TableView 中用到的 UITableViewCell 协议
@protocol SBTableViewCellDelegate <NSObject>
@required

/** 单元格的表格视图，当单元格显示时会被重新赋值 */
@property (nonatomic,assign) SBTableView *table;

/** 单元格在表格中的位置，当单元格显示时会被重新赋值 */
@property (nonatomic,retain) NSIndexPath *indexPath;

/** 单元格对应的数据，当单元格显示时会被重新赋值 */
@property (nonatomic,retain) DataItemDetail *cellDetail;

/** 单元个所在的表格节点对应的节点数据 */
@property (nonatomic,retain) SBTableData *tableData;

/** 绑定数据到单元格上的UI，单元格显示时会被调用 */
- (void)bindCellData;

/** 获取一个新的单元格 */
+ (id)createCell:(NSString *)reuseIdentifier;

/** 获取单元格的ID */
+ (NSString *)cellID:(SBTableView *)table;

@optional

@end


