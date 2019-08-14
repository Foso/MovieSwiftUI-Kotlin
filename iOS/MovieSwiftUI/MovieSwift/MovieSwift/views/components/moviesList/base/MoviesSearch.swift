//
//  MoviesSearch.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import common

final class MoviesSearchPageListener: MoviesPagesListener {
    var text: String?
    
    override func loadPage() {
        if let text = text, !text.isEmpty {
            store.dispatch(movieActions.fetchSearchKeyword(query: text))
            store.dispatch(movieActions.fetchSearch(query: text, page: currentPage))
            store.dispatch(peopleActions.fetchSearch(query: text, page: currentPage))
        }
    }
}

final class MoviesSearchTextWrapper: SearchTextObservable {
    var searchPageListener = MoviesSearchPageListener()
    
    override func onUpdateTextDebounced(text: String) {
        searchPageListener.text = text
        searchPageListener.currentPage = 1
    }
}
