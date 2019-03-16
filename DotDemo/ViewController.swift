//
//  ViewController.swift
//  DotDemo
//
//  Created by ak on 2019/3/16.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let collect = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    collect.isPagingEnabled = true
    collect.backgroundColor = .white
    collect.delegate = self
    collect.dataSource = self
    collect.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    return collect
  }()
  
  lazy var pageControl: DotPageControl = {
    let page = DotPageControl(frame: CGRect(x: 10, y: 400, width: self.view.frame.size.width - 20, height: 150), scrollView: self.collectionView)
    page.backgroundColor = .gray
    page.numberOfPages = 5
    page.currentPageIndicatorTintColor = .yellow
    page.dotWidth = 20
    return page
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    view.backgroundColor = .white
    
    view.addSubview(pageControl)
    
  }
}
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageControl.currentPage = scrollView.contentOffset.x / self.view.width
//    pageControl.updateCurrentPageDisplay()
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//    pageControl.dotAnimate()
    pageControl.currentPage = scrollView.contentOffset.x / self.view.width
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    pageControl.lastOffset = scrollView.contentOffset.x
    pageControl.currentPage = scrollView.contentOffset.x / self.view.width
    
  }
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    pageControl.lastOffset = scrollView.contentOffset.x
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return view.frame.size
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pageControl.numberOfPages
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = indexPath.row % 2 == 0 ? .brown : .white
    return cell
  }
  

}

