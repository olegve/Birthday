import SwiftUI


struct CheckmarkToggleStyle: ToggleStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ?
                    Theme.foregroundColor(scheme: colorScheme)
                    :
                    (Theme.foregroundColor(scheme: colorScheme)).opacity(0.5)
                )
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(Theme.backgroundColor(scheme: colorScheme))
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 8, height: 8, alignment: .center)
                                .foregroundColor(configuration.isOn ?
                                    Theme.foregroundColor(scheme: colorScheme)
                                    :
                                    (Theme.foregroundColor(scheme: colorScheme)).opacity(0.5)
                                )
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(.linear(duration: 0.1), value: configuration.isOn)
                ).cornerRadius(20)
                .onTapGesture{ configuration.isOn.toggle() }
        }
    }
}


struct SearchHeaderView: View {
    var body: some View {
        HStack{
            Text("Результат поиска:")
            Spacer()
        }
    }
}


struct TogglePromptView: View {
    var body: some View {
        HStack{
            Spacer()
            Text("Listed.By.month")
        }
    }
}


struct ToggleView: View {
    @Binding var isOn: Bool
    @Environment(\.isSearching) private var isSearching
    @Environment(\.colorScheme) var colorScheme

    let transition = AnyTransition
        .asymmetric(insertion: .slide, removal: .scale)
        .combined(with: .opacity)
    
    var body: some View {
        HStack{
            if isSearching {
                SearchHeaderView().transition(transition)
            } else {
                Toggle(isOn: $isOn){ TogglePromptView() }
                    .transition(transition)
                    .toggleStyle(CheckmarkToggleStyle())
            }
        }
        .animation(.default.speed(1), value: isSearching)
        .foregroundColor(Theme.foregroundColor(scheme: colorScheme))
    }
}


struct TodoRowView_Previews_Container: PreviewProvider {
    struct Container: View {
        @State var isOn = true

        var body: some View {
            Group{
                ToggleView(isOn: $isOn)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .environment(\.colorScheme, .light)
                    .background(LightTheme.background)
                    .previewDisplayName("Переключатель в светлой теме")
                
        
                ToggleView(isOn: $isOn)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .environment(\.colorScheme, .dark)
                    .background(DarkTheme.background)
                    .previewDisplayName("Переключатель в тёмной теме")
            }
            .font(.callout)
        }
    }
    
    static var previews: some View {
        Container()
    }
}


