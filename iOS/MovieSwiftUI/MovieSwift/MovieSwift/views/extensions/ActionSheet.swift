//
//  ActionSheet.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import common

extension ActionSheet {
    static func wishlistButton(store: ObservableStore<AppState>, movie: String, onTrigger: (() -> Void)?) -> Alert.Button {
        if store.state.moviesState.wishlist.contains(movie) {
            let wishlistButton: Alert.Button = .destructive(Text("Remove from wishlist")) {
                store.dispatch(MoviesActions.RemoveFromWishlist(movie: movie))
                onTrigger?()
            }
            return wishlistButton
        } else {
            let wishlistButton: Alert.Button = .default(Text("Add to wishlist")) {
                store.dispatch(MoviesActions.AddToWishlist(movie: movie))
                UISelectionFeedbackGenerator().selectionChanged()
                onTrigger?()
            }
            return wishlistButton
        }
    }
    
    static func seenListButton(store: ObservableStore<AppState>, movie: String, onTrigger: (() -> Void)?) -> Alert.Button {
        if store.state.moviesState.seenlist.contains(movie) {
            let wishlistButton: Alert.Button = .destructive(Text("Remove from seenlist")) {
                store.dispatch(MoviesActions.RemoveFromSeenList(movie: movie))
                onTrigger?()
            }
            return wishlistButton
        } else {
            let wishlistButton: Alert.Button = .default(Text("Add to seenlist")) {
                store.dispatch(MoviesActions.AddToSeenList(movie: movie))
                UISelectionFeedbackGenerator().selectionChanged()
                onTrigger?()
            }
            return wishlistButton
        }
    }
    
    static func customListsButttons(store: ObservableStore<AppState>, movie: String, onTrigger: (() -> Void)?) -> [Alert.Button] {
        var buttons: [Alert.Button] = []
        for list in store.state.moviesState.customLists.compactMap({ $0.value }) {
            let list = (list as! CustomList)
            if list.movies.contains(movie) {
                let button: Alert.Button = .destructive(Text("Remove from \(list.name)")) {
                    store.dispatch(MoviesActions.RemoveMovieFromCustomList(list: list.id,
                                                                              movie: movie))
                    onTrigger?()
                }
                buttons.append(button)
            } else {
                let button: Alert.Button = .default(Text("Add to \(list.name)")) {
                    store.dispatch(MoviesActions.AddMovieToCustomList(list: list.id,
                                                                              movie: movie))
                    UISelectionFeedbackGenerator().selectionChanged()
                    onTrigger?()
                }
                buttons.append(button)
            }
        }
        return buttons
    }
    
    static func sortActionSheet(onAction: @escaping ((MoviesSort?) -> Void)) -> ActionSheet {
        let byAddedDate: Alert.Button = .default(Text("Sort by added date")) {
            onAction(MoviesSort.byaddeddate)
        }
        let byReleaseDate: Alert.Button = .default(Text("Sort by release date")) {
            onAction(MoviesSort.byreleasedate)
        }
        let byScore: Alert.Button = .default(Text("Sort by ratings")) {
            onAction(MoviesSort.byscore)
        }
        let byPopularity: Alert.Button = .default(Text("Sort by popularity")) {
            onAction(MoviesSort.bypopularity)
        }
        
        return ActionSheet(title: Text("Sort movies by"),
                           message: nil,
                           buttons: [byAddedDate, byReleaseDate, byScore, byPopularity, Alert.Button.cancel({
                            onAction(nil)
                           })])
    }
}
