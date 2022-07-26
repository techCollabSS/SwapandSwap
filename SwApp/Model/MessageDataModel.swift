//
//  MessageDataModel.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/25/22.
//
import Foundation

// Data structure
struct MessagesStructure: Identifiable {
    var id = UUID()
    var unreadIndicator: String
    var avatar: String
    var name: String
    var messageSummary: String
    var timestamp: String
}

// Data storage
let MessageData = [
    MessagesStructure(unreadIndicator: "unreadIndicator", avatar: "jared", name: "Jared", messageSummary: "That's great, I can help you with that! What type of product are you...", timestamp: "13:30 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "martin", name: "Martin Steed", messageSummary: "I don't know why people are so anti pineapple pizza. I kind of like it.", timestamp: "12:40 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "jeroen", name: "Zach Friedman", messageSummary: "(Sad fact: you cannot search for a gif of the word “gif”, just gives you gifs.)", timestamp: "11:00 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "carla", name: "Kyle & Aaron", messageSummary: "There's no way you'll be able to jump your motorcycle over that bus.", timestamp: "10:36 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "zain", name: "Dee McRobie", messageSummary: "Tabs make way more sense than spaces. Convince me I'm wrong. LOL.", timestamp: "9:59 AM"),
    MessagesStructure(unreadIndicator: "unreadIndicator", avatar: "cooper", name: "Gary Butcher", messageSummary: "(Sad fact: you cannot search for a gif of the word “gif”, just gives you gifs.)", timestamp: "9:26 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "fra", name: "Francesco", messageSummary: "I don't know why people are so anti pineapple pizza. I kind of like it.", timestamp: "9:20 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "luke", name: "Luke", messageSummary: "There's no way you'll be able to jump your motorcycle over that bus.", timestamp: "9:16 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "maren", name: "Ama Aboakye", messageSummary: "Tabs make way more sense than spaces. Convince me I'm wrong. LOL.", timestamp: "9:00 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "carla", name: "Adwoa Forson", messageSummary: "That's what I'm talking about!", timestamp: "8:59 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "ruben", name: "Kofi Mensah", messageSummary: "(Sad fact: you cannot search for a gif of the word “gif”, just gives you gifs.)", timestamp: "8:51 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "amos", name: "Amos G.", messageSummary: "Maybe email isn't the best form of communication.", timestamp: "9:36 AM"),
    MessagesStructure(unreadIndicator: "unreadIndicator", avatar: "maren", name: "Maren Yustiono", messageSummary: "There's no way you'll be able to jump your motorcycle over that bus.", timestamp: "8:50 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "george", name: "Martin Yustiono", messageSummary: "That's what I'm talking about!", timestamp: "8:45 AM"),
    MessagesStructure(unreadIndicator: "", avatar: "cooper", name: "Zain Snowman", messageSummary: "(Sad fact: you cannot search for a gif of the word “gif”, just gives you gifs.)", timestamp: "8:40 AM"),
    MessagesStructure(unreadIndicator: "unreadIndicator", avatar: "ruben", name: "Kipling West King", messageSummary: "Maybe email isn't the best form of communication.", timestamp: "8:36 AM")
]
