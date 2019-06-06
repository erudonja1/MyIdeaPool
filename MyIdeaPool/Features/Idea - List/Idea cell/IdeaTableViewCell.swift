//
//  IdeaTableViewCell.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/5/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import UIKit

protocol IdeaTableViewProtocol {
    func optionsTapped(for idea: ApiIdea)
}

class IdeaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var impactValueLabel: UILabel!
    @IBOutlet weak var easeValueLabel: UILabel!
    @IBOutlet weak var confidenceValueLabel: UILabel!
    @IBOutlet weak var avgValueLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    private var idea: ApiIdea?
    private var delegate: IdeaTableViewProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(with idea: ApiIdea, delegate: IdeaTableViewProtocol){
        self.idea = idea
        self.delegate = delegate
        
        containerView.layer.cornerRadius = 5
        containerView.layer.borderWidth = 0.3
        containerView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.33).cgColor
        containerView.addShadow()
        
        contentLabel.text = idea.content
        impactValueLabel.text = String(idea.impact)
        easeValueLabel.text = String(idea.ease)
        confidenceValueLabel.text = String(idea.confidence)
        
        let roundedValueAvg = round(100 * idea.averageScore)/100
        avgValueLabel.text = String(roundedValueAvg)
    }

    @IBAction func optionsTapped(_ sender: Any) {
        if let idea = idea, let delegate = delegate {
             delegate.optionsTapped(for: idea)
        }
    }
}
