module GpsMinimap.Math

public func GetAnchorPoint(screenSize: Vector2, coef: Vector2, offset: Vector2) -> Vector2 {
    let anchorX: Float = 0.0;
    let anchorY: Float = 0.0;

    anchorX = (screenSize.X * coef.X) + offset.X;
    anchorY = (screenSize.Y * coef.Y) + offset.Y;

    return new Vector2(anchorX, anchorY);
}
