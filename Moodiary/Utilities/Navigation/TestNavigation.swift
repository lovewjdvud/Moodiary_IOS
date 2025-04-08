////
////  TestNavigation.swift
////  Moodiary
////
////  Created by Songjeongpyeong on 4/7/25.
////
//
//import SwiftUI
//
//import SwiftUI
//import ComposableArchitecture
//
//// MARK: - Navigation Path
//
/////// Navigation 경로를 관리하기 위한 식별 가능한 타입
////public enum NavigationDestination: Hashable, Identifiable {
////    case detail(String)
////    case settings
////    case profile(User)
////    case custom(String)
////    
////    public var id: Self { self }
////    
////    public struct User: Hashable, Identifiable {
////        public let id: UUID
////        public let name: String
////        
////        public init(id: UUID = UUID(), name: String) {
////            self.id = id
////            self.name = name
////        }
////    }
////}
//
//// MARK: - Navigation Feature
//
///// Navigation을 관리하는 Feature
//public struct NavigationFeature: Reducer {
//    public struct State: Equatable {
//        public var path: [NavigationDestination]
//        public var currentSelectedTab: Tab
//        
//        public init(
//            path: [NavigationDestination] = [],
//            currentSelectedTab: Tab = .home
//        ) {
//            self.path = path
//            self.currentSelectedTab = currentSelectedTab
//        }
//        
//        public enum Tab: Hashable {
//            case home
//            case explore
//            case notifications
//            case messages
//            case profile
//            
//            public var title: String {
//                switch self {
//                case .home: return "홈"
//                case .explore: return "탐색"
//                case .notifications: return "알림"
//                case .messages: return "메시지"
//                case .profile: return "프로필"
//                }
//            }
//            
//            public var iconName: String {
//                switch self {
//                case .home: return "house"
//                case .explore: return "magnifyingglass"
//                case .notifications: return "bell"
//                case .messages: return "envelope"
//                case .profile: return "person"
//                }
//            }
//        }
//    }
//    
//    public enum Action: Equatable {
//        case navigate(to: NavigationDestination)
//        case navigateToRoot
//        case pop
//        case popToIndex(Int)
//        case selectTab(State.Tab)
//    }
//    
//    public init() {}
//    
//    public var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case let .navigate(destination):
//                state.path.append(destination)
//                return .none
//                
//            case .navigateToRoot:
//                state.path.removeAll()
//                return .none
//                
//            case .pop:
//                guard !state.path.isEmpty else { return .none }
//                state.path.removeLast()
//                return .none
//                
//            case let .popToIndex(index):
//                guard index >= 0, index < state.path.count else { return .none }
//                state.path = Array(state.path.prefix(through: index))
//                return .none
//                
//            case let .selectTab(tab):
//                state.currentSelectedTab = tab
//                // 탭 변경 시 해당 탭의 네비게이션 스택 초기화
//                state.path.removeAll()
//                return .none
//            }
//        }
//    }
//}
//
//// MARK: - Navigation View Components
//
///// 기본 NavigationStack을 제공하는 View
//public struct NavigationStackView<Content: View, Destination: View>: View {
//    let store: StoreOf<NavigationFeature>
//    let content: () -> Content
//    let destination: (NavigationDestination) -> Destination
//    
//    public init(
//        store: StoreOf<NavigationFeature>,
//        @ViewBuilder content: @escaping () -> Content,
//        @ViewBuilder destination: @escaping (NavigationDestination) -> Destination
//    ) {
//        self.store = store
//        self.content = content
//        self.destination = destination
//    }
//    
//    public var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            NavigationStack(path: viewStore.binding(
//                get: \.path,
//                send: { _ in .navigateToRoot }
//            )) {
//                content()
//                    .navigationDestination(for: NavigationDestination.self) { destination in
//                        destination(destination)
//                    }
//            }
//        }
//    }
//}
//
///// TabView와 NavigationStack을 결합한 View
//public struct TabNavigationView<TabContent: View, Destination: View>: View {
//    let store: StoreOf<NavigationFeature>
//    let tabContent: (NavigationFeature.State.Tab) -> TabContent
//    let destination: (NavigationDestination) -> Destination
//    
//    public init(
//        store: StoreOf<NavigationFeature>,
//        @ViewBuilder tabContent: @escaping (NavigationFeature.State.Tab) -> TabContent,
//        @ViewBuilder destination: @escaping (NavigationDestination) -> Destination
//    ) {
//        self.store = store
//        self.tabContent = tabContent
//        self.destination = destination
//    }
//    
//    public var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            TabView(selection: viewStore.binding(
//                get: \.currentSelectedTab,
//                send: NavigationFeature.Action.selectTab
//            )) {
//                ForEach([
//                    NavigationFeature.State.Tab.home,
//                    .explore,
//                    .notifications,
//                    .messages,
//                    .profile
//                ], id: \.self) { tab in
//                    NavigationStack(path: viewStore.binding(
//                        get: \.path,
//                        send: { _ in .navigateToRoot }
//                    )) {
//                        tabContent(tab)
//                            .navigationDestination(for: NavigationDestination.self) { destination in
//                                self.destination(destination)
//                            }
//                    }
//                    .tabItem {
//                        Label(tab.title, systemImage: tab.iconName)
//                    }
//                    .tag(tab)
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Navigation Utility Extensions
//
//extension View {
//    /// NavigationLink 생성을 위한 편리한 메서드
//    public func navigationLink<Content: View>(
//        store: StoreOf<NavigationFeature>,
//        destination: NavigationDestination,
//        @ViewBuilder content: @escaping () -> Content
//    ) -> some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            Button {
//                viewStore.send(.navigate(to: destination))
//            } label: {
//                content()
//            }
//        }
//    }
//    
//    /// 네비게이션 동작을 위한 메서드 추가
//    public func withNavigation(
//        store: StoreOf<NavigationFeature>,
//        onBack: (() -> Void)? = nil
//    ) -> some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            self
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        if !viewStore.path.isEmpty {
//                            Button {
//                                if let onBack = onBack {
//                                    onBack()
//                                } else {
//                                    viewStore.send(.pop)
//                                }
//                            } label: {
//                                Image(systemName: "chevron.left")
//                            }
//                        }
//                    }
//                }
//        }
//    }
//}
//
//// MARK: - 사용 예시
//
//struct ExampleView: View {
//    let store: StoreOf<NavigationFeature>
//    
//    var body: some View {
//        NavigationStackView(
//            store: store,
//            content: {
//                List {
//                    Button("상세 화면으로 이동") {
//                        ViewStore(store).send(.navigate(to: .detail("상세 정보")))
//                    }
//                    
//                    Button("설정으로 이동") {
//                        ViewStore(store).send(.navigate(to: .settings))
//                    }
//                    
//                    Button("사용자 프로필로 이동") {
//                        ViewStore(store).send(.navigate(to: .profile(NavigationDestination.User(name: "홍길동"))))
//                    }
//                }
//                .navigationTitle("메인 화면")
//            },
//            destination: { destination in
//                switch destination {
//                case let .detail(info):
//                    Text("상세 화면: \(info)")
//                        .withNavigation(store: store)
//                        
//                case .settings:
//                    Text("설정 화면")
//                        .withNavigation(store: store)
//                        
//                case let .profile(user):
//                    Text("프로필 화면: \(user.name)")
//                        .withNavigation(store: store)
//                        
//                case let .custom(name):
//                    Text("커스텀 화면: \(name)")
//                        .withNavigation(store: store)
//                }
//            }
//        )
//    }
//}
//
//struct TabExampleView: View {
//    let store: StoreOf<NavigationFeature>
//    
//    var body: some View {
//        TabNavigationView(
//            store: store,
//            tabContent: { tab in
//                switch tab {
//                case .home:
//                    List {
//                        Button("홈에서 상세 화면으로") {
//                            ViewStore(store).send(.navigate(to: .detail("홈 상세")))
//                        }
//                    }
//                    .navigationTitle("홈")
//                case .explore:
//                    Text("탐색 화면")
//                        .navigationTitle("탐색")
//                case .notifications:
//                    Text("알림 화면")
//                        .navigationTitle("알림")
//                case .messages:
//                    Text("메시지 화면")
//                        .navigationTitle("메시지")
//                case .profile:
//                    Text("프로필 화면")
//                        .navigationTitle("프로필")
//                }
//            },
//            destination: { destination in
//                switch destination {
//                case let .detail(info):
//                    Text("상세 화면: \(info)")
//                        .withNavigation(store: store)
//                default:
//                    Text("기타 화면")
//                        .withNavigation(store: store)
//                }
//            }
//        )
//    }
//}
