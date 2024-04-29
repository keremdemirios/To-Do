// TODO: None filtresinde durumlara gore filtreleme
// TODO: Sadakat programi yap. tamamladigi goreve gore ates'i artsin mesela.
//
//  ViewController.swift
//  ToDo Firebase
//
//  Created by Kerem Demir on 15.04.2024.
//

import UIKit
import CoreData

final class HomeScreen: UIViewController {
    
    // MARK: Properties
    private var models = [ToDoListItem]() {
        didSet {
            print("To do items was set.")
            reloadTableView()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var filteredItems = [ToDoListItem]() {
        didSet {
            if filteredItems.isEmpty {
                showEmptyView()
            } else {
                todoTableView.backgroundView = nil
            }
        }
    }
    
    var currentFilter: FilterOption = .none
    var isFiltering: Bool {
        return currentFilter != .none
    }
    
    @IBOutlet weak var todoTableView: UITableView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do ✅"
        view.backgroundColor = .systemBackground
        
        configure()
    }
    
    func showEmptyView() {
        let emptyView = EmptyView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        todoTableView.backgroundView = emptyView
    }
    
    // MARK: Configure
    private func configure() {
        configureTodoTableView()
        getAllItems()
    }
    
    private func configureTodoTableView() {
        
    }
    
    // MARK: Core Data
    private func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            filteredItems = models
            reloadTableView()
        } catch {
            print(" Error in get all items function : \(error.localizedDescription)")
        }
    }
    
    private func createItem(name: String, status: Status) throws {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.status = status.rawValue
        
        do {
            try context.save()
            getAllItems()
        } catch {
            throw CoreDataError.createFailure
        }
    }
    
    private func deleteItem(item: ToDoListItem) throws {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            throw CoreDataError.deleteFailure
        }
    }
    
    private func updateItem(item: ToDoListItem, newName: String) throws {
        item.name = newName
        
        do {
            try context.save()
            getAllItems()
        } catch  {
            throw CoreDataError.updateFailure
        }
    }
    
    private func updateItemStatus(at index: Int, newStatus: Status) throws {
        let selectedItem = models[index]
        selectedItem.status = newStatus.rawValue
        
        do {
            try context.save()
            getAllItems()
        } catch {
            throw CoreDataError.updateFailure
        }
    }
    
    // MARK: Core Data
    private func deleteAllItems() {
        let entityNames = context.persistentStoreCoordinator?.managedObjectModel.entities.compactMap({ $0.name })

        entityNames?.forEach { entityName in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("Error deleting \(entityName): \(error)")
            }
        }
    }
    
    // MARK: Functions
    func reloadTableView() {
        DispatchQueue.main.async {
            self.todoTableView.reloadData()
        }
    }
    
    private func applyFilter() {
        
        if let selectedStatus = currentFilter.status {
            if selectedStatus == .none? {
                models = filteredItems
            } else {
                models = filteredItems.filter { $0.status == selectedStatus.rawValue }
            }
        } else {
            models = filteredItems
        }
        reloadTableView()
    }


    
    private func showFilterOptions() {
        let alertController = UIAlertController(title: "Filtering",
                                                message: "Choose Filter",
                                                preferredStyle: .actionSheet)
        
        let noneAction = UIAlertAction(title: "None", style: .default) { _ in
            self.currentFilter = .none
            self.applyFilter()
        }
        alertController.addAction(noneAction)
        
        let todoAction = UIAlertAction(title: "To Do", style: .default) { _ in
            self.currentFilter = .todo
            self.applyFilter()
        }
        alertController.addAction(todoAction)
        
        let doingAction = UIAlertAction(title: "Doing", style: .default) { _ in
            self.currentFilter = .doing
            self.applyFilter()
        }
        alertController.addAction(doingAction)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.currentFilter = .done
            self.applyFilter()
        }
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        print("Add tapped.")
        
        let alert = UIAlertController(title: "New Task",
                                      message: "Enter a new task.",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder            = "Example: Clean the garage."
            textField.autocapitalizationType = .sentences // Text starts with a capital letter.
            textField.autocorrectionType     = .no // Text autocorrection is not active.
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                UIAlertController.showAlertForAnything(title: "Error", message: "Task name cannot be empty.", presentingViewController: self)
                return
            }
            
            try? self.createItem(name: text, status: .todo)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }

    
    @IBAction func filterButtonAction(_ sender: UIBarButtonItem) {
        print("Filter tapped.")
        showFilterOptions()
    }


    @IBAction func moreButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "More",
                                                message: "More Options",
                                                preferredStyle: .actionSheet)
        
        let deleteAllAction = UIAlertAction(title: "Delete All", style: .destructive) { _ in
            // Uyarı göster
            let confirmationAlertController = UIAlertController(title: "Delete All",
                                                                 message: "Are you sure you want to delete all tasks?",
                                                                 preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.deleteAllItems()
                self.getAllItems()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            confirmationAlertController.addAction(confirmAction)
            confirmationAlertController.addAction(cancelAction)
            
            self.present(confirmationAlertController, animated: true)
        }
        alertController.addAction(deleteAllAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
}

// MARK: Extensions
extension HomeScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GoalsCell.reuseIndetifier, for: indexPath) as? GoalsCell else {
            return UITableViewCell()
        }
        
        let model = models[indexPath.row]
        
        guard let statusString = model.status else {
            return cell
        }
        
        if let status = Status(rawValue: statusString) {
            cell.setCell(name: model.name, status: statusString, statusColor: status.colorForStatus(), checkBoxSystemImageName: status.imageForStatus())
        } else {
            // TODO: Buraya bir bak. Anlicaksin bakinca ne sorun oldugunu ama islevde sorun yaratmiyor.
            print("Burda bir sorun var.")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoTableView.deselectRow(at: indexPath, animated: false)
        
        let selectedItem = models[indexPath.row]
        let selectedIndex = indexPath.row
        
        do {
            // Durumları içeren sozluk
            let statusDict : [String: Status] = [
                "To Do" : .todo ,
                "Doing" : .doing,
                "Done"  : .done
            ]
            
            guard let statusString = selectedItem.status else {
                throw CoreDataError.updateFailure
            }
            
            // Sozlukten durumu al
            guard let status = statusDict[statusString] else {
                throw CoreDataError.updateFailure
            }
            
            switch status {
            case .todo:
                try updateItemStatus(at: selectedIndex, newStatus: .doing)
                applyFilter()
            case .doing:
                try updateItemStatus(at: selectedIndex, newStatus: .done)
                applyFilter()
            case .done:
                applyFilter()
                break
            }
        } catch {
            print("Hata oluştu: \(error)")
        }
    }


    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            let item = models[indexPath.row]
            let alert = UIAlertController(title: "Confirm Deletion",
                                          message: "Are you sure you want to delete this task?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete",
                                          style: .destructive,
                                          handler: { [weak self] _ in
                guard let self else { return }
                
                try? self.deleteItem(item: item)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if editingStyle == .insert {

        }
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let item = self.models[indexPath.row]
            let alert = UIAlertController(title: "Edit Task",
                                          message: "Edit task.",
                                          preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.text = item.name
            }
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    UIAlertController.showAlertForAnything(title: "Error", message: "Task name cannot be empty.", presentingViewController: self)
                    return
                }
                
                try? self.updateItem(item: item, newName: newName)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
            completionHandler(true)
        }
        
        editAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let item = self.models[indexPath.row]
            let alert = UIAlertController(title: "Confirm Deletion",
                                          message: "Are you sure you want to delete this task?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                guard let self else { return }
                try? self.deleteItem(item: item)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
