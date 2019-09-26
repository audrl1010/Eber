//
//  VehicleListViewSection.swift
//  Eber
//
//  Created by myung gi son on 25/09/2019.
//

import RxDataSources

struct VehicleListViewSection {
  var items: [Item]
}

extension VehicleListViewSection: SectionModelType {
  init(original: VehicleListViewSection, items: [Item]) {
    self = original
    self.items = items
  }
}

extension VehicleListViewSection {
  struct Item {
    let cellReactor: VehicleCellReactor
  }
}
