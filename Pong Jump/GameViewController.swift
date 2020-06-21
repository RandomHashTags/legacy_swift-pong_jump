//
//  GameViewController.swift
//  Pong Jump
//
//  Created by Evan Anderson on 5/27/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import AVKit

var GAME_CONTROLLER:GameViewController!
var SCREEN_BOUNDS:CGRect = UIScreen.main.bounds
var SCREEN_WIDTH:CGFloat = SCREEN_BOUNDS.width, SCREEN_HEIGHT:CGFloat = SCREEN_BOUNDS.height

class GameViewController: UIViewController, SCNPhysicsContactDelegate, SCNSceneRendererDelegate, GestureRecognizers, Randomable, Mathable, ConstraintsAPI {
        
    internal var scene:SCNScene!
    
    private var cameraNode:SCNNode!
    internal var pongBall:PongBall!
    
    private var lastPongBoxPosition:SCNVector3!
    internal var pongBoxConnectors:[PongBoxConnector]!
        
    private var MAX_X_POSITION:Float = 200
    private var MINIMUM_ALLOWED_Y:Float = -1
    private var ADDED_PONG_PLATFORM_Y:Float!
    
    private var selectorView:UIView!
    private var selectorViewLeftConstraint:NSLayoutConstraint!
    
    private var reviveView:UIView!
    
    private var activeTimers:[Timer]!, activeAnimations:[UIViewPropertyAnimation]!
                    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GAME_CONTROLLER = self
        
