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

    // MARK: - Class Methods

    fileprivate func beginNetworkActivity() {
        networkFetchingCount += 1
        DispatchQueue.main.async {
            //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    func setCertficateName(_ text: String){
        self.certificateFileName = text
    }
    
    func setSSLPinning(_ required: Bool){
        self.isSSLPinningEnabled = required
    }
    /**
     Call to hide network indicator in Status Bar
     */
    fileprivate func endNetworkActivity() {
        if networkFetchingCount > 0 {
            networkFetchingCount -= 1
        }

        if networkFetchingCount == 0 {
            DispatchQueue.main.async {
                //UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
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
            let res = Response(request, nil, nil, error: NSError.errorForNoNetwork())
            completionHandler(res)
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
    fileprivate func performSessionDataTaskWithRequest(_ request: URLRequest, userInfo _: NSDictionary? = nil, completionHandler: @escaping (_ response: Response) -> Void) {
        beginNetworkActivity()
        addRequestURL(request.url!)
       
        urlSession.dataTask(with: request, completionHandler: { data, response, error in
            //var responseError: Error? = error
            var apiResponse: Response
//            if responseError != nil {
//                apiResponse = Response(request, response as? HTTPURLResponse, responseError!, data: data)
//                self.logError(apiResponse.error!, request: request)
//            } else {
            
            apiResponse = Response(request, response as? HTTPURLResponse, data, error: error)
                self.logResponse(data!, forRequest: request)
            //}

            self.removeRequestedURL(request.url!)

            DispatchQueue.main.async(execute: { () -> Void in
                self.endNetworkActivity()
                completionHandler(apiResponse)
            })
        }).resume()
    }

    /**
     Perform session data task

     - parameter request:           url request
     - parameter userInfo:          user information
     - parameter completionHandler: completion handler
     */
    func download(_ request: URLRequest, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        addRequestURL(request.url!)

        urlSession.dataTask(with: request, completionHandler: { data, response, error in
            var responseError: Error? = error
            // handle http response status
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode > 299 {
                    responseError = NSError.errorForHTTPStatus(httpResponse.statusCode)
                }
            }

            if responseError != nil {
                completionHandler(data, responseError)
            } else {
                completionHandler(data, error)
            }

            self.removeRequestedURL(request.url!)

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
    
    /*func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                
                if (errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let cert1 = NSData(bytes: data, length: size)
                        let file_der = Bundle.main.path(forResource: "name-of-cert-file", ofType: "cer")
                        
                        if let file = file_der {
                            if let cert2 = NSData(contentsOfFile: file) {
                                if cert1.isEqual(to: cert2 as Data) { completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Pinning failed completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }*/

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


