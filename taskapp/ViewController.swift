//
//  ViewController.swift
//  taskapp
//
//  Created by Hiroki Watanabe on 2017/01/02.
//  Copyright © 2017年 Hiroki Watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    
    //Realm インスタンスを取得する
    let realm = try! Realm()
    
    //DB内のタスクが格納されるリスト
    //日付の近い順でソート：降順
    //以降の内容をアップデートするとリスト内は自動更新される
    let taskArray = try!Realm().objects(Task.self).sorted(byProperty: "date", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
            
            tableView.reloadData()
            
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
        
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        
        let task = taskArray[indexPath.row]
        
        cell.textLabel?.text = task.title +  " "  + task.category
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date as Date)
        
        cell.detailTextLabel?.text = dateString
        
        
        return cell
    }
    
    // MARK: UITableViewDelegateプロトコルのメソッド
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //データベースから削除する

        try! realm.write{
            
                self.realm.delete(self.taskArray[indexPath.row])
            
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
        
    }

      //segueで画面遷移するように呼ばれる
        
        func prepare(for segue : UIStoryboardSegue, sender: Any?){
            
            let inputViewController:InputViewController = segue.destination as! InputViewController
            
            if segue.identifier == "cellSegue"{
                
                let indexPath = self.tableView.indexPathForSelectedRow
                inputViewController.task = taskArray[indexPath!.row]
                

            }else{
                
                let task = Task()
                task.date = NSDate()
                
                if taskArray.count != 0 {
                   task.id = taskArray.max(ofProperty: "id")! + 1
            
            
                }
                
                inputViewController.task = task
                
            }
        }
        
}
}
