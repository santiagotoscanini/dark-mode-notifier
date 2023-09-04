import Cocoa

// To avoid a compiler warning about calling this function without saving its output
@discardableResult
func switchColorSchemes() -> Int32 {
    let task = Process()
    var env = ProcessInfo.processInfo.environment

    // Set the environment variable for the subprocess.
    let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
    env["DARKMODE"] = isDark ? "1" : "0"

    task.environment = env
    task.launchPath = "/usr/bin/env"
    task.arguments = ["zsh", "/Users/stoscanini/dev/personal/dotfiles/os/macos/dark-mode-notifier/change-theme.zsh"]
    task.standardError = FileHandle.standardError
    task.standardOutput = FileHandle.standardOutput
    task.launch()
    task.waitUntilExit()

    return task.terminationStatus
}

// First run
switchColorSchemes()

DistributedNotificationCenter.default.addObserver(
    forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: nil
) { (notification) in switchColorSchemes() }

NSWorkspace.shared.notificationCenter.addObserver(
    // A notification that the workspace posts when the device wakes from sleep.
    // https://developer.apple.com/documentation/appkit/nsworkspace/1530973-didwakenotification
    forName: NSWorkspace.didWakeNotification,
    object: nil,
    queue: nil
) { (notification) in switchColorSchemes() }

NSApplication.shared.run()
