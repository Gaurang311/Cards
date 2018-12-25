//
//  CardDetail.swift
//
//  Created by Gaurang Lathiya on 25/12/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CardDetail: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let comments = "comments"
    static let message = "message"
    static let id = "id"
    static let userId = "user_id"
    static let image = "image"
  }

  // MARK: Properties
  public var comments: [Comments]?
  public var message: String?
  public var id: Int?
  public var userId: Int?
  public var image: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    if let items = json[SerializationKeys.comments].array { comments = items.map { Comments(json: $0) } }
    message = json[SerializationKeys.message].string
    id = json[SerializationKeys.id].int
    userId = json[SerializationKeys.userId].int
    image = json[SerializationKeys.image].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = comments { dictionary[SerializationKeys.comments] = value.map { $0.dictionaryRepresentation() } }
    if let value = message { dictionary[SerializationKeys.message] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    if let value = image { dictionary[SerializationKeys.image] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.comments = aDecoder.decodeObject(forKey: SerializationKeys.comments) as? [Comments]
    self.message = aDecoder.decodeObject(forKey: SerializationKeys.message) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.userId = aDecoder.decodeObject(forKey: SerializationKeys.userId) as? Int
    self.image = aDecoder.decodeObject(forKey: SerializationKeys.image) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(comments, forKey: SerializationKeys.comments)
    aCoder.encode(message, forKey: SerializationKeys.message)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(userId, forKey: SerializationKeys.userId)
    aCoder.encode(image, forKey: SerializationKeys.image)
  }

}
