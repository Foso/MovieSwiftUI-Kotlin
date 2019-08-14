//
//  Collection.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import common
/*
extension Sequence where Iterator.Element == Int {
    func sortedMoviesIds(by: MoviesSort, state: AppState) -> [Int] {
        switch by {
        case MoviesSort.byaddeddate:
            let metas = state.moviesState.moviesUserMeta.filter{ self.contains($0.key) }
            return metas.sorted{ $0.value.addedToList ?? Date() > $1.value.addedToList ?? Date() }.compactMap{ $0.key }
        case MoviesSort.byreleasedate:
            let movies = state.moviesState.movies.filter{ self.contains($0.key) }
            return movies.sorted{ $0.value.releaseDate ?? Date() > $1.value.releaseDate ?? Date() }.compactMap{ $0.key }
        case MoviesSort.bypopularity:
            let movies = state.moviesState.movies.filter{ self.contains($0.key) }
            return movies.sorted{ $0.value.popularity > $1.value.popularity }.compactMap{ $0.key }
        case MoviesSort.byscore:
            let movies = state.moviesState.movies.filter{ self.contains($0.key as! Int) }
            return movies.sorted{ ($0.value as AnyObject).vote_average > ($1.value as AnyObject).vote_average }.compactMap{ $0.key }
        }
    }
}
 */
