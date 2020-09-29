//
//  FakeDataGenerator.swift
//  fintech_chat
//
//  Created by Макбук on 27.09.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class FakeDataGenerator{
    let conversations = [
        [
            ConversationCellModel(name: "Steve Jobs", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: Date().addingTimeInterval(-60), isOnline: true, hasUnreadMessages: true, avatar: #imageLiteral(resourceName: "steve-jobs")),
            ConversationCellModel(name: "William Gates", message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis", date: Date().addingTimeInterval(-60*2), isOnline: true, hasUnreadMessages: false, avatar: #imageLiteral(resourceName: "william_gates")),
            ConversationCellModel(name: "Stephen Wozniak", message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.", date: Date().addingTimeInterval(-60*15), isOnline: true, hasUnreadMessages: false, avatar: #imageLiteral(resourceName: "stephen_wozniak")),
            ConversationCellModel(name: "Barack Obama", message: "Voluptate irure aliquip consectetur commodo ex ex.", date: Date().addingTimeInterval(-60*35), isOnline: true, hasUnreadMessages: false),
            ConversationCellModel(name: "Donald Trump", message: "Voluptate irure aliquip consectetur commodo ex ex.", date: Date().addingTimeInterval(-60*60), isOnline: true, hasUnreadMessages: true),
            ConversationCellModel(name: "Mark Zuckerberg", message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", date: Date().addingTimeInterval(-60*60*2), isOnline: true, hasUnreadMessages: false),
            ConversationCellModel(name: "Angela Merkel", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: Date().addingTimeInterval(-86400), isOnline: true, hasUnreadMessages: true),
            ConversationCellModel(name: "Elon Musk", message: "Voluptate irure aliquip consectetur commodo ex ex.", date: Date().addingTimeInterval(-86400*2), isOnline: true, hasUnreadMessages: false),
            ConversationCellModel(name: "Timothy Cook", message: "", date: Date().addingTimeInterval(-86400*3), isOnline: true, hasUnreadMessages: false),
            ConversationCellModel(name: "Ronald Wayne", message: "", date: Date().addingTimeInterval(-86400*3), isOnline: true, hasUnreadMessages: false),
        ],
        [
            ConversationCellModel(name: "Hermann Gräf", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing.", date: Date().addingTimeInterval(-60), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Oleg Tinkov", message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis", date: Date().addingTimeInterval(-60*10), isOnline: false, hasUnreadMessages: true),
            ConversationCellModel(name: "Vladimir Putin", message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.", date: Date().addingTimeInterval(-60*15), isOnline: false, hasUnreadMessages: true),
            ConversationCellModel(name: "Dmitry Medvedev", message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", date: Date().addingTimeInterval(-60*20), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Mikhail Mishustin", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing.", date: Date().addingTimeInterval(-60*60*2), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Boris Yeltsin", message: "Japan looks amazing!", date: Date().addingTimeInterval(-60*60*2), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Mikhail Gorbachev", message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis", date: Date().addingTimeInterval(-86400), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Yevgeny Kaspersky", message: "Voluptate irure aliquip consectetur commodo ex ex.", date: Date().addingTimeInterval(-86400*2), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "David Yang", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: Date().addingTimeInterval(-86400*3), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Andrey Akinshin", message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis", date: Date().addingTimeInterval(-86400*3), isOnline: false, hasUnreadMessages: false),
        ],
    ]
    
    let messages = [
           MessageCellModel(text: "1. Hello! How are you? What is the most popular meal in Japan? Hello! How are you? What is the most popular meal in Japan?", direction: .input),
           MessageCellModel(text: "Do you like it?",
                            direction: .input),
           MessageCellModel(text: "Hi! Im fine. How are you? Yep, i like it!!!!",
                            direction: .output),
           MessageCellModel(text: "2. Hello! How are you? What is the most popular meal in Japan? Hello! How are you? What is the most popular meal in Japan?", direction: .input),
           MessageCellModel(text: "Do you like it?",
                            direction: .input),
           MessageCellModel(text: "Hi! Im fine. How are you? Yep, i like it!!!!",
           direction: .output),
           MessageCellModel(text: "3. Hello! How are you? What is the most popular meal in Japan? Hello! How are you? What is the most popular meal in Japan?", direction: .input),
           MessageCellModel(text: "Do you like it?",
                            direction: .input),
           MessageCellModel(text: "Hi! Im fine. How are you? Yep, i like it!!!!",
           direction: .output),
           MessageCellModel(text: "4. Hello! How are you? What is the most popular meal in Japan? Hello! How are you? What is the most popular meal in Japan?", direction: .input),
           MessageCellModel(text: "Do you like it?",
                            direction: .input),
           MessageCellModel(text: "Hi! Im fine. How are you? Yep, i like it!!!!",
           direction: .output),
           MessageCellModel(text: "5. Hello! How are you? What is the most popular meal in Japan? Hello! How are you? What is the most popular meal in Japan?", direction: .input),
           MessageCellModel(text: "Do you like it?",
                            direction: .input),
           MessageCellModel(text: "Hi! Im fine. How are you? Yep, i like it!!!!",
           direction: .output),
       ]
    
    // MARK: - Get conversations
    
    func getFriends() -> [[ConversationCellModel]]{
        return conversations
    }
    
    func getDefaulModel() -> ConversationCellModel{
        return ConversationCellModel(name: "Default name", message: "", date: Date(), isOnline: false, hasUnreadMessages: false)
    }
    
    // MARK: = Get messages
    
    func getMessages() -> [MessageCellModel]{
        return messages
    }
    
    func getDefaultMessage() -> MessageCellModel{
        return MessageCellModel(text: "Default Text", direction: .input)
    }
}
