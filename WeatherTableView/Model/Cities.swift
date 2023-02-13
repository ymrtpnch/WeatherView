//
//  Cities.swift
//  WeatherTableView
//
//  Created by Артем Панченко on 13.02.2023.
//

import Foundation

protocol CitiesProtocol {
    //name
    var title: String { get set }
}

struct City: CitiesProtocol {
    var title: String
}

protocol CitiesStorageProtocol {
    //загрузка контактов
    func load() -> [CitiesProtocol]
    
    //обновление списка контактов
    func save(cities: [CitiesProtocol])
}

class CityStorage: CitiesStorageProtocol {
    //Ссылка на хранилище
    private var storage = UserDefaults.standard
    //ключ по которому идет сохрание хранилища
    private var storageKey = "cities"
    
    //Перечисление с ключами для записи в User Defaults
    private enum CityKey: String {
        case title
    }
    
    func load() -> [CitiesProtocol] {
        var resultCities: [CitiesProtocol] = []
        let citiesFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        for city in citiesFromStorage {
            guard let title = city[CityKey.title.rawValue] else {
                continue
            }
            resultCities.append(City(title: title))
        }
        return resultCities
    }
    
    func save(cities: [CitiesProtocol]) {
        var arrayForStorage: [[String:String]] = []//массив словарей title: "Sasha Baron", phone: "+7182383774"
        cities.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[CityKey.title.rawValue] = contact.title
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
    
}
