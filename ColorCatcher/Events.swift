//
//  Events.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 29/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import Foundation

enum Event: String {
    
    case FirstLaunch,
    SkippedIntro,
    AllowedCamera,
    AllowedLocation,
    // WelcomeVC
    RaceModeTapped,
    DiscoveryModeTapped,
    MultiplayerTapped,
    SettingsTapped,
    CollectionTapped,
    ChameleonTapped,
    // SettingsVC
    WelcomeAnimationTurnedOn,
    WelcomeAnimationTurnedOff,
    MultiplayerNameChanged,
    RankingTapped,
    ShareTapped,
    WatchTourAgainTapped,
    CreditsTapped,
    // CollectionVC
    ColorTapped,
    ColorUncatchedTapped,
    CollectionScrolledToEnd,
    //
    FlashOpened,
    //
    RaceColorCatched,
    RaceSkippedColor,
    //
    DiscoveryColorCatched,
    DiscoveryFlashOpened,
    DiscoveryCompleted,
    //
    MultiplayerColorCatched,
    MultiplayerSkippedColor,
    MultiplayerGameWon,
    MultiplayerGameLost,
    MultiplayerGameDisconnected,
    MultiplayerRoomCreated,
    MultiplayerInviteSent,
    MultiplayerInviteReceived,
    MultiplayerInviteAccepted,
    MultiplayerInviteRefused,
    MultiplayerDisconnected,
    //
    TestEvent
}