        load {
            self.start()
        }
    }
    
    private func load(_ completion: @escaping () -> Void) {
        setupScene()
        
        let loadingView:UIView = UIView()
        loadingView.layer.zPosition = 10
        loadingView.backgroundColor = UIColor.black
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        view.addConstraints([
            getConstraint(item: loadingView, .top, toItem: view),
            getConstraint(item: loadingView, .bottom, toItem: view),
            getConstraint(item: loadingView, .left, toItem: view),
            getConstraint(item: loadingView, .right, toItem: view),
        ])
        
        advertisements.tryLoading()
        pongBoxConnectors = [PongBoxConnector]()
        activeTimers = [Timer]()
        activeAnimations = [UIViewPropertyAnimation]()
        let node:SCNNode = SCNNode()
        scene.rootNode.addChildNode(node)
        node.runAction(SCNActions.getPongBallSound(volume: 0.00))
        
        Timer.scheduledTimer(withTimeInterval: 3.00, repeats: false) { (_) in
            node.delete()
            UIView.animate(withDuration: 1.00, animations: {
                loadingView.alpha = 0.00
            }) { (did) in
                loadingView.removeFromSuperview()
            }
        }
        
        completion()
    }
    private func start() {
        scoreboard.start()
        addCamera()
        resetScene()
        
        dailyRewards.check()
        homescreen()
    }
    
    private func startTimer(duration: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
        let timer:Timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: repeats, block: block)
        activeTimers.append(timer)
    }
    private func stopTimers() {
        for timer in activeTimers {
            timer.invalidate()
        }
        activeTimers.removeAll()
    }
    private func startAnimation(duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping () -> Void, undo: ((CGFloat) -> Void)?) {
        let animation:UIViewPropertyAnimation = UIViewPropertyAnimation(duration: duration, curve: .linear, animations: animations, undo: undo)
        animation.addCompletion { (position) in
            completion()
            self.activeAnimations = self.activeAnimations.filter { $0 != animation }
        }
        animation.startAnimation()
        activeAnimations.append(animation)
    }
    private func stopAnimations() {
        for animation in activeAnimations {
            animation.undoAnimation()
        }
        activeAnimations.removeAll()
    }
    
    private func homescreen() {
        selectorView = ViewSelector(frame: CGRect.zero)
        view.addSubview(selectorView)
        
        selectorViewLeftConstraint = getConstraint(item: selectorView!, .left, toItem: view, .left, multiplier: 1, constant: -75)
        view.addConstraints([
            getConstraint(item: selectorView!, .top, toItem: view, .top, multiplier: 1, constant: 200),
            selectorViewLeftConstraint,
            getConstraint(item: selectorView!, .width, toItem: nil, .notAnAttribute, multiplier: 1, constant: 40),
            getConstraint(item: selectorView!, .bottom, toItem: view, .bottom, multiplier: 1, constant: -200)
        ])
        self.view.layoutIfNeeded()
        selectorViewLeftConstraint.animate(duration: 0.50, toConstant: 15, viewHolder: view)
    }
    private func dismissHomescreen(completion: @escaping () -> Void) {
        selectorViewLeftConstraint.animate(duration: 0.50, toConstant: -75, viewHolder: view) {
            self.selectorView.removeFromSuperview()
            self.selectorViewLeftConstraint = nil
            completion()
        }
    }
    
    private func setupScene() {
        scene = SCNScene()
        scene.physicsWorld.contactDelegate = self
        scene.physicsWorld.gravity = SCNVector3(0, -100.00, 0)
        scene.background.contents = UIColor.clear
        scene.fogColor = UIColor.black
        scene.fogStartDistance = 65
        scene.fogEndDistance = 100
        scene.fogDensityExponent = 0.55
        
        let scnView:SCNView = self.view as! SCNView
        scnView.delegate = self
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.showsStatistics = false
        scnView.backgroundColor = UIColor.black
        
        scnView.addGestureRecognizer(getSwipeGesture(target: self, action: #selector(handleSwipe(_:)), direction: .left))
        scnView.addGestureRecognizer(getSwipeGesture(target: self, action: #selector(handleSwipe(_:)), direction: .right))
        scnView.addGestureRecognizer(getTapGesture(target: self, action: #selector(doubleTapHandler(_:)), numberOfTapsRequired: 2, numberOfTouchesRequired: 1))
    }
    
    @objc
    private func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        if gameSettings.isGameStatus(.BOUNCING_STARTED) {
            let key:String = "swipeMovement"
            if pongBall.action(forKey: key) == nil {
                let x:CGFloat = 5*(swipe.direction == .left ? -1 : 1)
                let pongBallX:Float = pongBall.position.x+Float(x)
                if pongBallX >= -MAX_X_POSITION && pongBallX <= MAX_X_POSITION {
                    let action:SCNAction = SCNAction.moveBy(x: x, y: 0, z: 0, duration: 0.10)
                    pongBall.runAction(action, forKey: key)
                    cameraNode.runAction(action, forKey: key)
                } else {
                    print("blocked swipe action!")
                }
            }
        }
    }
    
    @objc
    private func doubleTapHandler(_ tap: UITapGestureRecognizer) {
        if !gameSettings.isGameStatus(.STARTED_GAME) {
            dismissHomescreen {
                self.startGame()
            }
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA:SCNNode = contact.nodeA, nodeB:SCNNode = contact.nodeB
        let AisBall:Bool = nodeA.isEqual(pongBall), BisBall:Bool = nodeB.isEqual(pongBall)
        tryStartingBouncingState()
        if AisBall || BisBall {
            //let ball:SCNNode = AisBall ? nodeA : nodeB
            let object:SCNNode = AisBall ? nodeB : nodeA
            let objectPosition:SCNVector3 = object.position
            
            if object is Paddle {
                let paddle:Paddle = object as! Paddle
                shop.addCurrency(type: paddle.getType(), amount: 1)
                playAnimation(targetNode: object, particle: .PADDLE_OBTAIN)
                object.delete()
                return
            } else if object is PongPlatform {
                MINIMUM_ALLOWED_Y = objectPosition.y-1
                let box:PongBox = object as! PongBox
                let isSpring:Bool = box.getType() == .SPRING
                box.dismiss()
                (isSpring ? Feedback.PONG_SPRING : Feedback.PONG_BOX).impactOccurred()
                pongBall.physicsBody!.clearAllForces()
                pongBall.removeAction(forKey: "swipeMovement")
                cameraNode.removeAction(forKey: "swipeMovement")
                correctPositions(objectPosition: objectPosition)
                pongBall.physicsBody!.applyForce(SCNVector3(0, isSpring ? 100.00 : 50.00, 0), asImpulse: true)
                if isSpring {
                    cameraNode.runAction(SCNActions.CAMERA_MOVE_Y)
                }
            } else {
                return
            }
            
            pongBall.runAction(SCNActions.PONG_BALL_BOUNCE_AUDIO)
            pongBall.update()
            scoreboard.addScore()
            addPongPlatform(animated: true)
        }
    }
    private func correctPositions(objectPosition: SCNVector3) {
        let x:Float = objectPosition.x
        pongBall.position.x = x
        pongBall.position.y = objectPosition.y+1.5
        pongBall.position.z = objectPosition.z
        
        cameraNode.position.x = x
        cameraNode.position.z = pongBall.position.z+50
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if gameSettings.isGameStatus(.BOUNCING_STARTED) && pongBall != nil && pongBall.position.y <= MINIMUM_ALLOWED_Y {
            triggerEndGame()
        }
    }
    
    internal func setPaused(paused: Bool) {
        scene.isPaused = paused
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }
    
    private func playAnimation(targetNode: SCNNode, particle: CustomParticleSystem) {
        let node:SCNNode = SCNNode()
        node.name = "pongAnimation"
        scene.rootNode.addChildNode(node)
        
        node.position = targetNode.position
        let system:SCNParticleSystem = ParticleSystems.get(system: particle, geometry: targetNode.geometry)
        node.addParticleSystem(system)
    }
}

extension GameViewController {
    private func resetScene() {
        PongBox.totalBoxes = 0
        removeNodes()
        
        repositionCamera()
        gameSettings.resetGameStatus()
        lastPongBoxPosition = nil
        ADDED_PONG_PLATFORM_Y = 0
        MINIMUM_ALLOWED_Y = -1
        for _ in 1...5 {
            addPongPlatform(animated: false)
        }
        addPongBall()
        lastPongBoxPosition = lastPongBoxPosition.with(y: lastPongBoxPosition.y-10)
    }
    private func removeNodes() {
        for node in scene.rootNode.childNodes {
            if node is PongBox || node is Paddle || node.name != nil && node.name!.elementsEqual("pongAnimation") {
                node.delete()
            }
        }
        for node in pongBoxConnectors {
            node.delete()
        }
        pongBoxConnectors.removeAll()
    }
}

extension GameViewController {
    private func startGame() {
        gameSettings.setGameStatus(.STARTED_GAME, true)
        scoreboard.reset()
        pongBall.physicsBody!.isAffectedByGravity = true
    }
    private func tryStartingBouncingState() {
        if !gameSettings.isGameStatus(.BOUNCING_STARTED) {
            gameSettings.setGameStatus(.BOUNCING_STARTED, true)
            startMovement()
        }
    }
    private func triggerEndGame() {
        gameSettings.setGameStatus(.BOUNCING_STARTED, false)
        playAnimation(targetNode: pongBall, particle: .PONG_BALL_END_GAME)
        stopMovement()
        
        let allowedSecondChance:Bool = scoreboard.getScore() >= 10 && shop.isBuyable(purchasable: .SECOND_CHANCE, currency: .BOX)
        let time:TimeInterval = allowedSecondChance ? 5.00 : 3.00
        
        DispatchQueue.main.async {
            self.flashScreen(color: UIColor.white, fromAlpha: 0.25, toAlpha: 0.00, withDuration: 0.50)
            self.view.shakeScreen(from: CGPoint(x: -2, y: -2), to: CGPoint(x: 2, y: 2), repeatCount: 4, duration: 0.06)
            if allowedSecondChance {
                self.addSecondChanceView {
                    self.flashScreen(color: UIColor.black, fromAlpha: 0.00, toAlpha: 1.00, withDuration: 1.50)
                    Timer.scheduledTimer(withTimeInterval: 1.45, repeats: false) { (_) in
                        self.reviveView.removeFromSuperview()
                    }
                }
            } else {
                self.flashScreen(color: UIColor.black, fromAlpha: 0.00, toAlpha: 1.00, withDuration: 3.00)
            }
        }
        
        startTimer(duration: time-0.05, repeats: false) { (_) in
            self.endGame()
        }
    }
    private func addSecondChanceView(_ expiration: @escaping () -> Void) {
        reviveView = UIView()
        reviveView.translatesAutoresizingMaskIntoConstraints = false
        reviveView.backgroundColor = .green
        reviveView.layer.cornerRadius = 100
        reviveView.alpha = 0.00
        let tapGesture:UITapGestureRecognizer = getTapGesture(target: self, action: #selector(activateSecondChance(_:)), numberOfTapsRequired: 1, numberOfTouchesRequired: 1)
        reviveView.addGestureRecognizer(tapGesture)
        view.addSubview(reviveView)
        
        let widthConstraint:NSLayoutConstraint = getConstraint(item: reviveView!, .width, toItem: nil, .notAnAttribute, multiplier: 1, constant: 200)
        let heightConstraint:NSLayoutConstraint = getConstraint(item: reviveView!, .height, toItem: nil, .notAnAttribute, multiplier: 1, constant: 200)
        view.addConstraints([
            getConstraint(item: reviveView!, .centerX, toItem: view),
            getConstraint(item: reviveView!, .centerY, toItem: view),
            widthConstraint,
            heightConstraint
        ])
        
        startAnimation(duration: 0.50, animations: {
            self.reviveView.alpha = 0.99
        }, completion: {
            self.reviveView.alpha = 1.00
            self.heartPumpSecondChanceView(widthConstraint: widthConstraint, heightConstraint: heightConstraint, completion: {
                expiration()
            })
        }, undo: nil)
    }
    
    private func heartPumpSecondChanceView(widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint, completion: @escaping () -> Void) {
        let ring:UIRing = UIRing(frame: CGRect(x: 0, y: 0, width: reviveView.frame.width, height: reviveView.frame.height))
        reviveView.addSubview(ring)
        ring.animateCircle(duration: 3.00, fromValue: 1.00, toValue: 0.00, completion: {
            ring.getCircleLayer().removeFromSuperlayer()
            if !gameSettings.hasActiveAttribute(.SECOND_CHANCE) {
                completion()
            }
        })
    }
    
    @objc
    private func activateSecondChance(_ gesture: UITapGestureRecognizer) {
        if reviveView.alpha == 1.00 {
            stopTimers()
            stopAnimations()
            shop.purchase(purchasable: .SECOND_CHANCE, currency: .BOX)
            reviveView.removeFromSuperview()
            repositionCamera()
            addPongBall()
            Timer.scheduledTimer(withTimeInterval: 2.00, repeats: false) { (_) in
                self.pongBall.physicsBody!.isAffectedByGravity = true
            }
        }
    }
    
    private func endGame() {
        scoreboard.ended()
        DispatchQueue.main.sync {
            self.resetScene()
            self.homescreen()
        }
        advertisements.showRewardedAd(type: .TEST, onPresented: nil, onDismissed: nil, onFailedToShow: nil) { (reward, amount) in
        }
    }
    private func flashScreen(color: UIColor, fromAlpha: CGFloat, toAlpha: CGFloat, withDuration: TimeInterval) {
        let flash:SCNView = SCNView()
        flash.translatesAutoresizingMaskIntoConstraints = false
        flash.alpha = fromAlpha
        flash.backgroundColor = color
        view.addSubview(flash)
        view.addConstraints([
            getConstraint(item: flash, .top, toItem: view),
            getConstraint(item: flash, .bottom, toItem: view),
            getConstraint(item: flash, .left, toItem: view),
            getConstraint(item: flash, .right, toItem: view),
        ])
        
        startAnimation(duration: withDuration, animations: {
            flash.alpha = toAlpha
        }, completion: {
            flash.removeFromSuperview()
        }, undo: { (fractionComplete) in
            UIView.animate(withDuration: (withDuration-(withDuration*Double(fractionComplete)))/2, animations: {
                flash.alpha = fromAlpha
            }, completion: { (did) in
                flash.removeFromSuperview()
            })
        })
    }
}

extension GameViewController {
    private func getFirstPongBox() -> SCNNode! {
        return scene.rootNode.childNode(withName: "pongBox" + (PongBox.totalBoxes-5).description, recursively: false)
    }
    private func repositionCamera() {
        if PongBox.totalBoxes == 0 {
            cameraNode.position = SCNVector3(0, 20, ZPositions.CAMERA)
        } else {
            let firstBox:SCNNode! = getFirstPongBox()
            let position:SCNVector3 = firstBox.position
            cameraNode.position = SCNVector3(position.x, position.y+20, position.z+50)
        }
        //setCameraFlatMode()
    }
    private func setCameraFlatMode() {
        cameraNode.position = SCNVector3(-50, 10, ZPositions.PONG_BALL)
        cameraNode.eulerAngles = SCNVector3(0, toRadians(floatDegree: -90), 0)
    }
    private func startMovement() {
        let action:SCNAction = SCNActions.MOVE_Z
        cameraNode.runAction(action)
        pongBall.runAction(action)
        pongBall.runAction(SCNActions.PONG_BALL_ROTATION_VERTICAL)
    }
    private func stopMovement() {
        cameraNode.removeAllActions()
        pongBall.removeAllActions()
        pongBall.delete()
    }
    private func getRandomPongBoxX() -> Float {
        switch getRandomNumber(min: 0, max: 10) {
        case 0: return 25
        case 1: return 20
        case 2: return 15
        case 3: return 10
        case 4: return 5
        case 5: return 0
        case 6: return -5
        case 7: return -10
        case 8: return -15
        case 9: return -20
        case 10: return -25
        default: return 0
        }
    }
}

extension GameViewController {
    private func addCamera() {
        cameraNode = SCNNode()
        
        let camera:SCNCamera = SCNCamera()
        camera.zNear = 10
        camera.zFar = 200
        cameraNode.camera = camera
        cameraNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    private func addPongBall() {
        pongBall = PongBall(texture: gameSettings.getPongBallTexture())
        scene.rootNode.addChildNode(pongBall)
        
        let firstBox:SCNNode! = getFirstPongBox()
        let position:SCNVector3 = firstBox != nil ? firstBox.position : SCNVector3(0, 0, ZPositions.PONG_BALL)
        pongBall.position = SCNVector3(position.x, position.y+YPositions.PONG_BALL, position.z)
    }
}

extension GameViewController {
    private func getRandomPongPlatformX() -> Float {
        guard let x = scene.rootNode.childNode(withName: "pongBox" + (PongBox.totalBoxes-1).description, recursively: false)?.position.x else { return getRandomPongBoxX() }
        for _ in 1...100 {
            let random:Float = getRandomPongBoxX(), targetX:Float = x+random
            if targetX > -MAX_X_POSITION && targetX < MAX_X_POSITION {
                return random
            }
        }
        return 0
    }
    private func addPongPlatform(animated: Bool) {
        let lastPlatformIsSpring:Bool = gameSettings.isGameStatus(.LAST_PONG_PLATFORM_IS_SPRING)
        
        let hasLastPongBox:Bool = lastPongBoxPosition != nil
        let lastPosition:SCNVector3! = hasLastPongBox ? lastPongBoxPosition : nil
        let lastZ:Float = hasLastPongBox ? (lastPlatformIsSpring ? -10 : 0) + lastPosition.z : 0
        let z:Float = lastZ-(lastPlatformIsSpring ? 5 : 10)
        let x:Float = z == -10 ? 0 : getRandomPongPlatformX()
        let lastX:Float = hasLastPongBox ? lastPosition.x : 0
        
        let addedY:Float = lastPlatformIsSpring ? 50 : 0
        ADDED_PONG_PLATFORM_Y += addedY
        let y:Float = YPositions.PONG_PLATFORM+(animated ? 0 : 10)+ADDED_PONG_PLATFORM_Y
        
        let newPosition:SCNVector3 = SCNVector3(lastX+x, y, z)
        let isSpring:Bool = getRandomNumber(min: 1, max: 10) == 1
        let platform:PongPlatform = PongBox(type: isSpring ? .SPRING : .NORMAL)
        scene.rootNode.addChildNode(platform)
        platform.position = newPosition
        if animated {
            platform.runAction(SCNActions.PONG_PLATFORM_MOVE_Y)
        }
        if hasLastPongBox {
            addPongBoxConnector(animated: animated, lastPosition: lastPosition, newPosition: newPosition)
        }
        if getRandomNumber(min: 1, max: 3) == 1 {
            addPaddle(boxPosition: newPosition, animated: animated)
        }
        lastPongBoxPosition = newPosition
        gameSettings.setGameStatus(.LAST_PONG_PLATFORM_IS_SPRING, isSpring)
    }
    
    private func addPongBoxConnector(animated: Bool, lastPosition: SCNVector3, newPosition: SCNVector3) {
        let connector:PongBoxConnector = PongBoxConnector(startsAt: lastPosition, endsAt: newPosition)
        let outNode:SCNNode = connector.getOutNode()
        scene.rootNode.addChildNode(outNode)
        
        let zDistance:Float = connector.getRunDistanceZ()
        outNode.position = lastPosition.add(x: 0, y: 0, z: -(zDistance/2))
        
        let runNode:SCNNode? = connector.getRunNode()
        var position:SCNVector3 = runNode == nil ? outNode.position : lastPosition, runX:Float!
        if runNode != nil {
            scene.rootNode.addChildNode(runNode!)
            
            let runDistanceX:Float = connector.getRunDistanceX()
            let isPositive:Bool = connector.didMovePositively()
            runX = runDistanceX/2*(isPositive ? 1 : -1)
            position = position.add(x: runX, y: 0, z: -(zDistance))
            runNode!.position = position
        }
        
        let upNode:SCNNode? = connector.getUpNode()
        if upNode != nil {
            scene.rootNode.addChildNode(upNode!)
            upNode!.position = position.add(x: runX == nil ? 0 : runX, y: (newPosition.y-lastPosition.y)/2, z: runX == nil ? -7 : 0)
        }
        
        if animated {
            let action:SCNAction = SCNActions.PONG_PLATFORM_MOVE_Y
            outNode.runAction(action)
            runNode?.runAction(action)
            upNode?.runAction(action)
        }
        pongBoxConnectors.append(connector)
    }
    private func addPaddle(boxPosition: SCNVector3, animated: Bool) {
        let paddle:Paddle = Paddle()
        scene.rootNode.addChildNode(paddle)
        paddle.position = boxPosition.add(x: 0, y: 2, z: 0)
        if animated {
            paddle.runAction(SCNActions.PONG_PLATFORM_MOVE_Y)
        }
    }
}
