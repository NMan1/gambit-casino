//
//  avatar.swift
//  node
//
//  Created by Nick Mantini on 11/11/24.
//

import SwiftUI

struct Avatar: View {
    var firstName: String
    var lastName: String
    var color: Color?
    
    var body: some View {
        ZStack {
            let name = "\(firstName.first!)\(lastName.first!)"
            Circle().fill((self.color != nil ? self.color : Color(.gray))!).frame(width: 50, height: 50)
            Text(name).foregroundStyle(Color(UIColor.white))
        }
    }
}
