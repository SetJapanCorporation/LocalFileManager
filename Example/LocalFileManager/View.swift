//
//  View.swift
//  LocalFileManager
//
//  Created by Asakura Shinsuke on 2017/06/28.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class View: UIView {

    let table :UITableView
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(frame: CGRect) {
        table = UITableView(frame: .zero, style: .grouped);
        table.backgroundColor = .lightGray
        
        super.init(frame: frame);
        self.addSubview(table);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        table.frame = self.frame
    }

}
