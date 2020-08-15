//
//  HTTPRequestManager.swift
//
//  Created by Prashant Gautam on 19/03/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

public enum HTTPRequestErrorCode: Int {
    case httpConnectionError = 40 // Trouble connecting to Server.
    case httpInvalidRequestError = 50 // Your request had invalid parameters.
    case httpResultError = 60 // API result error (eg: Invalid username and password).
}

final class HTTPRequestManager: NSObject, URLSessionDelegate{
    fileprivate lazy var urlSession: URLSession = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInteractive
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: operationQueue)
    }()
    // This will hold the currently running requests
    fileprivate var runningURLRequests: NSSet = NSSet()
    
    fileprivate var networkFetchingCount: Int = 0
    private var isSSLPinningEnabled = false
    private var certificateFileName = ""
    // MARK: - Singleton Instance
    
    class var shared: HTTPRequestManager {
        struct Singleton {
            static let instance = HTTPRequestManager()
        }
        return Singleton.instance
    }
    
    private override init() {}
    
    func setCertficateName(_ text: String){
        self.certificateFileName = text
    }
    
    func setSSLPinning(_ required: Bool){
        self.isSSLPinningEnabled = required
    }
    
    // MARK: - Public Methods
    
    /**
     Perform request to fetch data
     
     - parameter request:           request
     - parameter info:          userinfo
     - parameter completionHandler: handler
     */
    func performRequest(_ request: URLRequest, info _: NSDictionary? = nil, completionHandler: @escaping (_ response: Response) -> Void) {
        guard isNetworkAvaiblable() else {
            let response = Response(request, nil, nil, error: NetworkError.reachability(string: "Network not available"))
            completionHandler(response)
            return // do not proceed if user is not connected to internet
        }
        performSessionDataTaskWithRequest(request, completionHandler: completionHandler)
    }
    
    /**
     Perform session data task
     
     - parameter request:           url request
     - parameter userInfo:          user information
     - parameter completionHandler: completion handler
     */
    fileprivate func performSessionDataTaskWithRequest(_ request: URLRequest, completionHandler: @escaping (_ response: Response) -> Void) {
        addRequestURL(request.url!)
        urlSession.dataTask(with: request, completionHandler: { data, response, error in
            //var responseError: Error? = error
            var apiResponse: Response
            apiResponse = Response(request, response as? HTTPURLResponse, data, error: error)
            
            self.removeRequestedURL(request.url!)
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(apiResponse)
            })
        }).resume()
    }
    
    //MARK: URL Session Delegate
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {return}
        let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
        
        if !self.isSSLPinningEnabled {
            let credential:URLCredential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            // Set SSL policies for domain name check
            let policies = NSMutableArray();
            policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)))
            SecTrustSetPolicies(serverTrust, policies)
            
            // Evaluate server certificate
            var result: SecTrustResultType = SecTrustResultType.invalid
            SecTrustEvaluate(serverTrust, &result)
            let isServerTrusted:Bool = result == SecTrustResultType.unspecified || result ==  SecTrustResultType.proceed
            
            // Get local and remote cert data
            let remoteCertificateData:NSData = SecCertificateCopyData(certificate!)
            let pathToCert = Bundle.main.path(forResource: self.certificateFileName, ofType: "cer")
            let localCertificate:NSData = NSData(contentsOfFile: pathToCert!)!
            
            if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificate as Data)) {
                // Pinning Success
                let credential:URLCredential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
            } else {
                // Pinning failed
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    fileprivate func logError(_ error: Error, request: URLRequest) {
        #if DEBUG
        print("URL: \(String(describing: request.url?.absoluteString)) Error: \(error.localizedDescription)")
        #endif
    }
    
    fileprivate func logResponse(_ data: Data, forRequest request: URLRequest) {
        #if DEBUG
        print("Data Size: \(data.count) bytes")
        let output: NSString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        print("URL: \(String(describing: request.url?.absoluteString)) Output: \(output)")
        #endif
    }
}

// MARK: - Request handling methods

extension HTTPRequestManager {
    /**
     Add a Url to request Manager.
     
     - parameter url: URL
     */
    fileprivate func addRequestURL(_ url: URL) {
        objc_sync_enter(self)
        let requests: NSMutableSet = runningURLRequests.mutableCopy() as! NSMutableSet
        requests.add(url)
        runningURLRequests = requests
        objc_sync_exit(self)
    }
    
    /**
     Remove url from Manager.
     
     - parameter url: URL
     */
    fileprivate func removeRequestedURL(_ url: URL) {
        objc_sync_enter(self)
        let requests: NSMutableSet = runningURLRequests.mutableCopy() as! NSMutableSet
        if requests.contains(url) == true {
            requests.remove(url)
            runningURLRequests = requests
        }
        objc_sync_exit(self)
    }
    
    /**
     Check wheather requesting fro URL.
     
     - parameter URl: url to check.
     
     - returns: true if current request.
     */
    fileprivate func isProcessingURL(_ url: URL) -> Bool {
        return runningURLRequests.contains(url)
    }
    
    /**
     Cancel session for a URL.
     
     - parameter url: URL
     */
    func cancelRequestForURL(_ url: URL) {
        urlSession.getTasksWithCompletionHandler({ (dataTasks: [URLSessionDataTask], uploadTasks: [URLSessionUploadTask], downloadTasks: [URLSessionDownloadTask]) -> Void in
            
            let capacity: NSInteger = dataTasks.count + uploadTasks.count + downloadTasks.count
            let tasks: NSMutableArray = NSMutableArray(capacity: capacity)
            tasks.addObjects(from: dataTasks)
            tasks.addObjects(from: uploadTasks)
            tasks.addObjects(from: downloadTasks)
            
            let predicate: NSPredicate = NSPredicate(format: "originalRequest.URL.path = %@", url.path as CVarArg)
            tasks.filter(using: predicate)
            
            for task in tasks {
                (task as? URLSessionTask)?.cancel()
            }
        })
    }
    
    /**
     Cancel All Running Requests
     */
    func cancelAllRequests() {
        urlSession.getTasksWithCompletionHandler({ (dataTasks: [URLSessionDataTask], uploadTasks: [URLSessionUploadTask], downloadTasks: [URLSessionDownloadTask]) -> Void in
            
            let capacity: NSInteger = dataTasks.count + uploadTasks.count + downloadTasks.count
            let tasks: NSMutableArray = NSMutableArray(capacity: capacity)
            tasks.addObjects(from: dataTasks)
            tasks.addObjects(from: uploadTasks)
            tasks.addObjects(from: downloadTasks)
            
            for task in tasks {
                (task as? URLSessionTask)?.cancel()
            }
        })
    }
    
    func isNetworkAvaiblable() -> Bool {
        if let reachability = Reachability() {
            return reachability.isReachable
        }
        return true
    }
    
}


