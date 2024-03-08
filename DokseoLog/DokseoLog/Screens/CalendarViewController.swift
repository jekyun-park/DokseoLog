//
//  CalendarViewController.swift
//  DokseoLog
//
//  Created by 박제균 on 2023/08/11.
//

import FSCalendar
import Toast
import UIKit

// MARK: - CalendarViewController

class CalendarViewController: UIViewController {

  // MARK: Internal

  var recordDates: [Date] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    getRecords()
    configureCalendarView()
    configureNavigationController()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getRecords()
  }

  // MARK: Private

  private lazy var calendar: FSCalendar = {
    let width = self.view.bounds.width
    let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 450 : 300

    let rect = CGRect(x: 0, y: 150, width: width, height: height)
    let calendar = FSCalendar(frame: CGRect(x: 0, y: 150, width: width, height: height))
    calendar.delegate = self
    calendar.dataSource = self
    return calendar
  }()

  private func configureCalendarView() {
    view.addSubview(calendar)
    calendar.scope = .month
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.allowsMultipleSelection = false
    calendar.placeholderType = .none

    // appearance
    calendar.appearance.headerTitleFont = UIFont(name: Fonts.HanSansNeo.bold.description, size: 16)
    calendar.appearance.headerDateFormat = "YYYY년 MM월"
    calendar.appearance.headerTitleColor = .label
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.appearance.headerTitleOffset = CGPoint(x: 0, y: -10)

    calendar.appearance.selectionColor = .secondaryLabel
    calendar.appearance.eventDefaultColor = .green
    calendar.appearance.eventSelectionColor = .green
    calendar.appearance.todayColor = nil
    calendar.appearance.titleTodayColor = .systemBlue
    calendar.appearance.weekdayFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 14)
    calendar.appearance.weekdayTextColor = .label
    calendar.appearance.titleFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 14)
    calendar.appearance.titleWeekendColor = .red

    calendar.appearance.borderRadius = 0.0
    calendar.appearance.eventOffset = CGPoint(x: 0, y: -8)
  }

  private func configureNavigationController() {
    navigationController?.navigationBar.prefersLargeTitles = false
    guard let font = UIFont(name: Fonts.HanSansNeo.medium.description, size: 18) else { return }
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: font]
  }

  private func getRecords() {
    recordDates.removeAll()
    let sentencesResult = PersistenceManager.shared.fetchSentences()
    switch sentencesResult {
    case .success(let sentences):
      for sentence in sentences {
        recordDates.append(sentence.createdAt)
      }
    case .failure(let error):
      var style = ToastStyle()
      style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
      style.backgroundColor = .systemRed
      view.makeToast(error.description, duration: 1, position: .center, style: style)
    }

    let thoughtsResult = PersistenceManager.shared.fetchThoughts()
    switch thoughtsResult {
    case .success(let thoughts):
      for thought in thoughts {
        recordDates.append(thought.createdAt)
      }
    case .failure(let error):
      var style = ToastStyle()
      style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
      style.backgroundColor = .systemRed
      view.makeToast(error.description, duration: 1, position: .center, style: style)
    }
    calendar.reloadData()
  }

}

// MARK: FSCalendarDelegate

extension CalendarViewController: FSCalendarDelegate {

  func calendar(_: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
    let result = PersistenceManager.shared.fetchRecords(date)
    switch result {
    case .success(let results):
      if !(results.sentences.isEmpty && results.thoughts.isEmpty) {
        let viewController = DateRecordViewController(date: date)
        navigationController?.pushViewController(viewController, animated: true)
      } else {
        var style = ToastStyle()
        style.messageFont = UIFont(name: Fonts.HanSansNeo.medium.description, size: 16)!
        style.backgroundColor = .systemRed
        view.makeToast("해당 날짜에 기록이 없습니다.", duration: 1, position: .center, style: style)
      }
    case .failure(let error):
      presentDLAlert(title: "불러올 수 없습니다.", message: error.description, buttonTitle: "확인")
    }
  }

  func calendar(_: FSCalendar, shouldDeselect _: Date, at _: FSCalendarMonthPosition) -> Bool {
    true
  }

}

// MARK: FSCalendarDataSource

extension CalendarViewController: FSCalendarDataSource {

  func calendar(_: FSCalendar, numberOfEventsFor date: Date) -> Int {
    if recordDates.contains(where: { $0.isSameDay(date) }) {
      1
    } else {
      0
    }
  }

}
