//
//  NextViewController.swift
//  Map
//
//  Created by 石川裕太 on 2021/01/23.
//

import UIKit
//プロトコルの宣言
protocol SearchLocationDelegate {
    func searchLocation(ido:String, keido:String)
}

class NextViewController: UIViewController {

    //緯度
    @IBOutlet weak var idoText: UITextField!
    //経度
    @IBOutlet weak var keidoText: UITextField!
    //プロコトルの変数化  空を許さない?をつける.
    var searchDelegate:SearchLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //OKボタンが押された時にDelegateに委任
    @IBAction func okAction(_ sender: Any) {
        //入力された値を受け取る
        let ido = idoText.text!
        let keido = keidoText.text!
        //Delegateで委任
        searchDelegate!.searchLocation(ido: ido, keido: keido)
        //戻る
        if idoText.text != nil && keidoText.text != nil{
            dismiss(animated: true, completion: nil)
        }
       
    }
}
