//
//  ServiceManager.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/22/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

//https://www.ralfebert.de/tutorials/ios-swift-multipeer-connectivity/

protocol PointServiceManagerDelegate
{
  func connectedDevicesChanged(manager : PointServiceManager, connectedDevices: [String])
  func pointChanged(manager : PointServiceManager, point: CGPoint)
}

import Foundation
import MultipeerConnectivity

class PointServiceManager : NSObject
{
  private let PointServiceType = "example-point"
  
  private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
  
  private let serviceAdvertiser : MCNearbyServiceAdvertiser
  private let serviceBrowser : MCNearbyServiceBrowser
  
  lazy var session : MCSession = {
    let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
    session.delegate = self
    return session
  }()
  
  var delegate : PointServiceManagerDelegate?
  
  override init()
  {
    self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: PointServiceType)
    self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: PointServiceType)
    
    super.init()
    
    self.serviceAdvertiser.delegate = self
    self.serviceAdvertiser.startAdvertisingPeer()
    
    self.serviceBrowser.delegate = self
    self.serviceBrowser.startBrowsingForPeers()
  }
  
  deinit
  {
    self.serviceAdvertiser.stopAdvertisingPeer()
    self.serviceBrowser.stopBrowsingForPeers()
  }
  
  func send(point : CGPoint)
  {
    NSLog("%@", "sendPoint: \(point) to \(session.connectedPeers.count) peers")
    
    if session.connectedPeers.count > 0
    {
      do
      {
        let pointString = String("\(point.x) + \(point.y)")
        try self.session.send((pointString?.data(using: .utf8)!)!, toPeers: session.connectedPeers, with: .reliable)
      }
      catch let error
      {
        NSLog("%@", "Error for sending: \(error)")
      }
    }
  }
}

extension PointServiceManager : MCNearbyServiceAdvertiserDelegate
{
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error)
  {
    NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
  }
  
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void)
  {
    NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
    invitationHandler(true, self.session)
  }
}

extension PointServiceManager : MCNearbyServiceBrowserDelegate
{
  func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error)
  {
    NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    NSLog("%@", "foundPeer: \(peerID)")
    NSLog("%@", "invitePeer: \(peerID)")
    browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
  {
    NSLog("%@", "lostPeer: \(peerID)")
  }
}

extension PointServiceManager : MCSessionDelegate
{
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
  {
    NSLog("%@", "peer \(peerID) didChangeState: \(state)")
    self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
  {
    NSLog("%@", "didReceiveData: \(data.count) bytes")
    let str = String(data: data, encoding: .utf8)!
    let xValue =
    let yValue =
    let pt = CGPoint(x: xValue,y: yValue)
    self.delegate?.pointChanged(manager: self, point: pt)
    //???????????????????????????? ^need to convert point into data 
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    NSLog("%@", "didReceiveStream")
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
  {
    NSLog("%@", "didStartReceivingResourceWithName")
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?)
  {
    NSLog("%@", "didFinishReceivingResourceWithName")
  }
}







