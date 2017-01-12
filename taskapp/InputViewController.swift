//
//  InputViewController.swift
//  taskapp
//
//  Created by Hiroki Watanabe on 2017/01/02.
//  Copyright © 2017年 Hiroki Watanabe. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift


class InputViewController: UIViewController {
    
    
    @IBOutlet weak var titeleTextField: UITextField!
    
    @IBOutlet weak var contentsTextView: UITextView!

    @IBOutlet weak var dataPicker: UIDatePicker!
    
    @IBOutlet weak var category: UITextField!
    
    var task: Task!
    
    let realm = try!Realm()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する funcを指定する必要があるが、指定していない
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self , action:#selector(dismissKeyboard))
        
        
        
        self.view.addGestureRecognizer(tapGesture)
        
        titeleTextField.text = task.title
        contentsTextView.text = task.contents
        dataPicker.date = task.date as Date
        category.text = task.category
        
        

       }
    
    
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
    
        try! realm.write{
            self.task.title = self.titeleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.dataPicker.date as NSDate
            self.task.category = self.category.text!

            self.realm.add(self.task, update: true)
            
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)

    }
    
    
    
    
    
    //タスクのローカル通知を登録する
    
    func setNotification(task: Task){
        
        let content = UNMutableNotificationContent()
        
        content.title = task.title
        content.body = task.contents
        content.title = task.category

        
        content.sound = UNNotificationSound.default()
        
        //トリガーを作成
        let calendar = NSCalendar.current
        let dataComponets = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: task.date as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dataComponets,repeats: false)
        
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let repuest = UNNotificationRequest.init(identifier:String(task.id),content: content,trigger: trigger)
        
        //ローカル通知を登録
        
        let center = UNUserNotificationCenter.current()
        
        center.add(repuest){ (error)in
            print(error)
            
        }
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests{ (requests:[UNNotificationRequest])in
            for request in requests {
                print("/---------------")
                print(request)
                print("/--------------/")
                
                
            }
        
        
    }
    
    
    
    
    func dismissKeyboard(){
        
        view.endEditing(true)
        
    }

    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
}
