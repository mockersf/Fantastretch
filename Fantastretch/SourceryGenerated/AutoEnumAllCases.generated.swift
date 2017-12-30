// Generated using Sourcery 0.10.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

extension Abs {
    static let count: Int = 4
    static let allCases: [Abs] = [
        .Global,
        .AbsExternalOblique,
        .AbsInternalOblique,
        .AbsTransverse,
    ]
}

extension Muscle {
    static let count: Int = 16
    static let allCases: [Muscle] = [
        .Triceps,
        .Biceps,
        .Forearms,
        .Shoulders,
        .Back,
        .Chest,
        .Abs,
        .AbsExternalOblique,
        .AbsInternalOblique,
        .AbsTransverse,
        .Glutes,
        .Quads,
        .HipFlexors,
        .Hamstrings,
        .Calves,
        .Global,
    ]
}

extension Repeat {
    static let count: Int = 2
    static let allCases: [Repeat] = [
        .Once,
        .EachSide,
    ]
}
