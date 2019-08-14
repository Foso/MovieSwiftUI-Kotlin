//
//  MovieKeywordList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common
final class KeywordPageListener: MoviesPagesListener {
    var keywordId: String!
    
    override func loadPage() {
        store.dispatch(movieActions.fetchMovieWithKeywords(keyword: keywordId,
                                                                    page: currentPage))
    }
}

struct MovieKeywordList : View {
    @EnvironmentObject var store: ObservableStore<AppState>
    @State var pageListener = KeywordPageListener()
    let keyword: Keyword
    
    var movies: [String] {
        store.state.moviesState.withKeywordId(keywordId: keyword.id)
    }
    
    var body: some View {
        MoviesList(movies: movies, displaySearch: false, pageListener: pageListener)
            .navigationBarTitle(Text(keyword.name.capitalized))
            .onAppear {
                self.pageListener.keywordId = self.keyword.id
                self.pageListener.loadPage()
        }
    }
}

#if DEBUG
struct MovieKeywordList_Previews : PreviewProvider {
    static var previews: some View {
        MovieKeywordList(keyword: Keyword(id: "0", name: "Test"))
    }
}
#endif
