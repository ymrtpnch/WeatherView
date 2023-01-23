import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionWeather: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    let apiKey = "e9ca9e4a41a822ddf4f299391a79171b"
    //MARK: - VC Life
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    // Terms and Agreement
    @IBAction func didTapTermsButton() {
        let storyboard = UIStoryboard(name: "TermsViewController", bundle: nil)//для всплывающего экрана создаем сущность СБ - из нее уже создаем ВС
        let vc = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        present(vc, animated: true)
    }
        
    @IBAction func changeCityAlert(_ sender: Any) {
        //создание Alert Controller
        let alertController = UIAlertController(title: "Change city", message: "Insert city title", preferredStyle: .alert)
        
        //добавляем поле в алерт контроллер
        //placeholder это светло серый текст - подсказка для заполнения
        alertController.addTextField {textField in textField.placeholder = "City title"}
        
        
        //создаем кноки
        //кнопка изменения города
        let createButton = UIAlertAction(title: "Choose", style: .default) { _ in
            if let city = alertController.textFields?[0].text {
                self.changeCity(city: city)
            }
            
            //self.locationLabel.text = alertController.textFields?[0].text
            //guard let contactName = alertController.textFields?[0].text,
                  //let contactPhone = alertController.textFields?[1].text else { return }
            
            //создаем новый контакт
//            let contact =  Contact(title: contactName, phone: contactPhone)
//            self.contacts.append(contact)
//            self.tableView.reloadData()
        }
        
        // кнопка отмена
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //добавляем конки в Alert Controller
        alertController.addAction(cancelButton)
        alertController.addAction(createButton)
        
        //отобрaжение Alert Controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    //MARK: - Other Func
    //Проверяет существование города в базе Openwether
    func changeCity(city: String){
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)").responseJSON {
            response in
            switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let jsonWeather = json["weather"].array![0]//вложенный массив
                    print(json)
                    //print("\(jsonWeather)")
                    let iconName = jsonWeather["icon"].stringValue
                    let jsonTemp = json["main"]
                    //if let city = json["name"].string {print(city)} //плоский
                    //if let desc = json["sys"]["country"].string {print(desc)} //вложенный
                
                    //присвоение значений
                    self.locationLabel.text = json["name"].stringValue
                    self.weatherImage.image = UIImage(named: iconName)
                    self.conditionWeather.text =  jsonWeather["main"].stringValue
                    self.temperature.text = "\(Int(round((jsonTemp["temp"].doubleValue-273.15))))" //при таком запросе выдает в кельвинах температуры -_-
                
                case .failure(let error):
                print(error)
            }
        }
    }
}
