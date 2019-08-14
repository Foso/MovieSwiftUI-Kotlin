//
//  MovieReviews.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common

extension Review: Identifiable {
    
}

struct MovieReviews : View {
    @EnvironmentObject var store: ObservableStore<AppState>
    
    let movie: String
    
    var reviews: [Review] {
        return store.state.moviesState.reviewByMovieId(movieId: movie)!
    }
        
    var body: some View {
        List(reviews) {review in
            ReviewRow(review: review)
        }
        .navigationBarTitle(Text("Reviews"))
        .onAppear{
            self.store.dispatch(movieActions.fetchMovieReviews(movie: self.movie))
        }
    }
}
