//
//  WaterFullFlowLayout.swift
//  swiftWaterFull
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit


//MARK: 这里是给外部调用的方法
protocol WaterfallLayoutDataSource : class {
    //返回的列数
    func numberOfCols(_ waterfall : WaterFullFlowLayout) -> Int
    
    
    //每一个Cell的高度
    func waterfall(_ waterfall : WaterFullFlowLayout, item : Int) -> CGFloat
}


class WaterFullFlowLayout: UICollectionViewFlowLayout {
    
     weak var dataSource : WaterfallLayoutDataSource?
    
    //分成几列
    fileprivate lazy var colCount : Int = self.dataSource?.numberOfCols(self) ?? 2
    
    //保存所有的cell的Attributes
    fileprivate lazy var attrs : [UICollectionViewLayoutAttributes] =  [UICollectionViewLayoutAttributes]()
    
    //保存所有Cell高度的数组
    fileprivate lazy var cellHeights : [CGFloat] = Array(repeating: self.sectionInset.top, count:self.colCount)

}

extension WaterFullFlowLayout{
    
    open override func prepare() {
        
        super.prepare()
        
        guard let strongCollectionView = collectionView else { fatalError("没有CollectionView") }
        
        //宽度
        let width : CGFloat = (strongCollectionView.frame.width - sectionInset.left - sectionInset.right - CGFloat(colCount - 1) * minimumInteritemSpacing) / CGFloat(colCount)
        
        
        //拿到所有的item
        let cellCount = strongCollectionView.numberOfItems(inSection: 0)
        
        //遍历所有的Cell
        for i in attrs.count..<cellCount{
            
            let indexPath = IndexPath(item: i, section: 0)
            
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let minH = cellHeights.min()!
            let minIndex = cellHeights.index(of: minH)!
            
            
            let cellX = sectionInset.left + (minimumInteritemSpacing + width) * CGFloat(minIndex)
            let cellY = minH + minimumInteritemSpacing
            guard let height : CGFloat = dataSource?.waterfall(self, item: i) else {
                fatalError("请实现对应的数据源方法,并且返回Cell高度")
            }
            
            attr.frame = CGRect(x: cellX, y: cellY, width: width, height: height)
            attrs.append(attr)
            cellHeights[minIndex] = cellY + height
        }
    }
}

//MARK: 返回所有Cell的layoutAttributes
extension WaterFullFlowLayout{
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
    
}

//MARK: 返回所有Cell的ContentSize
extension WaterFullFlowLayout{
    override var collectionViewContentSize: CGSize{
        return CGSize(width: 0, height: cellHeights.max()! + CGFloat(10))
    }
}
