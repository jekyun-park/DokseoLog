//
//  PersistenceManager.swift
//  DokseoLog
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
    let container = NSPersistentCloudKitContainer(name: "DokseoLog")
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

  /// Book 모델을 Core Data 엔티티로 저장합니다.
  func addToBookCase(book: Book) throws {
    let managedContext = persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MyBookEntity", in: managedContext) else {
      throw DLError.failToSaveData
    }

    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), book.isbn13)
    request.predicate = predicate

    // isbn으로 검색하여 중복도서가 존재한다면 저장을 하지 않음
    guard try managedContext.fetch(request).isEmpty else {
      throw DLError.duplicatedData
    }

    let myBook = NSManagedObject(entity: entity, insertInto: managedContext)

    // isInWishList 속성은 false
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
      throw DLError.failToSaveData
    }
  }

  /// Book 모델을 Core Data 엔티티로 저장합니다.
  func addToWishList(book: Book) throws {
    let managedContext = persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MyBookEntity", in: managedContext) else {
      throw DLError.failToSaveData
    }

    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), book.isbn13)
    request.predicate = predicate

    // isbn으로 검색하여 중복도서가 존재한다면 저장을 하지 않음
    let result = try managedContext.fetch(request) as? [MyBookEntity] ?? []
    guard result.isEmpty else {
      throw DLError.duplicatedData
    }

    let myBook = NSManagedObject(entity: entity, insertInto: managedContext)

    // isInWishList 속성은 true
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
      throw DLError.failToSaveData
    }
  }

  /// isInWishList 속성이 false인 내 책장의 Book 모델들을 불러옵니다.
  func fetchMyBooks() throws -> [MyBookEntity] {
    var result: [MyBookEntity] = []
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isInWishList), NSNumber(value: false))

    request.predicate = predicate
    do {
      result = try managedContext.fetch(request) as? [MyBookEntity] ?? []
    } catch {
      throw DLError.failToFetchData
    }

    return result
  }

  /// isInWishList 속성이 true인 위시리스트의 책들을 불러옵니다.
  func fetchWishList() throws -> [MyBookEntity] {
    var result: [MyBookEntity] = []
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isInWishList), NSNumber(value: true))

    request.predicate = predicate

    do {
      result = try managedContext.fetch(request) as? [MyBookEntity] ?? []
    } catch {
      throw DLError.failToFetchData
    }
    return result
  }

  /// Book 모델의 isInWishList 속성을 업데이트하여 위시리스트에서 내 책장으로 이동시킵니다.
  func moveToBookCase(book: Book) -> Result<Void, DLError> {
    let managedContext = persistentContainer.viewContext

    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), book.isbn13)
    request.predicate = predicate

    do {
      guard let objectToUpdate = try managedContext.fetch(request).first else {
        return .failure(.failToUpdateData)
      }
      objectToUpdate.setValue(false, forKey: "isInWishList")
    } catch {
      return .failure(.failToUpdateData)
    }

    return .success(())
  }

  /// Sentence 모델을 Core Data 엔티티로 추가합니다.
  func addSentence(sentence: Sentence) throws {
    let managedContext = persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MySentenceEntity", in: managedContext) else {
      throw DLError.failToSaveData
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
      throw error
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
      throw DLError.failToSaveData
    }
  }

  /// 특정 도서에 대한 Sentence 모델을 불러옵니다.
  func fetchSentences(_ book: Book) -> Result<[Sentence], DLError> {
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

  /// 특정 Date에 대한 Sentence 모델을 불러옵니다.
  func fetchRecords(_ date: Date) -> Result<(sentences: [Sentence], thoughts: [Thought]), DLError> {
    var sentenceResult: [Sentence] = []
    var thoughtResult: [Thought] = []

    let managedContext = persistentContainer.viewContext
    var request = NSFetchRequest<NSManagedObject>(entityName: "MySentenceEntity")
    var sortDescriptor = NSSortDescriptor(key: #keyPath(MySentenceEntity.createdAt), ascending: false)
    request.sortDescriptors = [sortDescriptor]

    let calendar = Calendar.current
    let startDate = calendar.startOfDay(for: date)
    guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return .failure(.invalidDate) }
    // NSFetchRequest 생성 및 NSPredicate 설정
    request.predicate = NSPredicate(format: "(createdAt >= %@) AND (createdAt < %@)", startDate as NSDate, endDate as NSDate)

    do {
      let fetched = try managedContext.fetch(request) as? [MySentenceEntity] ?? []
      sentenceResult = fetched.map {
        let book = Book(
          title: $0.book!.title!,
          link: $0.book!.link!,
          author: $0.book!.author!,
          description: $0.book!.bookDescription!,
          publishedAt: $0.book!.publishedAt!,
          isbn13: $0.book!.isbn13!,
          coverURL: $0.book!.coverURL!,
          publisher: $0.book!.publisher!,
          page: Int($0.book!.totalPage))

        return Sentence(
          book: book,
          page: Int($0.page),
          memo: $0.memo ?? "내용을 찾을 수 없습니다.",
          id: $0.sentenceID!,
          createdAt: $0.createdAt!)
      }

    } catch {
      return .failure(.failToFetchData)
    }

    request = NSFetchRequest<NSManagedObject>(entityName: "MyThoughtEntity")
    sortDescriptor = NSSortDescriptor(key: #keyPath(MyThoughtEntity.createdAt), ascending: false)
    request.sortDescriptors = [sortDescriptor]

    do {
      let fetched = try managedContext.fetch(request) as? [MyThoughtEntity] ?? []
      thoughtResult = fetched.map {
        let book = Book(
          title: $0.book!.title!,
          link: $0.book!.link!,
          author: $0.book!.author!,
          description: $0.book!.bookDescription!,
          publishedAt: $0.book!.publishedAt!,
          isbn13: $0.book!.isbn13!,
          coverURL: $0.book!.coverURL!,
          publisher: $0.book!.publisher!,
          page: Int($0.book!.totalPage))

        return Thought(
          book: book,
          memo: $0.memo ?? "내용을 찾을 수 없습니다.",
          id: $0.thoughtID!,
          createdAt: $0.createdAt!)
      }

    } catch {
      return .failure(.failToFetchData)
    }

    return .success((sentenceResult, thoughtResult))
  }

  /// 모든 Sentence 모델을 불러옵니다.
  func fetchSentences() -> Result<[Sentence], DLError> {
    var result: [Sentence] = []
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MySentenceEntity")
    let sortDescriptor = NSSortDescriptor(key: #keyPath(MySentenceEntity.createdAt), ascending: false)
    request.sortDescriptors = [sortDescriptor]

    do {
      let fetched = try managedContext.fetch(request) as? [MySentenceEntity] ?? []
      result = fetched.map {
        let book = Book(
          title: $0.book!.title!,
          link: $0.book!.link!,
          author: $0.book!.author!,
          description: $0.book!.bookDescription!,
          publishedAt: $0.book!.publishedAt!,
          isbn13: $0.book!.isbn13!,
          coverURL: $0.book!.coverURL!,
          publisher: $0.book!.publisher!,
          page: Int($0.book!.totalPage))

        return Sentence(
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

  /// Sentence 모델을 업데이트합니다.
  func updateSentence(_ sentence: Sentence) -> Result<Void, DLError> {
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MySentenceEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MySentenceEntity.sentenceID), sentence.id as CVarArg)
    request.predicate = predicate

    do {
      guard let objectToUpdate = try managedContext.fetch(request).first else {
        return .failure(.failToUpdateData)
      }

      objectToUpdate.setValue(sentence.page, forKey: "page")
      objectToUpdate.setValue(sentence.memo, forKey: "memo")

      do {
        try managedContext.save()
      } catch {
        return .failure(.failToSaveData)
      }

    } catch {
      return .failure(.failToUpdateData)
    }

    return .success(())
  }

  /// Thought 모델을 Core Data 엔티티로 추가합니다.
  func addThought(_ thought: Thought) throws {
    let managedContext = persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MyThoughtEntity", in: managedContext) else {
      throw DLError.failToSaveData
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
      throw DLError.failToFetchData
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
    } catch {
      throw DLError.failToSaveData
    }
  }

  /// 특정 도서에 대한 Thought 모델을 불러옵니다.
  func fetchThoughts(_ book: Book) -> Result<[Thought], DLError> {
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

  /// 모든 Thought 모델을 불러옵니다.
  func fetchThoughts() -> Result<[Thought], DLError> {
    var result: [Thought] = []
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyThoughtEntity")
    let sortDescriptor = NSSortDescriptor(key: #keyPath(MyThoughtEntity.createdAt), ascending: false)
    request.sortDescriptors = [sortDescriptor]
    
    do {
      let fetched = try managedContext.fetch(request) as? [MyThoughtEntity] ?? []
      result = fetched.map {
        let book = Book(
          title: $0.book!.title!,
          link: $0.book!.link!,
          author: $0.book!.author!,
          description: $0.book!.bookDescription!,
          publishedAt: $0.book!.publishedAt!,
          isbn13: $0.book!.isbn13!,
          coverURL: $0.book!.coverURL!,
          publisher: $0.book!.publisher!,
          page: Int($0.book!.totalPage))
        return Thought(book: book, memo: $0.memo ?? "내용을 찾을 수 없습니다.", id: $0.thoughtID!, createdAt: $0.createdAt!)
      }
      return .success(result)
    } catch {
      return .failure(.failToFetchData)
    }
  }

  /// Thought 모델을 업데이트합니다.
  func updateThought(_ thought: Thought) -> Result<Void, DLError> {
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyThoughtEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyThoughtEntity.thoughtID), thought.id as CVarArg)
    request.predicate = predicate

    do {
      guard let objectToUpdate = try managedContext.fetch(request).first else {
        return .failure(.failToUpdateData)
      }
      objectToUpdate.setValue(thought.memo, forKey: "memo")

      do {
        try managedContext.save()
      } catch {
        return .failure(.failToSaveData)
      }

    } catch {
      return .failure(.failToUpdateData)
    }

    return .success(())
  }

  /// 특정 도서를 삭제합니다.
  func deleteBook(_ book: Book) -> Result<Void, DLError> {
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBookEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBookEntity.isbn13), book.isbn13)
    request.predicate = predicate

    do {
      guard let object = try managedContext.fetch(request).first else { return .failure(.failToFetchData) }
      managedContext.delete(object)
      try managedContext.save()
    } catch {
      return .failure(.failToDeleteData)
    }

    return .success(())
  }

  /// 특정 문장을 제거합니다.
  func deleteSentence(_ sentence: Sentence) -> Result<Void, DLError> {
    let managedContext = persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MySentenceEntity")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MySentenceEntity.sentenceID), sentence.id as CVarArg)
    request.predicate = predicate

    do {
      guard let objectToDelete = try managedContext.fetch(request).first else {
        return .failure(.failToDeleteData)
      }
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

  /// 특정 Thought 모델을 제거합니다.
  func deleteThought(_ thought: Thought) -> Result<Void, DLError> {
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
