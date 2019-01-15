import WordPressKit

// MARK: - WordPressComServiceRemote (Site Segments)

/// Describes the errors that could arise when searching for site verticals.
///
/// - requestEncodingFailure:   unable to encode the request parameters.
/// - responseDecodingFailure:  unable to decode the server response.
/// - serviceFailure:           the service returned an unexpected error.
///
enum SiteSegmentsError: Error {
    case requestEncodingFailure
    case responseDecodingFailure
    case serviceFailure
}

/// Advises the caller of results related to requests for site verticals.
///
/// - success: the site verticals request succeeded with the accompanying result.
/// - failure: the site verticals request failed due to the accompanying error.
///
//enum SiteSegmentsResult {
//    case success([SiteSegment])
//    case failure(SiteSegmentsError)
//}
//typealias SiteSegmentsServiceCompletion = ((SiteVerticalsResult) -> ())

extension WordPressComServiceRemote {
    func retrieveSegments(completion: @escaping SiteSegmentsServiceCompletion) {
        print("===== firing request to service in Wordpresscomserviceremote")
        let endpoint = "verticals"
        let remotePath = path(forEndpoint: endpoint, withVersion: ._2_0)

        wordPressComRestApi.GET(
            remotePath,
            parameters: nil,
            success: { [weak self] responseObject, httpResponse in
                DDLogInfo("\(responseObject) | \(String(describing: httpResponse))")

                guard let self = self else {
                    return
                }

                do {
                    let response = try self.decodeResponse(responseObject: responseObject)
                    print("==== success =====")
                    print(response)
                    print("///// success ===== ")
                    //completion(.success(response))
                } catch {
                    DDLogError("Failed to decode \([SiteVertical].self) : \(error.localizedDescription)")
                    //completion(.failure(SiteVerticalsError.responseDecodingFailure))
                }
            },
            failure: { error, httpResponse in
                DDLogError("\(error) | \(String(describing: httpResponse))")
                //completion(.failure(SiteVerticalsError.serviceFailure))
        })
    }

    private func decodeResponse(responseObject: AnyObject) throws -> [SiteSegment] {
        let decoder = JSONDecoder()
        let data = try JSONSerialization.data(withJSONObject: responseObject, options: [])
        let response = try decoder.decode([SiteSegment].self, from: data)

        return response
    }
}
