import UIKit

protocol SegmentedProgressBarDelegate: AnyObject {
    func segmentedProgressBarChangedIndex(index: Int)
    func segmentedProgressBarFinished()
}

class SegmentedProgressBar: UIView {
    
    weak var delegate: SegmentedProgressBarDelegate?
    
    var topColor = UIColor.white {
        didSet {
            self.updateColors()
        }
    }
    
    var bottomColor = UIColor.gray.withAlphaComponent(0.25) {
        didSet {
            self.updateColors()
        }
    }
    
    var padding: CGFloat = 4.0
    
    var isPaused: Bool = false {
        didSet {
            if isPaused {
                pauseAnimation()
            } else {
                resumeAnimation()
            }
        }
    }
    
    private var segments = [Segment]()
    private let duration: TimeInterval
    private var hasDoneLayout = false
    private var currentAnimationIndex = 0
    private var isAnimating = false
    private var animationTimer: Timer?
    
    init(numberOfSegments: Int, duration: TimeInterval = 5.0) {
        self.duration = duration
        super.init(frame: CGRect.zero)
        
        for _ in 0..<numberOfSegments {
            let segment = Segment()
            addSubview(segment.bottomSegmentView)
            addSubview(segment.topSegmentView)
            segments.append(segment)
        }
        self.updateColors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if hasDoneLayout {
            return
        }
        let width = (frame.width - (padding * CGFloat(segments.count - 1))) / CGFloat(segments.count)
        for (index, segment) in segments.enumerated() {
            let segFrame = CGRect(x: CGFloat(index) * (width + padding), y: 0, width: width, height: frame.height)
            segment.bottomSegmentView.frame = segFrame
            segment.topSegmentView.frame = segFrame
            segment.topSegmentView.frame.size.width = 0
            
            let cr = frame.height / 2
            segment.bottomSegmentView.layer.cornerRadius = cr
            segment.topSegmentView.layer.cornerRadius = cr
        }
        hasDoneLayout = true
    }
    
    func startAnimation() {
        layoutSubviews()
        stopAnimation()
        animate()
    }
    
    private func animate(animationIndex: Int = 0) {
        guard animationIndex < segments.count else {
            return
        }
        let nextSegment = segments[animationIndex]
        currentAnimationIndex = animationIndex
        self.isPaused = false
        
        if isAnimating {
            stopAnimation()
        }
        
        isAnimating = true
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            
            let progress = nextSegment.topSegmentView.frame.width / nextSegment.bottomSegmentView.frame.width
            if progress >= 1.0 {
                timer.invalidate()
                self.isAnimating = false
                self.next()
            } else {
                nextSegment.topSegmentView.frame.size.width += nextSegment.bottomSegmentView.frame.width / (self.duration * 100)
            }
        }
    }
    
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        isAnimating = false
    }
    
    private func pauseAnimation() {
        animationTimer?.invalidate()
    }
    
    private func resumeAnimation() {
        guard isPaused else { return }
        animate(animationIndex: currentAnimationIndex)
    }
    
    private func updateColors() {
        for segment in segments {
            segment.topSegmentView.backgroundColor = topColor
            segment.bottomSegmentView.backgroundColor = bottomColor
        }
    }
    
    private func next() {
        let newIndex = self.currentAnimationIndex + 1
        if newIndex < self.segments.count {
            self.animate(animationIndex: newIndex)
            self.delegate?.segmentedProgressBarChangedIndex(index: newIndex)
        } else {
            self.finish()
        }
    }
    
    func skip() {
        stopAnimation()
        let currentSegment = segments[currentAnimationIndex]
        currentSegment.topSegmentView.frame.size.width = currentSegment.bottomSegmentView.frame.width
        self.next()
    }
    
    func rewind() {
        stopAnimation()
        let currentSegment = segments[currentAnimationIndex]
        currentSegment.topSegmentView.frame.size.width = 0
        let newIndex = max(currentAnimationIndex - 1, 0)
        let prevSegment = segments[newIndex]
        prevSegment.topSegmentView.frame.size.width = 0
        self.animate(animationIndex: newIndex)
        self.delegate?.segmentedProgressBarChangedIndex(index: newIndex)
    }
    
    func skipToIndex(_ index: Int) {
        guard index >= 0 && index < segments.count else {
            return
        }
        
        stopAnimation()
        
        for i in 0..<index {
            let segment = segments[i]
            segment.topSegmentView.frame.size.width = segment.bottomSegmentView.frame.width
        }
        
        for i in index..<segments.count {
            let segment = segments[i]
            segment.topSegmentView.frame.size.width = 0
        }
        
        currentAnimationIndex = index
        self.animate(animationIndex: index)
        self.delegate?.segmentedProgressBarChangedIndex(index: index)
    }
    
    func finish() {
        stopAnimation()
        for segment in segments {
            segment.topSegmentView.frame.size.width = segment.bottomSegmentView.frame.width
        }
        delegate?.segmentedProgressBarFinished()
    }
}

fileprivate class Segment {
    let bottomSegmentView = UIView()
    let topSegmentView = UIView()
    init() {}
}
