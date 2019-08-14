//
//  MovieCrewList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common

struct MoviesCrewList : View {
    @EnvironmentObject var store: ObservableStore<AppState>
    let crew: People

    var body: some View {
        MoviesList(movies: store.state.moviesState.withCrewId(crewId: crew.id), displaySearch: false)
            .navigationBarTitle(Text(crew.name))
            .onAppear {
                self.store.dispatch(movieActions.fetchMovieWithCrew(crew: self.crew.id))
        }
    }
}

#if DEBUG
/*
struct MovieCrewList_Previews : PreviewProvider {
    static var previews: some View {
        MoviesCrewList(crew: sampleCasts.first!)
    }
}
 */
#endif
