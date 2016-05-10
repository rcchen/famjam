//
//  Reducers.swift
//  FamJam
//
//  Created by Roger Chen on 5/7/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()
        
        switch action {
        case let action as SetUser:
            state.user = action.user
        case let action as SetUserFamilies:
            state.userFamilies = action.userFamilies
        case let action as SetCurrentTopic:
            state.currentTopic = action.currentTopic
        default:
            break
        }
        
        return state
    }
}