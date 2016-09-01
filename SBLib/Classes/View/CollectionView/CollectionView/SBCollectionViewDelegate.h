//
//  SBCollectionViewDelegate.h
//  SBModule
//
//  Created by roronoa on 16/5/2.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

// 中用到的  协议
@protocol SBCollectionCellDelegate <NSObject>
@required

/** 单元格的表格视图，当单元格显示时会被重新赋值 */
@property (nonatomic,assign) SBCollectionView *collectionView;

/** 单元格在表格中的位置，当单元格显示时会被重新赋值 */
@property (nonatomic,retain) NSIndexPath *indexPath;

/** 单元格对应的数据，当单元格显示时会被重新赋值 */
@property (nonatomic,retain) DataItemDetail *itemDetail;

/** 单元个所在的表格节点对应的节点数据 */
@property (nonatomic,retain) SBCollectionData *collectionData;

/** 绑定数据到单元格上的UI，单元格显示时会被调用 */
- (void)bindItemData;

//创建单元格
+ (id)createCell:(CGRect)rect;

/** 获取单元格的ID */
+ (NSString *)cellID:(SBTableView *)table;

@end
