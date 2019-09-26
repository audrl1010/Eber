//
//  VehicleListViewController.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import UIKit
import RxSwift
import Pure
import ReusableKit
import ReactorKit
import UICollectionViewFlexLayout
import RxDataSources

final class VehicleListViewController: BaseViewController, View, FactoryModule {
  
  typealias Reactor = VehicleListViewReactor
  typealias Section = VehicleListViewSection
  
  struct Payload {
    let reactor: Reactor
  }
  
  struct Reusable {
    static let vehicleCell = ReusableCell<VehicleCell>()
    static let sectionItemBackgroundView = ReusableView<VehicleListViewSectionItemBackgroundView>()
    static let sectionBackgroundView = ReusableView<CollectionBackgroundView>()
  }
  let activityIndicatorView = UIActivityIndicatorView(style: .gray)
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlexLayout()
  ).then {
    $0.alwaysBounceVertical = true
    $0.backgroundColor = .clear
    $0.register(Reusable.vehicleCell)
    $0.register(Reusable.sectionBackgroundView, kind: UICollectionElementKindSectionBackground)
    $0.register(Reusable.sectionItemBackgroundView, kind: UICollectionElementKindItemBackground)
  }
  
  let toolbarView = ToolbarView()
  
  fileprivate lazy var dataSource = self.createDataSource()
  
  required init(dependency: Void, payload: Payload) {
    defer { self.reactor = payload.reactor }
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<Section> {
    return .init(
      configureCell: { dataSource, collectionView, indexPath, sectionItem in
        let cell = collectionView.dequeue(Reusable.vehicleCell, for: indexPath)
        cell.reactor = sectionItem.cellReactor
        return cell
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch kind {
        case UICollectionElementKindSectionBackground:
          let view = collectionView.dequeue(Reusable.sectionBackgroundView, kind: kind, for: indexPath)
          return view
          
        case UICollectionElementKindItemBackground:
          let view = collectionView.dequeue(Reusable.sectionItemBackgroundView, kind: kind, for: indexPath)
          return view
          
        default:
          return collectionView.emptyView(for: indexPath, kind: kind)
        }
      }
    )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.toolbarView)
    self.view.addSubview(self.activityIndicatorView)
  }
  
  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }
    self.toolbarView.snp.makeConstraints { make in
      make.top.equalTo(self.collectionView.snp.bottom)
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
    self.activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
  
  func bind(reactor: Reactor) {
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.sections }
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .bind(to: self.activityIndicatorView.rx.isAnimating)
      .disposed(by: self.disposeBag)
    
    self.collectionView.rx.setDelegate(self)
      .disposed(by: self.disposeBag)
  }
}

extension VehicleListViewController: UICollectionViewDelegateFlexLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    paddingForSectionAt section: Int
  ) -> UIEdgeInsets {
    let topBottom = 16.f
    return UIEdgeInsets(top: topBottom, left: 0, bottom: topBottom, right: 0)
  }
  
  // item spacing
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    verticalSpacingBetweenItemAt indexPath: IndexPath,
    and nextIndexPath: IndexPath
  ) -> CGFloat {
    return 8.f
  }
  
  // item margin
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    marginForItemAt indexPath: IndexPath
  ) -> UIEdgeInsets {
    let leftRight = 8.f
    return UIEdgeInsets(top: 0, left: leftRight, bottom: 0.f, right: leftRight)
  }
  
  // item padding
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    paddingForItemAt indexPath: IndexPath
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 16.f, left: 16.f, bottom: 16.f, right: 16.f)
  }
  
  // item size
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let maxWidth = collectionViewLayout.maximumWidth(forItemAt: indexPath)
    let sectionItem = self.dataSource[indexPath]
    return Reusable.vehicleCell.class.size(width: maxWidth, reactor: sectionItem.cellReactor)
  }
}
