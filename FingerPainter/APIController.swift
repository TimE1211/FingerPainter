//
//  APIController.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/22/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol APIControllerDelegate
{
  func apiControllerDidReceive(lineDictionary: [String: Any])
}

class APIController
{
  var delegate: APIControllerDelegate?
  var line: Line?
  let url = "localhost:8080"

  func getLine()
  {
    let sessionURL = "\(url)/getLine"
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let lineDictionary = value as! [String: Any]
        self.delegate?.apiControllerDidReceive(lineDictionary: lineDictionary)
      }
    }
  }
  
  func send(line: Line)
  {
    let sessionURL = "\(url)/sendLine"
    
    let parameters = line.postBody()
    
    print(sessionURL)
    
    let request = Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
//      encoding: JSONEncoding.default,
      encoding: URLEncoding.httpBody,
      headers: nil
      ).responseJSON(completionHandler: { responseData in
//        debugPrint(responseData)
      })
    
    debugPrint(request)
  }

//  func sendLine(line: Line)
//  {
//    let sessionURL = "\(url)/sendLine"
//    var request = URLRequest(url: URL(string: sessionURL)!)
//    request.httpMethod = "POST"
//    let paramString = "startx=\(line.start.x)&starty=\(line.start.y)&endx=\(line.end.x)&endy=\(line.end.y)"
//    request.httpBody = paramString.data(using: .utf8)
//    
//    URLSession.shared.dataTask(with: request) {
//      data, response, error in
//      if let error = error
//      {
//        print(error.localizedDescription)
//      }
//      else
//      {
//        do
//        {
//          if let errorDictionary = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
//          {
//            if let error = errorDictionary["error"] as? String
//            {
//              if error != "Line saved."
//              {
//                print("Line not saved: \(error)")
//              }
//            }
//          }
//        } catch
//        {
//          print(error.localizedDescription)
//        }
//      }
//      }.resume()
//  }
}





