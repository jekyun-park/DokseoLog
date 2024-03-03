//
//  PersistenceManager.swift
//  Bookie
//
//  Created by 박제균 on 2/7/24.
//

import CoreData
import Foundation

// MARK: - PersistenceManager

final class PersistenceManager {

  // MARK: Lifecycle

  private init() { }

  // MARK: Internal

  static let shared = PersistenceManager()

  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "Bookie")
    container.loadPersistentStores { _, error in
      if let error {
        fatalError("NSPersistentCloudKitContainer에서 에러가 발생함")
      }
    }
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return container
  }()

}

extension PersistenceManager {

  /// 내 책장에 도서를 추가합니다.
  func addToBookCase(book: Book) throws {
    let managedContext = persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MyBookEntity", in: managedContext) else {
      throw BKError.failToSaveData
    }

    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), book.isbn13)
    request.predicate = predicate

    // isbn으로 검색하여 중복도서가 존재한다면 저장을 하지 않음
    guard try managedContext.fetch(request).isEmpty else {
      throw BKError.duplicatedData
    }

    let myBook = NSManagedObject(entity: entity, insertInto: managedContext)

    myBook.setValuesForKeys([
      "title": book.title,
      "link": book.link,
      "publishedAt": book.publishedAt,
      "publisher": book.publisher,
      "isbn13": book.isbn13,
      "totalPage": book.page ?? 0,
      "coverURL": book.coverURL,
      "bookDescription": book.description,
      "author": book.author,
      "isInWishList": false,
      "isFinished": false,
    ])

    do {
      try managedContext.save()
    } catch {
      throw BKError.failToSaveData
    }
  }

  /// 위시리스트에 도서를 저장합니다.
  func addToWishList(book: Book) throws {
    let managedContext = persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MyBookEntity", in: managedContext) else {
      throw BKError.failToSaveData
    }

    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), book.isbn13)
    request.predicate = predicate

    // isbn으로 검색하여 중복도서가 존재한다면 저장을 하지 않음
    let result = try managedContext.fetch(request) as? [MyBookEntity] ?? []
    guard result.isEmpty else {
      throw BKError.duplicatedData
    }

    let myBook = NSManagedObject(entity: entity, insertInto: managedContext)

    myBook.setValuesForKeys([
      "title": book.title,
      "link": book.link,
      "publishedAt": book.publishedAt,
      "publisher": book.publisher,
      "isbn13": book.isbn13,
      "totalPage": book.page ?? 0,
      "coverURL": book.coverURL,
      "bookDescription": book.description,
      "author": book.author,
      "isInWishList": true,
      "isFinished": false,
    ])

    do {
      try managedContext.save()
    } catch {
      throw BKError.failToSaveData
    }
  }

  /// 책들을 불러옵니다.
  func fetchMyBooks() throws -> [MyBookEntity] {
    var result: [MyBookEntity] = []
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isInWishList), NSNumber(value: false))

    request.predicate = predicate
    do {
      result = try managedContext.fetch(request) as? [MyBookEntity] ?? []
    } catch {
      throw BKError.failToFetchData
    }

    return result
  }

  /// 위시리스트의 책들을 불러옵니다.
  func fetchWishList() throws -> [MyBookEntity] {
    var result: [MyBookEntity] = []
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isInWishList), NSNumber(value: true))

    request.predicate = predicate

    do {
      result = try managedContext.fetch(request) as? [MyBookEntity] ?? []
    } catch {
      throw BKError.failToFetchData
    }
    return result
  }

  func moveToBookCase(book: Book) -> Result<Void, BKError> {
    let managedContext = persistentContainer.viewContext

    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), book.isbn13)
    request.predicate = predicate

    do {
      guard let objectToUpdate = try managedContext.fetch(request).first else {
        errorLog("업데이트할 객체를 찾지 못했습니다.")
        return .failure(.failToUpdateData)
      }
      objectToUpdate.setValue(false, forKey: "isInWishList")
    } catch {
      return .failure(.failToUpdateData)
    }

    return .success(())
  }

  func addSentence(sentence: Sentence) throws {
    let managedContext = persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MySentenceEntity", in: managedContext) else {
      throw BKError.failToSaveData
    }
    let mySentence = NSManagedObject(entity: entity, insertInto: managedContext)

    var bookEntity: [MyBookEntity]
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), sentence.book.isbn13)
    request.predicate = predicate

    do {
      let objects = try managedContext.fetch(request)
      bookEntity = objects as? [MyBookEntity] ?? []
    } catch (let error) {
      print("여기에요 여기 ~! : \(error)")
      throw BKError.failToFetchData
    }

    let book = bookEntity.first
    mySentence.setValuesForKeys([
      "book": book!,
      "createdAt": sentence.createdAt,
      "memo": sentence.memo,
      "page": sentence.page,
      "sentenceID": sentence.id,
    ])

    do {
      try managedContext.save()
    } catch {
      print("여기에요 여기 ~! : \(error)")
      throw BKError.failToSaveData
    }
  }

  func fetchSentences(_ book: Book) -> Result<[Sentence], BKError> {
    var result: [Sentence] = []
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MySentenceEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MySentenceEntity.book.isbn13), book.isbn13)
    let sortDescriptor = NSSortDescriptor(key: #keyPath(MySentenceEntity.createdAt), ascending: false)
    request.predicate = predicate
    request.sortDescriptors = [sortDescriptor]

    do {
      let fetched = try managedContext.fetch(request) as? [MySentenceEntity] ?? []
      result = fetched.map {
        Sentence(
          book: book,
          page: Int($0.page),
          memo: $0.memo ?? "내용을 찾을 수 없습니다.",
          id: $0.sentenceID!,
          createdAt: $0.createdAt!)
      }
      return .success(result)
    } catch {
      return .failure(.failToFetchData)
    }
  }

  /// 문장을 업데이트
  /// 1) Entity의 Predicate를 사용하여 요청을 생성
  /// 2) 레코드를 가져오고 키로 새 값을 설정
  /// 3) 마지막 저장 컨텍스트는 데이터 생성과 동일
  func updateSentence(_ sentence: Sentence) -> Result<Void, BKError> {
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MySentenceEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MySentenceEntity.sentenceID), sentence.id as CVarArg)
    request.predicate = predicate

    do {
      guard let objectToUpdate = try managedContext.fetch(request).first else {
        errorLog("업데이트할 객체를 찾지 못했습니다.")
        return .failure(.failToUpdateData)
      }

      objectToUpdate.setValue(sentence.page, forKey: "page")
      objectToUpdate.setValue(sentence.memo, forKey: "memo")

      do {
        try managedContext.save()
      } catch {
        errorLog("업데이트 내용 저장에 실패했습니다.")
        return .failure(.failToSaveData)
      }

    } catch {
      errorLog("업데이트 내용 저장에 실패했습니다. - 2")
      return .failure(.failToUpdateData)
    }

    return .success(())
  }

  func addThought(_ thought: Thought) throws {
    let managedContext = persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MyThoughtEntity", in: managedContext) else {
      errorLog("생각 저장 엔티티를 생성하는데 실패함")
      throw BKError.failToSaveData
    }

    let myThought = NSManagedObject(entity: entity, insertInto: managedContext)

    var bookEntity: [MyBookEntity]
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), thought.book.isbn13)
    request.predicate = predicate

    do {
      let objects = try managedContext.fetch(request)
      bookEntity = objects as? [MyBookEntity] ?? []
    } catch {
      errorLog("생각 저장 을 위한 책 객체를 가져오는데 실패함")
      throw BKError.failToFetchData
    }

    let book = bookEntity.first

    myThought.setValuesForKeys([
      "book": book!,
      "createdAt": thought.createdAt,
      "memo": thought.memo,
      "thoughtID": thought.id,
    ])

    do {
      try managedContext.save()
    } catch (let error) {
      print(error)
      errorLog("생각 저장에 실패함")
      throw BKError.failToSaveData
    }
  }

  // 최신순 sort필요
  func fetchThoughts(_ book: Book) -> Result<[Thought], BKError> {
    var result: [Thought] = []
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyThoughtEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyThoughtEntity.book.isbn13), book.isbn13)
    let sortDescriptor = NSSortDescriptor(key: #keyPath(MyThoughtEntity.createdAt), ascending: false)
    request.predicate = predicate
    request.sortDescriptors = [sortDescriptor]

    do {
      let fetched = try managedContext.fetch(request) as? [MyThoughtEntity] ?? []
      result = fetched.map {
        Thought(
          book: book,
          memo: $0.memo ?? "내용을 찾을 수 없습니다.",
          id: $0.thoughtID!,
          createdAt: $0.createdAt!)
      }
      return .success(result)
    } catch {
      return .failure(.failToFetchData)
    }
  }

  // 생각을 업데이트
  func updateThought(_ thought: Thought) -> Result<Void, BKError> {
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyThoughtEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyThoughtEntity.thoughtID), thought.id as CVarArg)
    request.predicate = predicate

    do {
      guard let objectToUpdate = try managedContext.fetch(request).first else {
        errorLog("생각 저장 을 위한 책 객체를 fetch 실패함")
        return .failure(.failToUpdateData)
      }
      objectToUpdate.setValue(thought.memo, forKey: "memo")

      do {
        try managedContext.save()
      } catch {
        errorLog("생각 업데이트 실패")
        return .failure(.failToSaveData)
      }

    } catch {
      errorLog("생각 업뎃을 위한 thought 객체를 가져오는데 실패함")
      return .failure(.failToUpdateData)
    }

    return .success(())
  }

  /// 특정 도서를 삭제합니다.
  func deleteBook(_ book: Book) -> Result<Void, BKError> {
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), book.isbn13)
    request.predicate = predicate

    do {
      guard let object = try managedContext.fetch(request).first else { return .failure(.failToFetchData) }
      managedContext.delete(object)
      try managedContext.save()
    } catch {
      errorLog("도서 삭제를 위한 도서 객체를 가져오는데 실패함")
      return .failure(.failToDeleteData)
    }

    return .success(())
  }

  /// 특정 문장을 삭제합니다.
  func deleteSentence(_ sentence: Sentence) -> Result<Void, BKError> {
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MySentenceEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MySentenceEntity.sentenceID), sentence.id as CVarArg)
    request.predicate = predicate

    do {
      guard let objectToDelete = try managedContext.fetch(request).first else {
        print("여기?-1")
        return .failure(.failToDeleteData)
      }
      do {
        managedContext.delete(objectToDelete)
        try managedContext.save()
      } catch {
        print("여기??-2")
        return .failure(.failToDeleteData)
      }
    } catch {
      print("여기?-3")
      return .failure(.failToDeleteData)
    }
    return .success(())
  }

  func deleteThought(_ thought: Thought) -> Result<Void, BKError> {
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyThoughtEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyThoughtEntity.thoughtID), thought.id as CVarArg)
    request.predicate = predicate

    do {
      guard let objectToDelete = try managedContext.fetch(request).first else { return .failure(.failToDeleteData) }

      do {
        managedContext.delete(objectToDelete)
        try managedContext.save()
      } catch {
        return .failure(.failToDeleteData)
      }
    } catch {
      return .failure(.failToDeleteData)
    }

    return .success(())
  }

}

func errorLog(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line) {
  let fileName = file.split(separator: "/").last ?? ""
  let functionName = function.split(separator: "(").first ?? ""
  print("🤬 [\(fileName)] \(functionName)(\(line)): \(msg)")
}
