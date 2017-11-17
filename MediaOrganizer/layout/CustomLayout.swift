//
//  CustomLayout.swift
//  MediaOrganizer
//
//  Created by Carlos De la mora on 11/15/17.
//  Copyright © 2017 carlosdelamora. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewLayout {
    
    var numberOfColumns = 0 
    var cached:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var padding: CGFloat = 0
    var columnWidth: CGFloat{
        let width = collectionView!.frame.width/CGFloat(numberOfColumns)
        return width
    }
    //we need to compute the content height in the prepare function
    var contentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize{
        let width = collectionView!.frame.width
        return CGSize(width: width, height: contentHeight)
    }
    var photoHeaderWidth: CGFloat {
        return collectionView!.frame.width
    }
    var photoHeaderHeight: CGFloat = 30
    
    override func prepare() {
        if cached.isEmpty{
            
            func xOffset(item:Int)-> CGFloat{
                switch item%18{
                case 0,3,2,6,9,12,15:
                    return columnWidth*CGFloat(0)
                case 1,4,7,13,16:
                    return columnWidth*CGFloat(1)
                default:// 5,8,10,11,14,17:
                    return columnWidth*CGFloat(2)
                }
            }
            //we start with the yOffset of the first row and build inductively the next rows
           // var yOffet = [CGFloat](repeating:0, count: numberOfColumns)
            func yOffset(item:Int, yshift: CGFloat)-> CGFloat{
                let integralpart:Int = item/18
                var shiftModInt:Int
                switch item%18{
                case 0,1:
                    shiftModInt = 0
                case 2:
                    shiftModInt = 1
                case 3,4,5:
                    shiftModInt = 2
                case 6,7,8:
                    shiftModInt = 3
                case 9,10:
                    shiftModInt = 4
                case 11:
                    shiftModInt = 5
                case 12,13,14:
                    shiftModInt = 6
                default: // 15,16,17:
                    shiftModInt = 7
                }
                
                return CGFloat(shiftModInt + integralpart*8)*columnWidth + yshift//we use 8 here because is number of squares above 18. It means that the height of the 17 is above 7 squares
            }
            
            var cellHeight: CGFloat
            
            //we get the attributes for the first section
            for item in 0..<collectionView!.numberOfItems(inSection: 0){
                //if the item is congruent with 2 or 10 mod 18 we make it double the width
                if item%18 == 1 || item%18 == 9{
                    cellHeight = 2*columnWidth
                }else{
                    cellHeight = columnWidth
                }
                let indexPath = IndexPath(item:item,section:0)
                let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let frame = CGRect(x: xOffset(item:item), y: yOffset(item:item,yshift:photoHeaderHeight), width: cellHeight, height: cellHeight)
                let insetFrame = frame.insetBy(dx: padding, dy: padding)
                layoutAttributes.frame = insetFrame
                cached.append(layoutAttributes)
                contentHeight = max(yOffset(item:item + 2, yshift: photoHeaderHeight ), contentHeight)
            }
            
            let indexPath = IndexPath(item:0, section:0)
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: suplementatryViewKind.header, with: indexPath)
            let frame = CGRect(x: 0, y: 0, width: photoHeaderWidth , height: photoHeaderHeight)
            attributes.frame = frame
            cached.append(attributes)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesArray = [UICollectionViewLayoutAttributes]()
        for attributes in cached{
            if attributes.frame.intersects(rect){
               attributesArray.append(attributes)
            }
        }
        return attributesArray
    }
    
    //this function is now getting called
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        //var attributesArray = [UICollectionViewLayoutAttributes]()
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: suplementatryViewKind.header, with: indexPath)
        let frame = CGRect(x: 0, y: 0, width: 300 , height: 200)
        attributes.frame = frame
        return attributes
    }
    
    
}
