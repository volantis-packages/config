class ParameterState extends StateBase {
    parameters := ""
    parameterKey := ""

    __New(parameters, parameterKey, versionSorter, schemaVersion := "", autoLoad := false) {
        this.parameters := parameters
        this.parameterKey := parameterKey
        super.__New(versionSorter, "", schemaVersion, autoLoad)
    }

    SaveState(newState := "") {
        super.SaveState(newState)

        if (this.parameterKey) {
            this.parameters[this.parameterKey] := this.stateMap
        }

        return this.stateMap
    }

    LoadState(reload := false) {
        if (this.parameterKey && (!this.stateLoaded || reload)) {
            newState := super.LoadState()

            if (this.parameters.Has(this.parameterKey)) {
                paramValue := this.parameters[this.parameterKey]

                if (HasBase(paramValue, Map.Prototype)) {
                    for key, value in paramValue {
                        newState[key] := value
                    }
                }
            }

            this.stateMap := newState
            this.stateLoaded := true
        }

        return this.stateMap
    }
}
