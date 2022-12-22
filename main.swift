import Cocoa

// To avoid a compiler warning about calling this function without saving its output
@discardableResult
func switchColorSchemes() -> Int32 {
    // Run another program as a subprocess.
    // https://developer.apple.com/documentation/foundation/process
    let task = Process()
    var env = ProcessInfo.processInfo.environment

    // Set the environment variable for the subprocess.
    let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
    env["DARKMODE"] = isDark ? "1" : "0"

    task.environment = env
    task.launchPath = "/usr/bin/env"
    task.arguments = ["zsh", "/Users/stoscanini/dev/personal/dotfiles/dark-mode-notifier/change-theme.zsh"]
    task.standardError = FileHandle.standardError
    task.standardOutput = FileHandle.standardOutput
    task.launch()
    task.waitUntilExit()

    return task.terminationStatus
}

// First run
switchColorSchemes()

// A notification dispatch mechanism that enables the broadcast of notifications across task boundaries.
// https://developer.apple.com/documentation/foundation/distributednotificationcenter
// https://developer.apple.com/documentation/foundation/notificationcenter/1411723-addobserver
DistributedNotificationCenter.default.addObserver(
    // Just listen for `AppleInterfaceThemeChangedNotification` notification.
    forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: nil
) { (notification) in switchColorSchemes() }

// https://developer.apple.com/documentation/appkit/nsworkspace
NSWorkspace.shared.notificationCenter.addObserver(
    // A notification that the workspace posts when the device wakes from sleep.
    // https://developer.apple.com/documentation/appkit/nsworkspace/1530973-didwakenotification
    forName: NSWorkspace.didWakeNotification,
    object: nil,
    queue: nil
) { (notification) in switchColorSchemes() }

// Every app uses a single instance of NSApplication to control the main event loop
// https://developer.apple.com/documentation/appkit/nsapplication
NSApplication.shared.run()
