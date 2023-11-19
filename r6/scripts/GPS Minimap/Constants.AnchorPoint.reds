module GpsMinimap.Constants.AnchorPoint

// Quest Widget - Default (Minimap ON) position
class QuestWidget_Default {
    public static func GetCoefficient() -> Vector2 {
        return new Vector2(-0.001295, -0.001794);
    }

    public static func GetOffset() -> Vector2 {
        return new Vector2(0.5694, 0.02);
    }
}

// Quest Widget - Corner (Minimap OFF) position
class QuestWidget_Corner {
    public static func GetCoefficient() -> Vector2 {
        return new Vector2(-0.001295, -0.000338);
    }

    public static func GetOffset() -> Vector2 {
        return new Vector2(0.5694, 0.021);
    }
}
