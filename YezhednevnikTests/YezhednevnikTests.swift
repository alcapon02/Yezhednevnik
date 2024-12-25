//
//  YezhednevnikTests.swift
//  YezhednevnikTests
//
//  Created by Александр Шастик on 15.12.2024.
//

import XCTest
import EventKit
@testable import Yezhednevnik

final class YezhednevnikTests: XCTestCase {
    var calendarVC: CalendarViewController!
    var mockEventStore: EKEventStore!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        calendarVC = CalendarViewController()
        mockEventStore = EKEventStore()
        calendarVC.eventStore = mockEventStore
        removeAllEvents()
    }

    
    override func tearDown() {
        removeAllEvents()
        calendarVC = nil
        mockEventStore = nil
        super.tearDown()
    }

    
    func testEventsForDateReturnsCorrectCount() {
        // Arrange
        let date = Date()
        removeAllEvents() // Очищаем хранилище событий перед тестом
        
        let event1 = EKEvent(eventStore: mockEventStore)
        event1.startDate = date
        event1.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: date)
        event1.title = "Test Event 1"
        event1.calendar = mockEventStore.defaultCalendarForNewEvents
        
        let event2 = EKEvent(eventStore: mockEventStore)
        event2.startDate = date
        event2.endDate = Calendar.current.date(byAdding: .hour, value: 2, to: date)
        event2.title = "Test Event 2"
        event2.calendar = mockEventStore.defaultCalendarForNewEvents
        
        try! mockEventStore.save(event1, span: .thisEvent)
        try! mockEventStore.save(event2, span: .thisEvent)
        
        // Act
        let events = calendarVC.eventsForDate(date)
        
        // Assert
        XCTAssertEqual(events.count, 2, "Expected 2 events, but got \(events.count)")
    }
    
    func testCreateNewEventSetsCorrectProperties() {
        // Arrange
        let date = Date()
        let expectedEndDate = Calendar.current.date(byAdding: .hour, value: 1, to: date)!
        
        // Act
        let newEvent = calendarVC.createNewEvent(at: date)
        
        // Assert
        let tolerance: TimeInterval = 1.0 // Допустимая погрешность в секундах
        XCTAssertEqual(
            newEvent.ekEvent.startDate.timeIntervalSince1970,
            date.timeIntervalSince1970,
            accuracy: tolerance,
            "Start date is not set correctly."
        )
        
        XCTAssertEqual(
            newEvent.ekEvent.endDate.timeIntervalSince1970,
            expectedEndDate.timeIntervalSince1970,
            accuracy: tolerance,
            "End date is not set correctly."
        )
    }
    
    func testEditEvent() {
        // Arrange
        let date = Date()
        let newEvent = calendarVC.createNewEvent(at: date)
        
        // Act
        newEvent.ekEvent.title = "Edited Event"
        try! mockEventStore.save(newEvent.ekEvent, span: .thisEvent)
        
        // Assert
        XCTAssertEqual(newEvent.ekEvent.title, "Edited Event", "Event title was not edited correctly.")
    }
    
    private func removeAllEvents() {
        let startDate = Date.distantPast
        let endDate = Date.distantFuture
        let predicate = mockEventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let allEvents = mockEventStore.events(matching: predicate)

        print("Removing \(allEvents.count) events from mockEventStore...")
        allEvents.forEach { event in
            do {
                try mockEventStore.remove(event, span: .thisEvent)
            } catch {
                print("Error removing event: \(error)")
            }
        }
    }

}
