//
//  CustomNavigationBar.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/6/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import UIKit


class CustomNavigationBar: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var leftSideImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CustomNavigationBarView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
