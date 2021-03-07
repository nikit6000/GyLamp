//
//  NKListParamSectionController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit
import Material

class NKListParamSectionController: ListBindingSectionController<ListDiffable>, ListBindingSectionControllerDataSource, ListBindingSectionControllerSelectionDelegate {
    
    private let leftRightInset: CGFloat = 8.0
    public weak var delegate: NKSectionDataChangedDelegate? = nil
    
    private var itemsCount: Int = 0
    
    override init() {
        super.init()
        self.selectionDelegate = self
        self.dataSource = self
        self.inset = UIEdgeInsets(top: 4, left: leftRightInset, bottom: 4, right: leftRightInset)
    }
    
    private func showSelectorAlert(for viewModel: Any, at index: Int) {
        
        let alert = UIAlertController(style: .actionSheet)
        
        switch viewModel {
        case is ListEnumICModel:
            showPicker(in: alert, for: viewModel as! ListEnumICModel, at: index)
        case is NKListRangedModel<Float>:
            showSlider(in: alert, for: viewModel as! NKListRangedModel<Float>, at: index)
        case is NKListRangedModel<UInt16>:
            showIntPicker(in: alert, for: viewModel as! NKListRangedModel<UInt16>, at: index)
        case is NKListRangedModel<UInt32>:
            showIntPicker(in: alert, for: viewModel as! NKListRangedModel<UInt32>, at: index)
        case is NKDiscreteRangedModel<UInt16>:
            showPicker(in: alert, for: viewModel as! NKDiscreteRangedModel<UInt16>, at: index)
        case is NKDiscreteRangedModel<UInt32>:
            showPicker(in: alert, for: viewModel as! NKDiscreteRangedModel<UInt32>, at: index)
        case is NKDiscreteRangedModel<Int16>:
            showPicker(in: alert, for: viewModel as! NKDiscreteRangedModel<Int16>, at: index)
        case is NKStringListModel:
            showStringPicker(in: alert, for: viewModel as! NKStringListModel, at: index)
        default:
            return
        }
        
        self.viewController!.present(alert, animated: true, completion: nil)
    }
    
    private func showPicker<T: BinaryInteger>(in alert: UIAlertController, for model: NKDiscreteRangedModel<T>, at index: Int) {
        
        let pickerViewValues = [model.formattedValues]
        let rawValues = model.values
        let indexOfValue = rawValues.firstIndex(of: model.value) ?? 0
        let initialIndex: PickerViewViewController.Index = (column: 0, row: indexOfValue)
        
        alert.title = model.title
        alert.message = model.description
        
        alert.addPickerView(values: pickerViewValues, initialSelection: initialIndex, action: { [weak self] _, _, indexPath, _ in
            model.value = rawValues[indexPath.row]
            self?.reload()
        })
        
        alert.addAction(title: "NKEnumICSectionController.alert.done".localized, style: .cancel, isEnabled: true, handler: { [weak self] alert in
            
            guard let strongSelf = self else { return }
            strongSelf.delegate?.sectionController?(strongSelf, didUpdate: model.value, at: index)

            NKLog("NKEnumICSectionController", "Model value updated. New value is", model.value)
        })
        
        
    }
    
    private func showPicker(in alert: UIAlertController, for model: ListEnumICModel, at index: Int) {
        
        let pickerViewValues = [model.casesDescriptions]
        let rawValues = model.value.allCasesRawValue
        let indexOfValue = rawValues.firstIndex(of: model.value.rawValue)!
        let initialIndex: PickerViewViewController.Index = (column: 0, row: indexOfValue)
        
        alert.title = model.title
        alert.message = model.description
        
        alert.addPickerView(values: pickerViewValues, initialSelection: initialIndex, action: { [weak self] _, _, indexPath, _ in
            model.value = type(of: model.value).init(rawValue: rawValues[indexPath.row])!
            self?.reload()
        })
        
        alert.addAction(title: "NKEnumICSectionController.alert.done".localized, style: .cancel, isEnabled: true, handler: { [weak self] alert in
            
            guard let strongSelf = self else { return }
            strongSelf.delegate?.sectionController?(strongSelf, didUpdate: model.value.rawValue, at: index)

            NKLog("NKEnumICSectionController", "Model value updated. New value is", model.value, "(RAW:", model.value.rawValue, ")")
        })
        
        
    }
    
