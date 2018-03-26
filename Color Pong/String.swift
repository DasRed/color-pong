import Foundation

extension String {
    // only localized
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    // localized with format
    func localized(args: CVarArgType...) -> String {
        return withVaList(args) {
            NSString(format: self.localized, locale: NSLocale.currentLocale(), arguments: $0)
        } as String
    }
}