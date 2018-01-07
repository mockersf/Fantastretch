// Generated using Sourcery 0.10.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

extension SettingsExerciseType {

    func copy() -> SettingsExerciseType {
        return SettingsExerciseType(
            timerActive: timerActive,
            timerRest: timerRest,
            musclePreferences: musclePreferences,
            nbOfExercises: nbOfExercises,
            nbRepetitions: nbRepetitions,
            advancedAbs: advancedAbs
        )
    }
}
