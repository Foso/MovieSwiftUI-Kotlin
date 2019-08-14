//
//  MoviesHomeListPageListener.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import common

final class MoviesMenuListPageListener: MoviesPagesListener {
    var menu: MoviesMenu {
        didSet {
            currentPage = 1
        }
    }
    
    override func loadPage() {
        store.dispatch(movieActions.fetchMoviesMenuList(list: menu, page: currentPage))
    }
    
    init(menu: MoviesMenu) {
        self.menu = menu
        
        super.init()
        
        loadPage()
    }
}
