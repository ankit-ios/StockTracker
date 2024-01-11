//
//  StockListViewController.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import UIKit

class StockListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StoryboardInstantiable, Alertable {
    
    private var viewModel: StockListViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    static func create(with viewModel: StockListViewModel) -> StockListViewController {
        let view = StockListViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.screenTitle
        let nib = UINib(nibName: "StockListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "StockListCell")
        
        bind(to: viewModel)
        viewModel.fetchStockList()
    }
    
    private func bind(to viewModel: StockListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    private func updateItems() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockListCell", for: indexPath) as! StockListCell
        let stock = viewModel.items.value[indexPath.row]
        cell.configure(with: stock)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
