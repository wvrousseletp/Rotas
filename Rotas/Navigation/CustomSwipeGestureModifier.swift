import SwiftUI

public struct CustomSwipeGestureModifier: ViewModifier {
    public var onSwipeLeft: (() -> Void)?
    public var onSwipeRight: (() -> Void)?
    public var minimumDistance: CGFloat = 40.0
    
    @State private var dragOffset: CGSize = .zero
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: minimumDistance, coordinateSpace: .local)
                    .onEnded { value in
                        let dx = value.translation.width
                        let dy = value.translation.height
                        
                        // Strict threshold limit check abs(dx) > abs(dy) * 2.5
                        guard abs(dx) > abs(dy) * 2.5 else { return }
                        
                        if dx < 0 {
                            // Arrastar para a esquerda = Avançar / Próxima Aba
                            onSwipeLeft?()
                        } else if dx > 0 {
                            // Arrastar para a direita = Voltar / Aba Anterior
                            onSwipeRight?()
                        }
                    }
            )
    }
}

public extension View {
    func customSwipeNavigation(
        onSwipeLeft: (() -> Void)? = nil,
        onSwipeRight: (() -> Void)? = nil
    ) -> some View {
        self.modifier(CustomSwipeGestureModifier(onSwipeLeft: onSwipeLeft, onSwipeRight: onSwipeRight))
    }
}