    private func showSlider(in alert: UIAlertController, for model: NKListRangedModel<Float>, at index: Int) {
        
        alert.title = model.title
        alert.message = model.description
        
        let initialValue = (model.value - model.minValue) / (model.maxValue - model.minValue)
        
        let doneAction = UIAlertAction(title: "NKEnumICSectionController.alert.done".localized, style: .cancel, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.sectionController?(strongSelf, didUpdate: model.value, at: index)
        })
        
        alert.addSliderView(initialValue: initialValue, action: { [weak self] _, _, action in
            switch action {
            case .touchDown:
                doneAction.isEnabled = false
            case .touchUp:
                doneAction.isEnabled = true
            case .valueChanged(let value):
                model.value = model.minValue + (model.maxValue - model.minValue) * value
                self?.reload()
            }
        })
        
        alert.addAction(doneAction)
        
    }
    
    private func showIntPicker<T: NKWideRangePickable>(in alert: UIAlertController, for model: NKListRangedModel<T>, at index: Int) {
        
        let configuration: NKWideRangePickerViewController.Config = { textField in
            textField.text = "\(model.value)"
            textField.placeholder = "NKEnumICSectionController.alert.textEdit.placeholder".localized
            textField.isPlaceholderAnimated = true
            textField.keyboardType = .numberPad
        }
        
        alert.title = model.title
        alert.message = model.description
        
        alert.addWideRangePicker(configuration: configuration, min: model.minValue, max: model.maxValue) { [weak self] _, value in
            model.value = value
            self?.reload()
        }
        
        alert.addAction(title: "NKEnumICSectionController.alert.done".localized, style: .cancel, isEnabled: true, handler: { [weak self] alert in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.sectionController?(strongSelf, didUpdate: model.value, at: index)
        })

    }
    
    private func showStringPicker(in alert: UIAlertController, for model: NKStringListModel, at index: Int) {
        
        let configuration: NKWideRangePickerViewController.Config = { textField in
            textField.text = model.value
            textField.placeholder = "NKEnumICSectionController.alert.textEdit.placeholder".localized
            textField.isPlaceholderAnimated = true
            textField.keyboardType = .default
            textField.isSecureTextEntry = model.isSequreEntry
        }
        
        alert.title = model.title
        alert.message = model.description
        
        alert.addStringPicker(configuration: configuration) { [weak self] _, value in
            model.value = value
            self?.reload()
        }
        
        alert.addAction(title: "NKEnumICSectionController.alert.done".localized, style: .cancel, isEnabled: true, handler: { [weak self] alert in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.sectionController?(strongSelf, didUpdate: model.value, at: index)
        })

    }
    
    private func reload() {
        self.collectionContext?.performBatch(animated: false, updates: { [weak self] in
            guard let strongSelf = self else { return }
            $0.reload(strongSelf)
        })
    }
    
    //MARK: - ListBindingSectionControllerDataSource
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let enumSection = object as? NKEnumSectionModel else { return [] }
        
        var models: [ListDiffable] = []
        
        let sectionTitle = enumSection.sectionTitle
        let titles = enumSection.titles
        let items = enumSection.items
        let icons = enumSection.icons
        let desctriptions = enumSection.descriptions
        
        models.append(NKSectionModel(style: .top, title: sectionTitle))
        
        if items.count != titles.count { return models }
        
        for i in 0 ..< titles.count {
            
            let description: String?
            let icon: UIImage?
            
            if desctriptions.count == items.count {
                description = desctriptions[i]
            } else {
                description = nil
            }
            
            if icons.count == items.count {
                icon = icons[i]
            } else {
                icon = nil
            }
            
            let value = items[i]
            
            switch value {
            case is ListEnumStringConvertable:
                models.append(ListEnumICModel(title: titles[i], value: value as! ListEnumStringConvertable, description: description, icon: icon))
            case is (NKListDisplayable & ListDiffable):
                let rangedModel = value as! (NKListDisplayable & ListDiffable)
                rangedModel.title = titles[i]
                rangedModel.icon = icon
                rangedModel.description = description
                
                models.append(rangedModel)
            case is String:
                models.append(NKStringListModel(value: value as! String, isSequreEntry: false, title: titles[i], description: description, icon: icon))
            case is Bool:
                models.append(NKBoolListMoldel(value: value as! Bool, title: titles[i], icon: icon, description: description))
            default:
                break
            }
            
            
        }
        
        itemsCount = models.count
        
        return models
        
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        
        let cellToReturn: UICollectionViewCell & ListBindable
        
        switch viewModel {
        case is NKSectionModel:
            cellToReturn = collectionContext?.dequeueReusableCell(of: NKSectionCell.self, for: self, at: index) as! NKSectionCell
        case is ListEnumICModel:
            cellToReturn = collectionContext?.dequeueReusableCell(of: NKEnumBindableCell.self, for: self, at: index) as! NKEnumBindableCell
        case is NKListRangedModel<Float>:
            cellToReturn = collectionContext?.dequeueReusableCell(of: NKNumericParamBindableCell<Float>.self, for: self, at: index) as! NKNumericParamBindableCell<Float>
        case is NKListRangedModel<UInt16>:
            cellToReturn = collectionContext?.dequeueReusableCell(of: NKNumericParamBindableCell<UInt16>.self, for: self, at: index) as! NKNumericParamBindableCell<UInt16>
        case is NKListRangedModel<UInt32>:
            cellToReturn = collectionContext?.dequeueReusableCell(of: NKNumericParamBindableCell<UInt32>.self, for: self, at: index) as! NKNumericParamBindableCell<UInt32>
        case is NKBoolListMoldel:
            let model = viewModel as! NKBoolListMoldel
            let cell = collectionContext?.dequeueReusableCell(of: NKBoolParamCell.self, for: self, at: index) as! NKBoolParamCell
            
            cell.handler = { [weak self] state in
                model.value = state
                guard let strongSelf = self else { return }
                strongSelf.delegate?.sectionController?(strongSelf, didUpdate: state, at: index)
            }
            
            cellToReturn = cell
        case is NKDiscreteRangedModel<UInt16>:
            cellToReturn = collectionContext?.dequeueReusableCell(of: NKDiscreteRangedCell<UInt16>.self, for: self, at: index) as! NKDiscreteRangedCell<UInt16>
        case is NKDiscreteRangedModel<UInt32>:
            cellToReturn = collectionContext?.dequeueReusableCell(of: NKDiscreteRangedCell<UInt32>.self, for: self, at: index) as! NKDiscreteRangedCell<UInt32>
        case is NKDiscreteRangedModel<Int16>:
            cellToReturn = collectionContext?.dequeueReusableCell(of: NKDiscreteRangedCell<Int16>.self, for: self, at: index) as! NKDiscreteRangedCell<Int16>
        case is NKStringListModel:
            cellToReturn = collectionContext?.dequeueReusableCell(of: NKStringBindableCell.self, for: self, at: index) as! NKStringBindableCell
        default:
            fatalError("No cell for given model!")
        }
        
        if let cell = cellToReturn as? ImageBassedTableCell {
            cell.isHairlineHidden = false
            cell.roundedCorners = []
            
            if index == 1 {
                cell.cornerRadius = 10.0
                cell.roundedCorners = [.topLeft, .topRight]
            }
            
            if index == (itemsCount - 1) {
                cell.cornerRadius = 10.0
                cell.isHairlineHidden = true
                cell.roundedCorners = [cell.roundedCorners, .bottomLeft, .bottomRight]
            }
        }
        
        return cellToReturn
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let contextSize = self.collectionContext?.containerSize else { return .zero }
    
        return CGSize(width: contextSize.width - 2 * leftRightInset, height: 50.0)
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didSelectItemAt index: Int, viewModel: Any) {
        showSelectorAlert(for: viewModel, at: index)
    }
    
    deinit {
        NKLog("NKListParamSectionController", "deinit")
    }
}
