//
//  SecondPageViewController.swift
//  GetMyAPI
//
//

import UIKit
import MapKit
import CoreLocation

class SecondPageViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    
    
    let annotation = MKPointAnnotation()
    
    var getLocation = false
    
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    
    //長按加上大頭針
    @IBAction func addAnnotation(_ sender: UILongPressGestureRecognizer){
         let touchPoint = sender.location(in: myMapView)
        
         // touch的位置轉成座標
         let touch = myMapView.convert(touchPoint, toCoordinateFrom: myMapView)
        
        // 生出大頭針
        let annotation = MKPointAnnotation()
        
        // 設定座標
        annotation.coordinate = touch
        
        // 顯示經緯度
        print("latitude: \(annotation.coordinate.latitude), longitude: \(annotation.coordinate.longitude)")
        
        // 加到地圖上
        myMapView.addAnnotation(annotation)

    }
    
    //按鍵：確認上傳資料
    @IBAction func clickDone(_ sender: UIButton) {
        
        
        // 匯入點選地圖的座標數據
        let inLatitude = "\(annotation.coordinate.latitude)"
        let inLongitude = "\(annotation.coordinate.longitude)"
       
      
        // 指定上傳資料的雲端API
        let urlString = "https://sheetdb.io/api/v1/ht438x7z6lqd5"
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 對應到雲端API的Google Sheet各個項目
        let item = Item(latitude: inLatitude, longitude: inLongitude)
        
        // 資料上傳
        let itemdata = ItemData(data: [item])
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(itemdata) {
            let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (returnData, response, error) in
                let decoder = JSONDecoder()
                
                if let returnData = returnData,
                    let dic = try? decoder.decode([String: Int].self, from: returnData),
                    dic["created"] == 1 {
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }else{
                    print ("if let returnData = retrnData fail")
                }
            }
            task.resume()
        }else {
            print("encode fail")
        }
        
    }
    
    
}



