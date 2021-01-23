//
//  ViewController.swift
//  Map
//
//  Created by 石川裕太 on 2021/01/23.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate, UIGestureRecognizerDelegate, SearchLocationDelegate {
    
    //地図
    @IBOutlet weak var mapView: MKMapView!
    //デリゲート変数化
    var locManager:CLLocationManager!
    //住所
    @IBOutlet weak var addressLabel: UILabel!
    //ボタン設定
    @IBOutlet weak var settingBtn: UIButton!
    //long Tap
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    
    //住所入れる配列
    var addressString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ボタン形状など決定
        settingBtn.backgroundColor = .white
        settingBtn.layer.cornerRadius = 20.0
    }

    //long Tap された時に
    @IBAction func longTap(_ sender: UILongPressGestureRecognizer) {
        //tap開始
        if sender.state == .began{
            
        }
        //tap終了
        else if sender.state == .ended{
            //tapした位置を指定してMKMap上の緯度経度を取得
            //viewのtapした場所を取得
            let tapPoint = sender.location(in: view)
            //tapした位置から緯度経度取得
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            let lat = center.latitude
            let log = center.longitude
            //緯度経度から住所取得.
            convert(lat: lat, log: log)
        }
    }
    ///緯度経度から住所へ変換
    func convert(lat: CLLocationDegrees, log:CLLocationDegrees){
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: log)
        //クロージャー
        //クロージャーには宣言していないものはselfが必要
        //()に何らかの値が入る時に処理を行う
        geocoder.reverseGeocodeLocation(location){
            (placeMark,error) in
            //admi=県, locality=市
            if let placeMark = placeMark{
                if let pm = placeMark.first{
                    if pm.administrativeArea != nil || pm.locality != nil{
                        self.addressString = pm.name!+pm.administrativeArea!+pm.locality!
                    }else{
                        self.addressString = pm.name!
                    }
                    self.addressLabel.text = self.addressString
                }
                
            }
            
        }
    }
    //procotolのデリゲートメソッド実装
    func searchLocation(ido: String, keido: String) {
        if ido.isEmpty != true && keido.isEmpty != true{
            let idoString = ido
            let keidoString = keido
            //緯度経度からコーディネート
            let cordinate = CLLocationCoordinate2D(latitude: Double(ido)!, longitude: Double(keido)!)
            //表示する範囲を指定
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            //領域を指定
            let region = MKCoordinateRegion(center: cordinate, span: span)
            //領域をMapViewに設定
            mapView.setRegion(region, animated: true)
            //緯度経度から住所へ変換
            convert(lat: Double(ido)!, log: Double(keido)!)
            //ラベルに表示
            addressLabel.text = addressString
        }else{
            addressLabel.text = "cant get"
        }
    }
    
    //ボタン押された時
    @IBAction func search(_ sender: Any) {
        //画面遷移
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next"{
            let nextVC = segue.destination as! NextViewController
            nextVC.searchDelegate = self
        }
    }
    
    
}
