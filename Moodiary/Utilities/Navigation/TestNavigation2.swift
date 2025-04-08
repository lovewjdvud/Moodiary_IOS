////
////  ㅅㄷ.swift
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
//
//
//// MARK: - 개별 기능별 Reducer 정의
//
//// Home 화면 Feature
//struct HomeFeature: Reducer {
//    struct State: Equatable {
//        var items: [Item] = [
//            Item(id: "1", title: "첫 번째 항목", description: "첫 번째 항목에 대한 설명입니다."),
//            Item(id: "2", title: "두 번째 항목", description: "두 번째 항목에 대한 설명입니다."),
//            Item(id: "3", title: "세 번째 항목", description: "세 번째 항목에 대한 설명입니다.")
//        ]
//        var featuredUsers: [String] = ["user-1", "user-2", "user-3"]
//    }
//    
//    enum Action: Equatable {
//        case itemTapped(String)
//        case userTapped(String)
//        case navigateToDetail(String)
//        case navigateToProfile(String)
//        case navigateToSettings
//    }
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case let .itemTapped(itemId):
//                // Item을 탭했을 때 상세화면으로 이동하는 액션 발행
//                return .send(.navigateToDetail(itemId))
//                
//            case let .userTapped(userId):
//                // 사용자를 탭했을 때 프로필로 이동하는 액션 발행
//                return .send(.navigateToProfile(userId))
//                
//            case .navigateToDetail, .navigateToProfile, .navigateToSettings:
//                // 이 액션들은 AppFeature에서 처리
//                return .none
//            }
//        }
//    }
//    
//    struct Item: Identifiable, Equatable {
//        let id: String
//        let title: String
//        let description: String
//    }
//}
//
//// 상세 화면 Feature
//struct DetailFeature: Reducer {
//    struct State: Equatable {
//        var itemId: String?
//        var item: HomeFeature.Item?
//        var isLoading: Bool = false
//    }
//    
//    enum Action: Equatable {
//        case onAppear
//        case loadItem(String)
//        case itemLoaded(HomeFeature.Item)
//        case backButtonTapped
//        case closeButtonTapped
//        case shareButtonTapped
//    }
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case .onAppear:
//                if let itemId = state.itemId {
//                    return .send(.loadItem(itemId))
//                }
//                return .none
//                
//            case let .loadItem(itemId):
//                state.isLoading = true
//                // 실제로는 여기서 데이터를 비동기로 로드하겠지만, 예시에서는 단순화
//                let mockItem = HomeFeature.Item(id: itemId, title: "항목 \(itemId)", description: "항목 \(itemId)에 대한 상세 설명입니다.")
//                return .send(.itemLoaded(mockItem))
//                
//            case let .itemLoaded(item):
//                state.item = item
//                state.isLoading = false
//                return .none
//                
//            case .backButtonTapped, .closeButtonTapped, .shareButtonTapped:
//                // 이 액션들은 AppFeature에서 처리
//                return .none
//            }
//        }
//    }
//}
//
//// 프로필 화면 Feature
//struct ProfileFeature: Reducer {
//    struct State: Equatable {
//        var user: NavigationDestination.User?
//        var posts: [Post] = []
//    }
//    
//    enum Action: Equatable {
//        case onAppear
//        case loadPosts
//        case postsLoaded([Post])
//    }
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case .onAppear:
//                return .send(.loadPosts)
//                
//            case .loadPosts:
//                // 실제로는 여기서 데이터를 비동기로 로드하겠지만, 예시에서는 단순화
//                let mockPosts = [
//                    Post(id: "1", title: "첫 번째 게시물"),
//                    Post(id: "2", title: "두 번째 게시물"),
//                    Post(id: "3", title: "세 번째 게시물")
//                ]
//                return .send(.postsLoaded(mockPosts))
//                
//            case let .postsLoaded(posts):
//                state.posts = posts
//                return .none
//            }
//        }
//    }
//    
//    struct Post: Identifiable, Equatable {
//        let id: String
//        let title: String
//    }
//}
//
//// MARK: - 뷰 구현
//
//// 앱의 메인 뷰
//struct AppView: View {
//    let store: StoreOf<AppFeature>
//    
//    var body: some View {
//        TabNavigationView(
//            store: store.scope(
//                state: \.navigation,
//                action: AppFeature.Action.navigation
//            ),
//            tabContent: { tab in
//                // 각 탭에 맞는 뷰 반환
//                switch tab {
//                case .home:
//                    HomeView(
//                        store: store.scope(
//                            state: \.home,
//                            action: AppFeature.Action.home
//                        )
//                    )
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
//                    Text("내 프로필 화면")
//                        .navigationTitle("내 프로필")
//                }
//            },
//            destination: { destination in
//                // 각 네비게이션 목적지에 맞는 뷰 반환
//                switch destination {
//                case let .detail(itemId):
//                    DetailView(
//                        store: store.scope(
//                            state: \.detail,
//                            action: AppFeature.Action.detail
//                        ),
//                        itemId: itemId
//                    )
//                    
//                case .settings:
//                    SettingsView()
//                    
//                case let .profile(user):
//                    ProfileView(
//                        store: store.scope(
//                            state: \.profile,
//                            action: AppFeature.Action.profile
//                        ),
//                        user: user
//                    )
//                    
//                case let .custom(name):
//                    Text("커스텀 화면: \(name)")
//                }
//            }
//        )
//    }
//}
//
//// 홈 화면 뷰
//struct HomeView: View {
//    let store: StoreOf<HomeFeature>
//    
//    var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            List {
//                Section(header: Text("추천 항목")) {
//                    ForEach(viewStore.items) { item in
//                        Button {
//                            viewStore.send(.itemTapped(item.id))
//                        } label: {
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text(item.title)
//                                        .font(.headline)
//                                    Text(item.description)
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                }
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
//                            }
//                            .contentShape(Rectangle())
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                }
//                
//                Section(header: Text("추천 사용자")) {
//                    ForEach(viewStore.featuredUsers, id: \.self) { userId in
//                        Button {
//                            viewStore.send(.userTapped(userId))
//                        } label: {
//                            HStack {
//                                Image(systemName: "person.circle.fill")
//                                    .font(.title2)
//                                    .foregroundColor(.blue)
//                                Text("사용자 \(userId)")
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
//                            }
//                            .contentShape(Rectangle())
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                }
//                
//                Section {
//                    Button {
//                        viewStore.send(.navigateToSettings)
//                    } label: {
//                        HStack {
//                            Image(systemName: "gear")
//                                .foregroundColor(.gray)
//                            Text("설정")
//                        }
//                    }
//                }
//            }
//            .navigationTitle("홈")
//        }
//    }
//}
//
//// 상세 화면 뷰
//struct DetailView: View {
//    let store: StoreOf<DetailFeature>
//    let itemId: String
//    
//    var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            VStack {
//                if viewStore.isLoading {
//                    ProgressView()
//                } else if let item = viewStore.item {
//                    VStack(alignment: .leading, spacing: 20) {
//                        Text(item.title)
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                        
//                        Text(item.description)
//                            .font(.body)
//                        
//                        Spacer()
//                        
//                        Button {
//                            // 공유 액션
//                            viewStore.send(.shareButtonTapped)
//                        } label: {
//                            HStack {
//                                Image(systemName: "square.and.arrow.up")
//                                Text("공유하기")
//                            }
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                        }
//                    }
//                    .padding()
//                } else {
//                    Text("항목을 찾을 수 없습니다.")
//                }
//            }
//            .navigationTitle("상세 정보")
//            .navigationBarBackButtonHidden(true)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        viewStore.send(.backButtonTapped)
//                    } label: {
//                        Image(systemName: "chevron.left")
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        viewStore.send(.closeButtonTapped)
//                    } label: {
//                        Image(systemName: "xmark")
//                    }
//                }
//            }
//            .onAppear {
//                viewStore.send(.onAppear)
//                // 상세 화면이 표시될 때 itemId 설정
//                viewStore.send(.loadItem(itemId))
//            }
//        }
//    }
//}
//
//// 프로필 화면 뷰
//struct ProfileView: View {
//    let store: StoreOf<ProfileFeature>
//    let user: NavigationDestination.User
//    
//    var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            List {
//                Section {
//                    HStack(spacing: 20) {
//                        Image(systemName: "person.circle.fill")
//                            .font(.system(size: 60))
//                            .foregroundColor(.blue)
//                        
//                        VStack(alignment: .leading) {
//                            Text(user.name)
//                                .font(.title)
//                                .bold()
//                            
//                            Text("사용자 ID: \(user.id.uuidString.prefix(8))")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    .padding(.vertical)
//                }
//                
//                Section(header: Text("게시물")) {
//                    if viewStore.posts.isEmpty {
//                        Text("게시물이 없습니다.")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    } else {
//                        ForEach(viewStore.posts) { post in
//                            VStack(alignment: .leading) {
//                                Text(post.title)
//                                    .font(.headline)
//                            }
//                            .padding(.vertical, 4)
//                        }
//                    }
//                }
//            }
//            .navigationTitle(user.name)
//            .onAppear {
//                viewStore.send(.onAppear)
//            }
//        }
//    }
//}
//
//// 설정 화면 뷰
//struct SettingsView: View {
//    var body: some View {
//        List {
//            Section(header: Text("계정")) {
//                NavigationLink(destination: Text("계정 정보 화면")) {
//                    Text("계정 정보")
//                }
//                
//                NavigationLink(destination: Text("알림 설정 화면")) {
//                    Text("알림 설정")
//                }
//                
//                NavigationLink(destination: Text("개인정보 화면")) {
//                    Text("개인정보 설정")
//                }
//            }
//            
//            Section(header: Text("앱 설정")) {
//                NavigationLink(destination: Text("테마 설정 화면")) {
//                    Text("테마 설정")
//                }
//                
//                NavigationLink(destination: Text("언어 설정 화면")) {
//                    Text("언어")
//                }
//            }
//            
//            Section {
//                Button("로그아웃") {
//                    // 로그아웃 처리
//                }
//                .foregroundColor(.red)
//            }
//        }
//        .navigationTitle("설정")
//    }
//}
//
//// MARK: - 앱 시작점
//@main
//struct MyApp: App {
//    let store = Store(
//        initialState: AppFeature.State(),
//        reducer: AppFeature()
//    )
//    
//    var body: some Scene {
//        WindowGroup {
//            AppView(store: store)
//        }
//    }
//}
