//
//  SceneDelegate.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftUI
import common

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            #if targetEnvironment(macCatalyst)
                windowScene.titlebar?.titleVisibility = .hidden
            #endif
            
            //TODO: Move that to SwiftUI once implemented
            UINavigationBar.appearance().largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
                NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 40)!]
            
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
                NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 18)!]
            
            UIBarButtonItem.appearance().setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
                NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 16)!],
                                                                for: .normal)
            
            let controller = UIHostingController(rootView:
                StoreProvider(store: store) {
                    HomeView()
            })
            
            window.rootViewController = controller
            window.tintColor = UIColor(named: "steam_gold")
            self.window = window
            window.makeKeyAndVisible()
        }
        }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        saveState(store.state.getSaveState())
    }
}
public typealias DispatchFunction = (Any) -> (Any)


public protocol ConnectedView: View {
    associatedtype State: AnyObject
    associatedtype Props
    associatedtype V: View
    
    func map(state: State, dispatch: @escaping DispatchFunction) -> Props
    func body(props: Props) -> V
}

public extension ConnectedView {
    func render(state: State, dispatch: @escaping DispatchFunction) -> V {
        let props = map(state: state, dispatch: dispatch)
        return body(props: props)
    }
    
    var body: StoreConnector<State, V> {
        return StoreConnector(content: render)
    }
}

public struct StoreConnector<State: AnyObject, V: View>: View {
    @EnvironmentObject var store: ObservableStore<State>
    let content: (State, @escaping (Any) -> ()) -> V
    
    public var body: V {
        return content(store.state, store.dispatch)
    }
}


class ObservableStore<State: AnyObject>: ObservableObject {
    @Published public var state: State
    let store: LibStore<State>
    var unsubscribe = { }
    public init(store: LibStore<State>) {
        self.store = store
        self.state = store.state!
        _ = self.store.subscribe {
            self.state = self.store.state!
            return KotlinUnit()
        }
    }

    public func dispatch(_ action: Any) {
        DispatchQueue.main.async {
            self.store.dispatch(action)
        }
    }
        
    func sizeOfArchivedState() -> String {
        do {
            let resources = try savePath.resourceValues(forKeys:[.fileSizeKey])
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = .useKB
            formatter.countStyle = .file
            return formatter.string(fromByteCount: Int64(resources.fileSize ?? 0))
        } catch {
            return "0"
        }
    }
    
    deinit {
        unsubscribe()
    }
}

struct StoreProvider<V: View>: View {
    public let store: ObservableStore<AppState>
    public let content: () -> V
    
    public init(store: ObservableStore<AppState>, content: @escaping () -> V) {
        self.store = store
        self.content = content
    }
    
    public var body: some View {
        content().environmentObject(store)
    }
}


fileprivate var savePath: URL!

func initialState() -> AppState {
    do {
        let icloudDirectory = FileManager.default.url(forUbiquityContainerIdentifier: nil)
        let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false)
        savePath = (icloudDirectory ?? documentDirectory).appendingPathComponent("userData")
    } catch let error {
        fatalError("Couldn't create save state data with error: \(error)")
    }
    
    if let data = try? String(contentsOf: savePath, encoding: .utf8) {
        let savedState = AppState.Companion().decode(jsonStr: data)
        return savedState
    } else {
        return AppState.Companion().initialValue()
    }
}

func saveState(_ state: AppState) {
    guard let data = try? state.getSaveState().encode() else {
        return
    }
    
    do {
        try data.write(to: savePath, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print("Error while saving app state :\(error)")
    }
}

let store = ObservableStore(store: StoreKt.createStore(initialState: nil))
let apiService = APIService.init(networkContext: UI())
let appUserDefaults = AppUserDefaults(settings: SettingsKt.settings(context: nil))
let movieActions = MoviesActions(apiService: apiService, appUserDefaults: appUserDefaults)
let peopleActions = PeopleActions(apiService: apiService)

#if DEBUG
let sampleStore = ObservableStore(store: StoreKt.createSampleStore())
#endif


