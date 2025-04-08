enum Environment {
    case development
    case production
}

struct Config {
    static let currentEnvironment: Environment = .development

    static var baseURL: String {
        switch currentEnvironment {
        case .development:
            return "http://192.168.0.22:8001/ourstory/api"
        case .production:
            return "https://api.moodiary.app"
        }
    }
}
