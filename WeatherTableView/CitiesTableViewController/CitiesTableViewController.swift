//
//  CitiesTableViewController.swift
//  WeatherTableView
//
//  Created by Артем Панченко on 13.02.2023.
//

import Foundation
import UIKit

class CitiesTableViewController: UIViewController {
    @IBOutlet var tableView: UITableView!//для всплывающего окна
    //наблюдатель сортирующий массив при каждом изменение, вместо сортировка при каждой загрузке 🤔
    var cities: [CitiesProtocol] = [] {
        didSet {
            cities.sort{$0.title < $1.title}
            //сохранение в хранилище
            storage.save(cities: cities) //при каждом изменение массив контактов будет передан в хранилище
        }
    }
    
    //чтобы не обращаться UserDefaults.standart
    var storage: CitiesStorageProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = CityStorage()
        loadContact()
        //userDefaults.set("Some random", forKey: "Some Key")
        
    }
    
    private func loadContact() {
        cities = storage.load()
        //contacts.append(Contact(title: "Mr.Santekchnick", phone: "+766666666"))
        // contacts.sort{$0.title < $1.title}
    }
    
    //всплывающее окно создания контакта
    @IBAction func showNewCityAlert() {
        //создание Alert Controller
        let alertController = UIAlertController(title: "Создайте новый контакт", message: "Введите имя и телефон", preferredStyle: .alert)
        
        //добавляем поле в алерт контроллер
        //placeholder это светло серый текс - подсказка для заполнения
        alertController.addTextField {textField in textField.placeholder = "Имя"}
        
        
        //        //доб еще поле в алерт контроллер
        //        alertController.addTextField {textField in textField.placeholder = "Номер телефона"}
        
        //создаем кноки
        //кнопка создания контакта
        let createButton = UIAlertAction(title: "Новый контакт", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text else { return }
            
            //создаем новый контакт
            let city =  City(title: contactName)
            self.cities.append(city)
            self.tableView.reloadData()
        }
        
        // кнопка отмена
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        //добавляем конки в Alert Controller
        alertController.addAction(cancelButton)
        alertController.addAction(createButton)
        
        //отобрaжение Alert Controller
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - ОТОБРАЖЕНИЕ ТЕЙБЛ ВЬЮ
extension CitiesTableViewController: UITableViewDataSource{
    //возврщает общее кол-во строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    //возвращает экземпляр ячейки для конкретной строки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            print("используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
        
    private func configure (cell: inout UITableViewCell, for indexPath: IndexPath){
        var configuration = cell.defaultContentConfiguration()
        //contact name
        configuration.text = cities[indexPath.row].title//индекс соответствует индексу выводимой строки таблицы
        cell.contentConfiguration = configuration
    }

}
//MARK: - РЕДАКТИРОВАНИЕ ТЕЙБЛ ВЬЮ
        
extension CitiesTableViewController: UITableViewDelegate {
    //возвращает обьект описывающий множество действий доступный при свайпе ячейки влево
    //uitableview - табличное представление в котором производится свайп
    //...indexPath: IndexPath - индекс строки по которой производится свайп
    //UISwipeActionsConfiguration? - определяет доступный действия для конкретной строки
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //удаление. в UIContextualAction описывается одно действие доступное при свайпе
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete"){
            _,_,_  in //третий аргумент это замыкание, которое определяет конкретные операции, которые
            //будут выполнены при активиции действия
            //delete contact
            self.cities.remove(at: indexPath.row)
            //заново формируем табличное представление
            tableView.reloadData()
        }
        //формируем экземпляр описывающий доступные действия
        let acitons = UISwipeActionsConfiguration(actions: [actionDelete])//
        return acitons //ячейки таблицы получают обьект описывающий доступные при свайпе действия
//        print("определяем доступные дейтсвия для строки \(indexPath.row)")
//        return nil
    }
}
