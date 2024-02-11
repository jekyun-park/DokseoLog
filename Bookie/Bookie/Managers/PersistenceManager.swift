//
//  PersistenceManager.swift
//  Bookie
//
//  Created by 박제균 on 2/7/24.
//

import CoreData
import Foundation

final class PersistenceManager {

  private init() { }
  static let shared = PersistenceManager()

  lazy var persistentContainer : NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "Bookie")
    container.loadPersistentStores { _, error in
      if let error {
        fatalError("NSPersistentCloudKitContainer에서 에러가 발생함")
      }
    }

    return container
  }()

}

extension PersistenceManager {

  func addToBookCase(book: Book) throws {

    let managedContext = self.persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MyBook", in: managedContext) else {
      throw BKError.failToSaveData
    }
    let myBook = NSManagedObject(entity: entity, insertInto: managedContext)

    myBook.setValuesForKeys([
      "title": book.title,
      "publisher": book.publisher,
      "isbn13": book.isbn13,
      "page": book.subInfo?.itemPage ?? 0,
      "coverURL": book.coverURL,
      "bookDescription": book.description,
      "author": book.author,
      "isInWishList": false
    ])

    do {
      try managedContext.save()
    } catch {
      throw BKError.failToSaveData
    }
  }

  func addToBookBascket(book: Book) throws {

    let managedContext = self.persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "MyBook", in: managedContext) else {
      throw BKError.failToSaveData
    }
    let myBook = NSManagedObject(entity: entity, insertInto: managedContext)

    myBook.setValuesForKeys([
      "title": book.title,
      "publisher": book.publisher,
      "isbn13": book.isbn13,
      "page": book.subInfo?.itemPage ?? 0,
      "coverURL": book.coverURL,
      "bookDescription": book.description,
      "author": book.author,
      "isInWishList": true
    ])

    do {
      try managedContext.save()
    } catch {
      throw BKError.failToSaveData
    }
  }

  /// 책들을 불러옵니다.
  func fetchBooks() throws -> [NSManagedObject] {
    var result: [NSManagedObject] = []
    let managedContext = self.persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBook")
    do {
      result = try managedContext.fetch(request)
    } catch {
      throw BKError.failToFetchData
    }
    return result
  }

  /// 책바구니의 책들을 불러옵니다.
  func fetchWishListBooks() throws -> [NSManagedObject] {
    var result: [NSManagedObject] = []
    let managedContext = self.persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "MyBook")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(MyBook.isInWishList), true)

    request.predicate = predicate

    do {
      result = try managedContext.fetch(request)
    } catch {
      throw BKError.failToFetchData
    }
    return result
  }

  /// 문장을 업데이트
  /// 1) Entity의 Predicate를 사용하여 요청을 생성
  /// 2) 레코드를 가져오고 키로 새 값을 설정
  /// 3) 마지막 저장 컨텍스트는 데이터 생성과 동일
  func updateSentence(_ sentence: Sentence, page: Int, memo: String) throws {
    let managedContext = self.persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "Sentence")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(Sentence.sentenceID), sentence.sentenceID! as CVarArg)
    request.predicate = predicate

    do {
      guard let objectToUpdate = try managedContext.fetch(request).first else { return }
      objectToUpdate.setValue(sentence.page, forKey: "page")
      objectToUpdate.setValue(sentence.memo, forKey: "memo")
      
      do {
        try managedContext.save()
      } catch {
        throw BKError.failToSaveData
      }

    } catch {
      throw BKError.failToUpdateData
    }

  }

  // 생각을 업데이트
  func updateThought(_ thought: Thought, memo: String) throws {
    let managedContext = self.persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "Thought")
    let predicate = NSPredicate(format: "%K == %@", #keyPath(Thought.thoughtID), thought.thoughtID! as CVarArg)
    request.predicate = predicate

    do {
      guard let objectToUpdate = try managedContext.fetch(request).first else { return }
      objectToUpdate.setValue(thought.memo, forKey: "memo")

      do {
        try managedContext.save()
      } catch {
        throw BKError.failToSaveData
      }

    } catch {
      throw BKError.failToUpdateData
    }
  }

  /// 특정 도서를 삭제합니다.
  func deleteBook(_ book: NSManagedObject) throws {
    let managedContext = self.persistentContainer.viewContext

    do {
      managedContext.delete(book)
      try managedContext.save()
    } catch {
      throw BKError.failToDeleteData
    }
  }

}
