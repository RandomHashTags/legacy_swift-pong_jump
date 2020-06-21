//
//  Scoreboard.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/29/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

class Scoreboard : ConstraintsAPI {
    private var score:Int!
    private var scoreLabel:UILabel!, bestscoreLabel:UILabel!
    private var scoreTextLabel:UILabel!, bestscoreTextLabel:UILabel!
        
    public func start() {
        scoreLabel = UILabel()
        setValues(label: scoreLabel)
        scoreLabel.font = scoreLabel.font.withSize(40)
        setScore(score: 0)
        scoreLabel.isHidden = true
        
        let view:UIView = getView()
        view.addSubview(scoreLabel)
        view.addConstraints(getScoreConstraints(toCenter: false))
        
        addScoreTextLabel()
        addBestScoreTextLabel()
    }
    public func ended() {
        let bestscore:DataValue = DataValue.BEST_SCORE
        data.didScore(score: score)
        if score > data.getCacheValue(dataValue: bestscore) {
            data.setCacheValue(dataValue: bestscore, value: score)
            DispatchQueue.main.async {
                self.bestscoreLabel.text = self.score.description
            }
        }
        data.save()
        setScore(score: score)
        DispatchQueue.main.sync {
            scoreTextLabel.isHidden = false
            bestscoreLabel.isHidden = false
            bestscoreTextLabel.isHidden = false
        }
    }
    public func reset() {
        setScore(score: 0)
        
        scoreTextLabel.isHidden = true
        bestscoreLabel.isHidden = true
        bestscoreTextLabel.isHidden = true
    }
    
    public func addScore() {
        score += 1
    }
    private func setScore(score: Int) {
        self.score = score
        DispatchQueue.main.async {
            self.scoreLabel.isHidden = !self.scoreLabel.isHidden
            self.scoreLabel.text = score.formatUsingCommas()
        }
    }
    
    private func setValues(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
    }
    
    public func getScore() -> Int {
        return score
    }
}

extension Scoreboard {
    private func getView() -> UIView {
        return GAME_CONTROLLER.view
    }
    private func addScoreTextLabel() {
        let view:UIView = getView()
        scoreTextLabel = UILabel()
        setValues(label: scoreTextLabel)
        scoreTextLabel.text = "SCORE"
        scoreTextLabel.font = scoreTextLabel.font.withSize(20)
        scoreTextLabel.isHidden = true
        
        view.addSubview(scoreTextLabel)
        view.addConstraints([
            getConstraint(item: scoreTextLabel!, .top, toItem: view, .top, multiplier: 1, constant: 100),
            getConstraint(item: scoreTextLabel!, .bottom, toItem: scoreLabel, .centerY),
            getConstraint(item: scoreTextLabel!, .left, toItem: view),
            getConstraint(item: scoreTextLabel!, .right, toItem: view, .centerX),
        ])
    }
    private func addBestScoreTextLabel() {
        let view:UIView = getView()
        
        bestscoreLabel = UILabel()
        setValues(label: bestscoreLabel)
        bestscoreLabel.text = data.getCacheValue(dataValue: DataValue.BEST_SCORE).formatUsingCommas()
        bestscoreLabel.font = scoreLabel.font
        bestscoreLabel.isHidden = true
        
        view.addSubview(bestscoreLabel)
        view.addConstraints([
            getConstraint(item: bestscoreLabel!, .top, toItem: view, .top, multiplier: 1, constant: 100),
            getConstraint(item: bestscoreLabel!, .left, toItem: view, .centerX),
            getConstraint(item: bestscoreLabel!, .right, toItem: view),
            getConstraint(item: bestscoreLabel!, .height, toItem: nil, .notAnAttribute, multiplier: 1, constant: 150)
        ])
        
        bestscoreTextLabel = UILabel()
        setValues(label: bestscoreTextLabel)
        bestscoreTextLabel.text = "BEST"
        bestscoreTextLabel.font = bestscoreTextLabel.font.withSize(20)
        bestscoreTextLabel.isHidden = true
        
        view.addSubview(bestscoreTextLabel)
        view.addConstraints([
            getConstraint(item: bestscoreTextLabel!, .top, toItem: view, .top, multiplier: 1, constant: 100),
            getConstraint(item: bestscoreTextLabel!, .bottom, toItem: scoreLabel, .centerY),
            getConstraint(item: bestscoreTextLabel!, .left, toItem: view, .centerX),
            getConstraint(item: bestscoreTextLabel!, .right, toItem: view),
        ])
    }
}

extension Scoreboard {
    private func getScoreConstraints(toCenter: Bool) -> [NSLayoutConstraint] {
        let view:UIView = getView()
        return
            toCenter ?
                [getConstraint(item: scoreLabel!, .top, toItem: view, .top, multiplier: 1, constant: 100),
                    getConstraint(item: scoreLabel!, .left, toItem: view, .left),
                    getConstraint(item: scoreLabel!, .right, toItem: view, .right),
                    getConstraint(item: scoreLabel!, .height, toItem: nil, .notAnAttribute, multiplier: 1, constant: 150)]
                :
                [getConstraint(item: scoreLabel!, .top, toItem: view, .top, multiplier: 1, constant: 100),
                    getConstraint(item: scoreLabel!, .left, toItem: view),
                    getConstraint(item: scoreLabel!, .right, toItem: view, .right, multiplier: 0.5, constant: 0),
                    getConstraint(item: scoreLabel!, .height, toItem: nil, .notAnAttribute, multiplier: 1, constant: 150)]
    }
}
