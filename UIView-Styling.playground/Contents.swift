//: Playground - noun: a place where people can play

import UIKit


/// An abstraction if `UIView` styling.
struct UIViewStyle<T: UIView> {
    
    /// The styling function that takes a `UIView` instance 
    /// and performs side-effects on it.
    let styling: (T)-> Void
    
    /// A factory method that composes multiple styles.
    ///
    /// - Parameter styles: The styles to compose.
    /// - Returns: A new `UIViewStyle` that will call the input styles' 
    ///            `styling` method in succession.
    static func compose(_ styles: UIViewStyle<T>...)-> UIViewStyle<T> {
        
        return UIViewStyle { view in
            for style in styles {
                style.styling(view)
            }
        }
    }
    
    /// Compose this style with another.
    ///
    /// - Parameter other: Other style to compose this style with.
    /// - Returns: A new `UIViewStyle` which will call this style's `styling`,
    ///            and then the `other` style's `styling`.
    func composing(with other: UIViewStyle<T>)-> UIViewStyle<T> {
        return UIViewStyle { view in
            self.styling(view)
            other.styling(view)
        }
    }
    
    /// Compose this style with another styling function.
    ///
    /// - Parameter otherStyling: The function to compose this style with.
    /// - Returns: A new `UIViewStyle` which will call this style's `styling`,
    ///            and then the input `styling`.
    func composing(with otherStyling: @escaping (T)-> Void)-> UIViewStyle<T> {
        return self.composing(with: UIViewStyle(styling: otherStyling))
    }
    
    
    /// Apply this style to a UIView.
    ///
    /// - Parameter view: the view to style
    func apply(to view: T) {
        styling(view)
    }
    
    
    /// Apply this style to multiple views.
    ///
    /// - Parameter views: the views to style
    func apply(to views: T...) {
        for view in views {
            styling(view)
        }
    }
}

// Creating a new style:

let smallLabelStyle: UIViewStyle<UILabel> = UIViewStyle { label in
    label.font = label.font.withSize(12)
}

let lightLabelStyle: UIViewStyle<UILabel> = UIViewStyle { label in
    label.textColor = .lightGray
}

// Creating a new style by composing two different styles:

let captionLabelStyle: UIViewStyle<UILabel> = .compose(smallLabelStyle, lightLabelStyle)

// Alternative way:

let otherCaptionLabelStyle = smallLabelStyle.composing(with: lightLabelStyle)

// You can also create a style by adding composing an existing
// style with another styling function:

let darkCaptionLabelStyle: UIViewStyle<UILabel> = captionLabelStyle.composing { label in
        label.textColor = .darkGray
    }

// Styling a view in a `UIViewController`:

class ViewController: UIViewController {
    
    let captionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionLabelStyle.apply(to: captionLabel)
    }
    
}