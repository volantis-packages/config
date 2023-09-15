class StateBase {
    stateMap := Map()
    stateLoaded := false
    versionSorter := ""
    schemaVersion := 0

    State {
        get => this.GetState()
        set => this.stateMap := this.SaveState(value)
    }

    Version {
        get => this.State.Has("Version") ? this.State["Version"] : 0
        set => this.State["Version"] := value
    }

    ; State being outdated means that it might have the wrong structure, not that the data is necessarily old.
    IsStateOutdated() {
        return this.versionSorter.IsOutdated(this.Version, this.schemaVersion)
    }

    __New(versionSorter, state := "", schemaVersion := "", autoLoad := false) {
        this.versionSorter := versionSorter

        if (schemaVersion == "") {
            schemaVersion := 0
        }

        this.schemaVersion := schemaVersion

        if (state != "") {
            this.stateMap := state
        }

        if (autoLoad) {
            this.LoadState()
        }
    }

    GetState() {
        return this.stateLoaded ? this.stateMap : this.LoadState()
    }

    /**
    * ABSTRACT METHODS
    */

    SaveState(newState := "") {
        if (newState != "") {
            this.stateMap := newState
        }
    }

    LoadState(reload := false) {
        return Map("Version", this.schemaVersion)
    }
}
