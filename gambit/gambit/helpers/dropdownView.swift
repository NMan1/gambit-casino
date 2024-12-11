//
//  dropdownView.swift
//  gambit
//
//  Created by Nick Mantini on 11/28/24.
//

import SwiftUI

struct CustomDropViewModel {
    let iconName: String
    var title: String
    var color: Color
    var bulletContent: [String]
}

struct CustomDropView: View {
    @State var viewList: [CustomDropViewModel]
    @State var symbolName: String
    @State var title: String
    @State var showList = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: symbolName)
                
                Text(title)
                    .font(.title3)
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(showList ? 90 : 0))
            }
            .bold()
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.deepCharcoal)
                    .stroke(.duskGreen, lineWidth: 3)
            }
            .padding(.horizontal, 2)
            .onTapGesture {
                withAnimation {
                    showList.toggle()
                }
            }
            
            if showList {
                ForEach(viewList, id: \.title) { item in
                    VStack {
                        HStack {
                            HStack {
                                Image(systemName: item.iconName)
                                    .foregroundStyle(item.color)
                                
                                Text(item.title)
                                    .bold()
                            }
                            
                            Spacer()
                        }
                        
                        Divider()
                            .frame(minHeight: 1)
                            .background(.gray)
                        
                        VStack(alignment: .leading) {
                            ForEach(item.bulletContent, id: \.self) { content in
                                Text("• " + content)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(nil)
                                    .truncationMode(.head)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                    .background(item.color.opacity(0.4), in: RoundedRectangle(cornerRadius: 15))
                }
            }
        }
    }
}
