//
//  NewsDetailModel.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/12.
//

import Foundation
import SnapKit

struct NewsDetailModel {
    let title: String
    let avatar: String
    let source: String
    let sourceInfo: String
    let content: String
    let picURLs: [String]
    
    static var `default`: NewsDetailModel =
        NewsDetailModel(title: "习近平：把所有的精力都用在让老百姓过好日子上",
                        avatar: "https://p3-sign.toutiaoimg.com/pgc-image/21507a12df2c4e7eb2d859c6f32dd497~tplv-tt-large.image?x-expires=1965128203&x-signature=RgTmiaTxyrICK4%2B%2B1xB4esDHb7U%3D",
                        source: "新华社",
                        sourceInfo: "3个小时前 · 新华社官方账号",
                        content: "【习近平：#把所有的精力都用在让老百姓过好日子上#】11日下午，习近平总书记来到海南五指山脚下的水满乡毛纳村。走进黎族群众家中看望，同村干部、村民代表亲切交流。村广场上，乡亲们热情欢迎总书记到来。习近平对大家说，我们已经建成全面小康社会，接着要奔向现代化，推进共同富裕。乡村振兴工作要扎扎实实、踏踏实实做，首先要巩固脱贫成果，巩固住再往前走，同乡村全面振兴有效衔接。中国共产党关心的就是让全国各族群众日子过得一天比一天好。党没有自己的利益，党的领导干部更不应该有自己的私利，要坚持党的根本宗旨和党的群众路线，把所有的精力都用在让老百姓过好日子上。（文字记者：张晓松、朱基钗；摄影记者：李学仁、谢环驰、燕雁）#习近平在海南考察调研#",
                        picURLs: [
                            "https://p26.toutiaoimg.com/large/tos-cn-i-qvj2lq49k0/60efd3b4ba0944358e49ea0db0e8b2b3",
                            "https://p6.toutiaoimg.com/large/tos-cn-i-qvj2lq49k0/493c5371a97f452d91929b5f9f76b68e",
                            "https://p9.toutiaoimg.com/large/tos-cn-i-qvj2lq49k0/08a55e34c4ae4a56b4565c7ad4d2543b",
                        ])
}
