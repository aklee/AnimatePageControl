# AnimatePageControl
自定义的弹性小球pageControl。

<br /><br />

####UI<br />
![image](./dot.gif)<br /><br />

####Usage<br />
- Ease to start

```swift

in ViewController:
    let page = DotPageControl(frame: CGRect(x: 10, y: 400, width: self.view.frame.size.width - 20, height: 150), scrollView: self.collectionView) 
    page.numberOfPages = 5
    page.currentPageIndicatorTintColor = .green
    page.dotWidth = 15
    view.addSubview(page)
    
    

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating {
      pageControl.updateCurrentPageDisplay()
    }
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    pageControl.updateCurrentPageDisplay()
    pageControl.dotAnimate()
    
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    pageControl.lastOffset = scrollView.contentOffset.x

    
  }
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    pageControl.lastOffset = scrollView.contentOffset.x
  }
  }    
    
    
    
    ```

