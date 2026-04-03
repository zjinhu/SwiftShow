# SwiftShow AI Skills Reference

## Overview

SwiftShow is a versatile popup/HUD library for iOS written in Swift. It provides Toast, Loading, Alert, PopView, and DropDown views with extensive customization options.

**Repository:** https://github.com/zjinhu/SwiftShow
**Requirements:** iOS 11.0+, Swift 4.2+, Xcode 11.0+

---

## Quick Reference Card

| Component | Show API | Hide API |
|-----------|----------|----------|
| Toast | `Show.toast("text")` | Auto-dismisses |
| Loading | `Show.loading("text")` | `Show.hideLoading()` |
| Alert | `Show.alert(title:message:)` | `Show.hideAlert()` |
| PopView | `Show.pop(contentView)` | `Show.hidePop()` |
| DropDown | `Show.coverTabbar(contentView)` | `Show.hideCoverTabbar()` |

---

## 1. Toast

### Purpose
Brief notification messages that auto-dismiss after a set duration.

### API Signature

```swift
Show.toast(_ title: String,
           subTitle: String? = nil,
           image: UIImage? = nil,
           config: ((_ config: ShowToastConfig) -> Void)? = nil)
```

### Configuration: ShowToastConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `animateDuration` | `Double` | `0.5` | Animation duration in seconds |
| `showTime` | `Double` | `3.0` | Display duration in seconds |
| `maxWidth` | `Float` | `200` | Maximum width |
| `maxHeight` | `Float` | `500` | Maximum height |
| `cornerRadius` | `CGFloat` | `5` | Corner radius |
| `bgColor` | `UIColor` | `.blackBGColor` | Background color (dark-mode aware) |
| `shadowColor` | `CGColor` | `.clear` | Shadow color |
| `shadowOpacity` | `Float` | `0.5` | Shadow opacity |
| `shadowRadius` | `CGFloat` | `5` | Shadow blur radius |
| `imageType` | `ImageLayoutType` | `.left` | Image layout: `.left` or `.top` |
| `padding` | `Float` | `10` | Inner padding |
| `offSet` | `Float` | `100` | Offset from center position |
| `offSetType` | `ToastOffset` | `.center` | Position: `.top`, `.center`, `.bottom` |
| `titleColor` | `UIColor` | `.white` | Title text color |
| `titleFont` | `UIFont` | `systemFont(15)` | Title font |
| `subTitleColor` | `UIColor` | `.lightGray` | Subtitle text color |
| `subTitleFont` | `UIFont` | `systemFont(12)` | Subtitle font |
| `spaceImage` | `CGFloat` | `5` | Spacing between image and text |
| `spaceText` | `CGFloat` | `5` | Spacing between title and subtitle |

### Usage Examples

```swift
// Simple text toast
Show.toast("Success!")

// Toast with subtitle
Show.toast("Saved", subTitle: "Changes have been saved")

// Toast with image and custom config
Show.toast("Success", image: UIImage(systemName: "checkmark.circle.fill")) { config in
    config.showTime = 2.0
    config.offSetType = .top
    config.offSet = 80
}

// Image on top layout
Show.toast("Upload Complete", image: UIImage(named: "upload")) { config in
    config.imageType = .top
    config.showTime = 3.0
}
```

---

## 2. Loading

### Purpose
Loading HUD with spinner or custom image animation. Supports three display targets: current VC, window, and specific view.

### API Signatures

```swift
// Current view controller
Show.loading(_ title: String? = nil,
             subTitle: String? = nil,
             config: ((_ config: ShowLoadingConfig) -> Void)? = nil)

// On window
Show.loadingOnWindow(_ title: String? = nil,
                     subTitle: String? = nil,
                     config: ((_ config: ShowLoadingConfig) -> Void)? = nil)

// On specific view
Show.loadingOnView(_ onView: UIView,
                   title: String? = nil,
                   subTitle: String? = nil,
                   config: ((_ config: ShowLoadingConfig) -> Void)? = nil)

// Hide methods
Show.hideLoading()
Show.hideLoadingOnWindow()
Show.hideLoadingOnView(_ onView: UIView)
```

