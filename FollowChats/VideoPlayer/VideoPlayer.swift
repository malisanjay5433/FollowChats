//
//  VideoPlayer.swift
//  FollowChats
//
//  Created by Sanjay Mali on 16/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
extension Notification.Name {
    static let playerDidChangeFullscreenMode = Notification.Name("playerDidEnterFullscreenMode")
}
class VideoPlayer: UIView {
    let playerController = AVPlayerViewController()
    var isPlaying: Bool = false
    var videoAsset: AVURLAsset?
    var displayLink: CADisplayLink?
    var previewImageView: UIImageView!
    var customControlsContentView: UIView!
    var playIcon: UIImageView!
    var isFullscreen = false
    
    var videoUrl: URL? {
        didSet {
            prepareVideoPlayer()
        }
    }
    var previewImageUrl: URL? {
        didSet {
            previewImageView.isHidden = false
        }
    }
    var shouldAutoplay: Bool = false {
        didSet {
            if shouldAutoplay {
                runTimer()
            } else {
                removeTimer()
            }
        }
    }
    
    var shouldAutoRepeat: Bool = false {
        didSet {
            if oldValue == shouldAutoRepeat { return }
            if shouldAutoRepeat {
                NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            } else {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    }
    
    var showsCustomControls: Bool = true {
        didSet {
            playerController.showsPlaybackControls = !showsCustomControls
            customControlsContentView.isHidden = !showsCustomControls
        }
    }
    var minimumVisibilityValueForStartAutoPlay: CGFloat = 0.9
    var isMuted: Bool = false {
        didSet {
            playerController.player?.isMuted = isMuted
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        removePlayerObservers()
        displayLink?.invalidate()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            pause()
            removeTimer()
        } else {
            if shouldAutoplay {
                runTimer()
            }
        }
    }
    //MARK: View configuration
    private func setUpView() {
        self.backgroundColor = .red
        addVideoPlayerView()
        configurateControls()
    }
    
    fileprivate func addVideoPlayerView() {
        playerController.view.frame = self.bounds
        playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerController.showsPlaybackControls = false
        self.insertSubview(playerController.view, at: 0)
    }
    
    fileprivate func configurateControls() {
        customControlsContentView = UIView(frame: self.bounds)
        customControlsContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customControlsContentView.backgroundColor = .red
        
        previewImageView = UIImageView(frame: self.bounds)
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        previewImageView.clipsToBounds = true
        
        playIcon = UIImageView(image: UIImage(named:"play"))
        playIcon.isUserInteractionEnabled = true
        playIcon.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        playIcon.center = previewImageView!.center
        playIcon.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        addSubview(previewImageView!)
        customControlsContentView?.addSubview(playIcon)
        addSubview(customControlsContentView!)
        let playAction = UITapGestureRecognizer(target: self, action: #selector(didTapPlay))
        playIcon.addGestureRecognizer(playAction)
        let pauseAction = UITapGestureRecognizer(target: self, action: #selector(didTapPause))
        customControlsContentView.addGestureRecognizer(pauseAction)
    }
    fileprivate func runTimer() {
        if displayLink != nil {
            displayLink?.isPaused = false
            return
        }
        displayLink = CADisplayLink(target: self, selector: #selector(timerAction))
        if #available(iOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = 5
        } else {
            displayLink?.frameInterval = 5
        }
        displayLink?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    fileprivate func removeTimer() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc func timerAction() {
        guard videoUrl != nil else {
            return
        }
        if isVisible() {
            play()
        } else {
            pause()
        }
    }
    
    fileprivate func isVisible() -> Bool {
        if self.window == nil {
            return false
        }
        let displayBounds = UIScreen.main.bounds
        let selfFrame = self.convert(self.bounds, to: UIApplication.shared.keyWindow)
        let intersection = displayBounds.intersection(selfFrame)
        let visibility = (intersection.width * intersection.height) / (frame.width * frame.height)
        return visibility >= minimumVisibilityValueForStartAutoPlay
    }
    
    fileprivate func prepareVideoPlayer() {
        guard let url = videoUrl else {
            videoAsset = nil
            playerController.player?.removeObserver(self, forKeyPath: "rate")
            playerController.player = nil
            return
        }
        videoAsset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: videoAsset!)
        let player = AVPlayer(playerItem: item)
        playerController.player = player
        addPlayerObservers()
    }
    
    @objc func didTapPlay() {
        displayLink?.isPaused = false
        playIcon.image = UIImage(named:"pause")
        play()
    }
    
    @objc func didTapPause() {
        displayLink?.isPaused = true
        playIcon.image = UIImage(named:"play")
        pause()
    }
    
    fileprivate func play() {
        if isPlaying { return }
        isPlaying = true
        videoAsset?.loadValuesAsynchronously(forKeys: ["playable", "tracks", "duration"], completionHandler: {
            DispatchQueue.main.async {
                if self.isPlaying == true {
                    self.playIcon.isHidden = true
                    self.previewImageView.isHidden = true
                    self.playerController.player?.play()
                }
            }
        })
    }
    
    fileprivate func pause() {
        if isPlaying {
            isPlaying = false
            playIcon.isHidden = false
            playerController.player?.pause()
        }
    }
    
    @objc func itemDidFinishPlaying() {
        if isPlaying {
            playerController.player?.seek(to: kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            playerController.player?.play()
        }
    }
    private func addPlayerObservers() {
        playerController.player?.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
        playerController.contentOverlayView?.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }
    
    private func removePlayerObservers() {
        playerController.player?.removeObserver(self, forKeyPath: "rate")
        playerController.contentOverlayView?.removeObserver(self, forKeyPath: "bounds")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath! {
        case "rate":
            self.previewImageView.isHidden = true
        case "bounds":
            let fullscreen = playerController.contentOverlayView?.bounds == UIScreen.main.bounds
            if isFullscreen != fullscreen {
                isFullscreen = fullscreen
                NotificationCenter.default.post(name: .playerDidChangeFullscreenMode, object: isFullscreen)
            }
        default:
            break
        }
    }
    
}

