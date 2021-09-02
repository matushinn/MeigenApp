//
//  ViewController.swift
//  MeigenApp
//
//  Created by 大江祥太郎 on 2021/09/02.
//

import UIKit

class FeedItem {
    var meigen = ""
    var auther = ""
}

class ViewController: UIViewController{
    
    @IBOutlet weak var meigenLabel: UILabel!
    
    var parser = XMLParser()
    var feedItem = [FeedItem]()
    
    //nilを許容するから
    var currentElementName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        getXMLData()
 
        parser.delegate = self
        parser.parse()
    }
    
    func getXMLData(){
        //XML解析を行う
        let urlString = "http://meigen.doodlenote.net/api?c=1"
        
        if let url = URL(string: urlString){
            parser = XMLParser(contentsOf: url)!
        }
    }
}

extension ViewController:XMLParserDelegate{
    //デバックをしながら、処理の順番を調べると良い
    //要素解析の開始
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = nil
        //①elementName = response
        if elementName == "data" {
            
            self.feedItem.append(FeedItem())
        }else{
            currentElementName = elementName
        }
    }
    
    //要素内の値の取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.feedItem.count > 0 {
            //meigenとautherを処理していく
            let lastItem = self.feedItem[self.feedItem.count - 1]
            
            switch self.currentElementName {
            case "meigen":
                //キー値が入る
                lastItem.meigen = string
            case "auther":
                lastItem.auther = string
                
                meigenLabel.text = lastItem.meigen + "\n" + lastItem.auther
            default:
                //②data
                break
            }
            
        }
    }
    
    //要素の終了時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil
    }
}
