# waterFullLayout
swift3.0下的瀑布流的简单实现

`override func prepare()` : 准备阶段，在这个里面定义所有Cell的Attributes

`override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?`这个里面返回`prepare`里面准备好的数组

`override var collectionViewContentSize: CGSize`返回对应的内容宽高