### Configuration: ShowLoadingConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `maxWidth` | `Float` | `200` | Maximum width |
| `maxHeight` | `Float` | `200` | Maximum height |
| `cornerRadius` | `CGFloat` | `5` | Corner radius |
| `titleFont` | `UIFont` | `systemFont(15)` | Title font |
| `titleColor` | `UIColor` | `.white` | Title color |
| `subTitleFont` | `UIFont` | `systemFont(12)` | Subtitle font |
| `subTitleColor` | `UIColor` | `.lightGray` | Subtitle color |
| `enableEvent` | `Bool` | `false` | Allow touch through background |
| `effectStyle` | `UIBlurEffect.Style` | `.light` | Blur effect style |
| `tintColor` | `UIColor` | `.blackBGColor` | Container background color |
| `bgColor` | `UIColor` | `.clear` | Outer background color |
| `maskType` | `MaskType` | `.color` | `.color` or `.effect` |
| `shadowColor` | `CGColor` | `.clear` | Shadow color |
| `shadowOpacity` | `Float` | `0.5` | Shadow opacity |
| `shadowRadius` | `CGFloat` | `5` | Shadow radius |
| `imagesArray` | `[UIImage]?` | `nil` | Animation frames (replaces spinner) |
| `activityColor` | `UIColor` | `.white` | Spinner color |
| `animationTime` | `Double` | `1.0` | Image animation cycle duration |
| `imageType` | `ImageLayoutType` | `.top` | Layout: `.top` or `.left` |
| `verticalPadding` | `Float` | `20` | Top/bottom padding |
| `horizontalPadding` | `Float` | `20` | Left/right padding |
| `spaceImage` | `CGFloat` | `5` | Image-text spacing |
| `spaceText` | `CGFloat` | `5` | Text line spacing |

### Usage Examples

```swift
// Simple loading in current VC
Show.loading("Loading")

// Loading with subtitle
Show.loading("Please wait", subTitle: "Fetching data...")

// Custom loading with image animation
Show.loading("Loading") { config in
    config.imagesArray = [UIImage(named: "frame1")!, UIImage(named: "frame2")!, UIImage(named: "frame3")!]
    config.animationTime = 1.0
    config.tintColor = .systemBlue
}

// Loading on window (full screen)
Show.loadingOnWindow("Processing...") { config in
    config.enableEvent = false
}

// Loading on specific view
Show.loadingOnView(scrollView, title: "Refreshing...")

// Hide loading
Show.hideLoading()
Show.hideLoadingOnWindow()
Show.hideLoadingOnView(scrollView)
```

---

## 3. Alert

### Purpose
Modal dialog with title, message, optional image, and up to two action buttons. Supports plain text and attributed text.

### API Signatures

```swift
// Default style
Show.alert(title: String? = nil,
           message: String? = nil,
           leftBtnTitle: String? = nil,
           rightBtnTitle: String? = nil,
           leftBlock: LeftCallBack? = nil,
           rightBlock: RightCallback? = nil)

// Attributed text style
Show.attributedAlert(attributedTitle: NSAttributedString? = nil,
                     attributedMessage: NSAttributedString? = nil,
                     leftBtnAttributedTitle: NSAttributedString? = nil,
                     rightBtnAttributedTitle: NSAttributedString? = nil,
                     leftBlock: LeftCallBack? = nil,
                     rightBlock: RightCallback? = nil)

// Custom style (all options)
Show.customAlert(title: String? = nil,
                 attributedTitle: NSAttributedString? = nil,
                 image: UIImage? = nil,
                 message: String? = nil,
                 attributedMessage: NSAttributedString? = nil,
                 leftBtnTitle: String? = nil,
                 leftBtnAttributedTitle: NSAttributedString? = nil,
                 rightBtnTitle: String? = nil,
                 rightBtnAttributedTitle: NSAttributedString? = nil,
                 leftBlock: LeftCallBack? = nil,
                 rightBlock: RightCallback? = nil,
                 config: ((_ config: ShowAlertConfig) -> Void)? = nil)

// Hide
Show.hideAlert()
```

### Callback Types

```swift
public typealias LeftCallBack = () -> Void
public typealias RightCallback = () -> Void
public typealias DismissCallback = () -> Void
```

