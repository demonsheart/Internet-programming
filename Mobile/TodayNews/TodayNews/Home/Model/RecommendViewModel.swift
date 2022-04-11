//
//  RecommendViewModel.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import Foundation

protocol RandomNews {
}

class RecommendViewModel {
    var topNews = TopNewsModel.default
    
    var bigNews = BigPicNewsModel.default
    var threesPicNews = ThreePicNewsModel.default
    var rightPicNews = RightPicNewsModel.default
    
    func getData(index: Int) -> RandomNews? {
        let total = bigNews.count + threesPicNews.count + rightPicNews.count
        
        if total == 0 {
            return nil
        }
        
        if index >= 0 && index < bigNews.count {
            return bigNews[index]
        } else if index >= bigNews.count && index < bigNews.count + threesPicNews.count {
            return threesPicNews[index - bigNews.count]
        } else {
            return rightPicNews[index - bigNews.count - threesPicNews.count]
        }
    }
}
