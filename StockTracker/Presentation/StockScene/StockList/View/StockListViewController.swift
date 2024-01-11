//
//  StockListViewController.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import UIKit

final class StockListViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    private var viewModel: StockListViewModel!
    @IBOutlet private weak var tableView: UITableView!
    
    static func create(with viewModel: StockListViewModel) -> StockListViewController {
        let view = StockListViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.screenTitle
        let nib = UINib(nibName: StockListCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: StockListCell.reuseIdentifier)
        
        bind(to: viewModel)
        viewModel.fetchStockList()
    }
    
    private func bind(to viewModel: StockListViewModel) {
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoadingView($0) }
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    private func updateLoadingView(_ aFlag: Bool) {
        aFlag ? LoadingView.show() : LoadingView.hide()
    }
    
    private func updateItems() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        DispatchQueue.main.async {
            self.showAlert(title: self.viewModel.errorTitle, message: error)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension StockListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockListCell.reuseIdentifier, for: indexPath) as! StockListCell
        let stock = viewModel.items.value[indexPath.row]
        cell.configure(with: stock)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