### Configuration: ShowAlertConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `animateDuration` | `Double` | `0.5` | Animation duration |
| `effectStyle` | `UIBlurEffect.Style` | `.light` | Blur effect |
| `width` | `Float` | `280` | Alert width |
| `maxHeight` | `Float` | `500` | Maximum height |
| `buttonHeight` | `Float` | `50` | Button height |
| `cornerRadius` | `CGFloat` | `5` | Corner radius |
| `space` | `Float` | `5` | Image-text spacing |
| `tintColor` | `UIColor` | `.whiteBGColor` | Container color |
| `bgColor` | `UIColor` | `black 50% alpha` | Background overlay color |
| `lineColor` | `UIColor` | `.lightGray` | Divider line color |
| `maskType` | `MaskType` | `.color` | `.color` or `.effect` |
| `shadowColor` | `CGColor` | `.clear` | Shadow color |
| `shadowOpacity` | `Float` | `0.5` | Shadow opacity |
| `shadowRadius` | `CGFloat` | `5` | Shadow radius |
| `titleFont` | `UIFont` | `systemFont(21)` | Title font |
| `titleColor` | `UIColor` | `.textColor` | Title color (dark-mode aware) |
| `textFont` | `UIFont` | `systemFont(14)` | Message font |
| `textColor` | `UIColor` | `.textColor` | Message color (dark-mode aware) |
| `buttonFont` | `UIFont` | `systemFont(15)` | Button font |
| `leftColor` | `UIColor` | `.textColor` | Left button color |
| `rightColor` | `UIColor` | `.textColor` | Right button color |
| `verticalPadding` | `Float` | `10` | Top/bottom padding |
| `horizontalPadding` | `Float` | `10` | Left/right padding |

### Usage Examples

```swift
// Simple two-button alert
Show.alert(title: "Confirm",
           message: "Are you sure?",
           leftBtnTitle: "Cancel",
           rightBtnTitle: "OK",
           leftBlock: { print("Cancelled") },
           rightBlock: { print("Confirmed") })

// Single button alert (omit leftBtnTitle)
Show.alert(title: "Notice",
           message: "Operation completed.",
           rightBtnTitle: "OK",
           rightBlock: { print("OK tapped") })

// Custom styled alert
Show.customAlert(title: "Warning",
                 image: UIImage(systemName: "exclamationmark.triangle"),
                 message: "This action cannot be undone.",
                 leftBtnTitle: "Go Back",
                 rightBtnTitle: "Continue",
                 rightBlock: { /* proceed */ }) { config in
    config.tintColor = .systemRed
    config.cornerRadius = 16
    config.width = 300
}

// Hide alert programmatically
Show.hideAlert()
```

---

## 4. PopView

### Purpose
Modal pop-up view that presents any custom UIView with animated entrance from various directions.

### API Signatures

```swift
Show.pop(_ contentView: UIView,
         config: ((_ config: ShowPopViewConfig) -> Void)? = nil,
         showClosure: CallBack? = nil,
         hideClosure: CallBack? = nil)

Show.hidePop(_ complete: (() -> Void)? = nil)
```

### Configuration: ShowPopViewConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `effectStyle` | `UIBlurEffect.Style` | `.light` | Blur effect |
| `clickOutHidden` | `Bool` | `true` | Dismiss on tap outside |
| `maskType` | `MaskType` | `.color` | `.color` or `.effect` |
| `bgColor` | `UIColor` | `black 30% alpha` | Background overlay |
| `animateDuration` | `Double` | `0.3` | Animation duration |
| `animateDamping` | `Bool` | `true` | Use spring animation |
| `isAnimate` | `Bool` | `true` | Enable animation |
| `showAnimateType` | `PopViewShowType?` | `.center` | Show direction |

### PopViewShowType Values

| Case | Description |
|------|-------------|
| `.top` | Slides in from top |
| `.left` | Slides in from left |
| `.bottom` | Slides in from bottom |
| `.right` | Slides in from right |
| `.center` | Zooms in from center |

### Usage Examples

```swift
// Center zoom pop (default)
Show.pop(customView)

// Slide from bottom with spring
Show.pop(customView) { config in
    config.showAnimateType = .bottom
    config.animateDamping = true
} showClosure: {
    print("Pop appeared")
} hideClosure: {
    print("Pop disappeared")
}

// Slide from right without spring
Show.pop(customView) { config in
    config.showAnimateType = .right
    config.animateDamping = false
}

// Hide pop
Show.hidePop {
    print("Dismissed")
}
```

---

## 5. DropDown

### Purpose
Drop-down view that slides down from a specified Y position, designed to cover the TabBar while keeping the NavBar visible.

### API Signatures

```swift
Show.coverTabbar(_ contentView: UIView,
                 config: ((_ config: ShowDropDownConfig) -> Void)? = nil,
                 showClosure: CallBack? = nil,
                 hideClosure: CallBack? = nil,
                 willShowClosure: CallBack? = nil,
                 willHideClosure: CallBack? = nil)

Show.isHaveCoverTabbarView() -> Bool

Show.hideCoverTabbar(_ complete: (() -> Void)? = nil)
```

