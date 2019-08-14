//
//  MoviesList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common
import Combine

extension Keyword: Identifiable {

}

// MARK: - Movies List
struct MoviesList: ConnectedView {
    
    enum SearchFilter: String {
        case movies, peoples
    }
    
    
    // MARK: - binding
    @State private var searchFilter: String = SearchFilter.movies.rawValue
    @State private var searchTextWrapper = MoviesSearchTextWrapper()
    @State private var isSearching = false
    
    // MARK: - Public var
    let movies: [String]
    let displaySearch: Bool
    var pageListener: MoviesPagesListener?
    var headerView: AnyView?
    
    // MARK: - Computed Props
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> MoviesListProps {
        return MoviesListPropsKt.moviesListProps(searchText: searchTextWrapper.searchText, isSearching: isSearching)(state, dispatch)
    }
    
    // MARK: - Computed views
    private func moviesRows(props: Props) -> some View {
        ForEach(isSearching ? props.searchedMovies ?? [] : movies.map {id in id}, id: \.self) { id in
            NavigationLink(destination: MovieDetail(movieId: id)) {
                MovieRow(movieId: id)
            }
        }
    }
    
    private func movieSection(props: MoviesListProps) -> some View {
        Group {
            if isSearching {
                Section(header: Text("Results for \(searchTextWrapper.searchText)")) {
                    if isSearching && props.searchedMovies == nil {
                        Text("Searching movies...")
                    } else if isSearching && props.searchedMovies?.isEmpty == true {
                        Text("No results")
                    } else {
                        moviesRows(props: props)
                    }
                }
            } else {
                Section {
                    moviesRows(props: props)
                }
            }
        }
    }
    
    private func peoplesSection(props: MoviesListProps) -> some View {
         Section {
            if isSearching && props.searchedPeoples == nil {
                Text("Searching peoples...")
            } else if isSearching && props.isEmptySearch() {
                Text("No results")
            } else {
             
                ForEach(props.searchedPeoples!, id: \.self) { id in
                    NavigationLink(destination: PeopleDetail(peopleId: id)) {
                        PeopleRow(peopleId: id)
                    }
                }
            }
        }
    }
    
    private func keywordsSection(props: Props) -> some View {
        Section(header: Text("Keywords")) {
            ForEach(props.searchedKeywords ?? []) {keyword in
                NavigationLink(destination: MovieKeywordList(keyword: keyword)) {
                    Text(keyword.name)
                }
            }
        }
    }
    
    private var searchField: some View {
        SearchField(searchTextWrapper: searchTextWrapper,
                    placeholder: "Search any movies or person",
                    isSearching: $isSearching)
    }
    
    private var searchFilterView: some View {
        Picker(selection: $searchFilter, label: Text("")) {
            Text("Movies").tag(SearchFilter.movies.rawValue)
            Text("People").tag(SearchFilter.peoples.rawValue)
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    // MARK: - Body
    func body(props: MoviesListProps) -> some View {
        List {
            if displaySearch {
                Section {
                    searchField
                }
            }
            
            if headerView != nil && !isSearching {
                Section {
                    headerView!
                }
            }
            
            if isSearching {
                searchFilterView
                if props.searchedKeywords != nil && searchFilter == SearchFilter.movies.rawValue {
                    keywordsSection(props: props)
                }
            }
            
            if isSearching && searchFilter == SearchFilter.peoples.rawValue {
                peoplesSection(props: props)
            } else {
                movieSection(props: props)
            }
            
            /// The pagination is done by appending a invisible rectancle at the bottom of the list, and trigerining the next page load as it appear.
            /// Hacky way for now, hope it'll be possible to find a better solution in a future version of SwiftUI.
            /// Could be possible to do with GeometryReader.
            if !movies.isEmpty || props.searchedMovies?.isEmpty == false {
                Rectangle()
                    .foregroundColor(.clear)
                    .onAppear {
                        if self.isSearching && props.searchedMovies?.isEmpty == false {
                            self.searchTextWrapper.searchPageListener.currentPage += 1
                        } else if self.pageListener != nil && !self.isSearching && !self.movies.isEmpty {
                            self.pageListener?.currentPage += 1
                        }
                }
            }
        }
    }
}

#if DEBUG
struct MoviesList_Previews : PreviewProvider {
    static var previews: some View {
        MoviesList(movies: [MovieKt.sampleMovie.id], displaySearch: true).environmentObject(sampleStore)
    }
}
#endif
