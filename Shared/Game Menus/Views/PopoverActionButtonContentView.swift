//
//  PopoverActionButtonContentView.swift
//  glide Demo
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import GlideEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class PopoverActionButtonContentView: SelectionButtonContentView {
    
    lazy var label: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.defaultTextColor
        label.font = Font.actionButtonTextFont(ofSize: actionButtonFontSize)
        label.textAlignment = .center
        return label
    }()
    
    init(title: String) {
        super.init(normalBackgroundColor: .clear)
        
        label.text = title
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
            ])
    }
}