### Configuration: ShowDropDownConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `effectStyle` | `UIBlurEffect.Style` | `.light` | Blur effect |
| `clickOutHidden` | `Bool` | `true` | Dismiss on tap outside |
| `maskType` | `MaskType` | `.color` | `.color` or `.effect` |
| `bgColor` | `UIColor` | `black 30% alpha` | Background overlay |
| `animateDuration` | `Double` | `0.3` | Animation duration |
| `animateDamping` | `Bool` | `true` | Use spring animation |
| `isAnimate` | `Bool` | `true` | Enable animation |
| `fromY` | `CGFloat` | `88` | Starting Y position (below NavBar) |

### Usage Examples

```swift
// DropDown from below NavBar (default)
Show.coverTabbar(menuView) { config in
    config.fromY = 88
} showClosure: {
    print("DropDown visible")
} hideClosure: {
    print("DropDown hidden")
}

// With will-show/will-hide callbacks
Show.coverTabbar(filterView,
    showClosure: { print("shown") },
    hideClosure: { print("hidden") },
    willShowClosure: { print("about to show") },
    willHideClosure: { print("about to hide") })

// Check visibility
if Show.isHaveCoverTabbarView() {
    Show.hideCoverTabbar()
}

// Hide DropDown
Show.hideCoverTabbar {
    print("Dismiss complete")
}
```

---

## 6. Utility

### Get Top View Controller

```swift
/// Recursively finds the top-most presented view controller
/// Handles: UINavigationController, UITabBarController, UISplitViewController, modal presentations
Show.currentViewController() -> UIViewController?
```

---

## Shared Enums

### MaskType

```swift
public enum MaskType {
    case color   // Solid color background
    case effect  // UIBlurEffect (frosted glass)
}
```

### ToastOffset

```swift
public enum ToastOffset {
    case top
    case center
    case bottom
}
```

### ImageLayoutType

```swift
public enum ImageLayoutType {
    case left  // Image left, text right (horizontal)
    case top   // Image top, text bottom (vertical)
}
```

### PopViewShowType

```swift
public enum PopViewShowType {
    case top
    case left
    case bottom
    case right
    case center  // Zoom animation
}
```

---

## Dark Mode Support

SwiftShow includes built-in dark mode support through UIColor extensions:

```swift
UIColor.blackBGColor  // Adaptive black background
UIColor.whiteBGColor  // Adaptive white background
UIColor.textColor     // Adaptive text color (black/white)
```

These are used as defaults throughout the library.

---

## Common Patterns

### Network Request with Loading

```swift
Show.loading("Loading", subTitle: "Fetching data...")
URLSession.shared.dataTask(with: url) { data, response, error in
    DispatchQueue.main.async {
        Show.hideLoading()
        if let error = error {
            Show.toast("Error", subTitle: error.localizedDescription)
        } else {
            Show.toast("Success", image: UIImage(systemName: "checkmark.circle.fill"))
        }
    }
}.resume()
```

### Confirmation Before Action

```swift
Show.alert(title: "Delete Item",
           message: "This action cannot be undone.",
           leftBtnTitle: "Cancel",
           rightBtnTitle: "Delete",
           rightBlock: {
    // Perform deletion
    Show.toast("Deleted", image: UIImage(systemName: "trash.fill"))
})
```

### Form Submission Flow

```swift
// 1. Show loading
Show.loading("Saving...")

// 2. Submit
api.submit(formData) { result in
    DispatchQueue.main.async {
        // 3. Hide loading
        Show.hideLoading()
        
        switch result {
        case .success:
            Show.toast("Saved successfully")
        case .failure(let error):
            Show.alert(title: "Error", message: error.localizedDescription, rightBtnTitle: "OK")
        }
    }
}
```

### Custom PopView as Action Sheet

```swift
let actionSheet = UIStackView()
actionSheet.axis = .vertical
actionSheet.spacing = 1
// ... add buttons to actionSheet ...

Show.pop(actionSheet) { config in
    config.showAnimateType = .bottom
    config.clickOutHidden = true
    config.animateDamping = true
}
```

---

## Best Practices

1. **Always hide Loading on main thread** - Call `Show.hideLoading()` on the main queue
2. **Toast auto-dismisses** - No need to manually hide, but adjust `showTime` for longer messages
3. **Alert replaces previous** - Calling a new alert automatically hides the existing one
4. **PopView replaces previous** - Only one PopView can be shown at a time
5. **DropDown is singleton-like** - Check `isHaveCoverTabbarView()` before showing to prevent duplicates
6. **Use `enableEvent: true`** for Loading when you want underlying views to remain interactive
7. **Dark mode colors** - Use `UIColor.blackBGColor`, `.whiteBGColor`, `.textColor` for automatic dark mode support
