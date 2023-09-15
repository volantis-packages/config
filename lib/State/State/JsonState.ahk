class JsonState extends StateBase {
    filePath := ""

    __New(filePath, versionSorter, schemaVersion := "", autoLoad := false) {
        this.filePath := filePath
        super.__New(versionSorter, "", schemaVersion, autoLoad)
    }

    SaveState(newState := "") {
        if (newState != "") {
            this.stateMap := newState
        }

        if (this.filePath) {
            stateToSave := Map("State", this.stateMap)
            data := JsonData(stateToSave)
            jsonString := data.ToString("", 4)

            if (jsonString == "") {
                throw(OperationFailedException("Converting state map to JSON failed", "JsonState", stateToSave))
            }

            if (FileExist(this.filePath)) {
                FileDelete(this.filePath)
            }

            FileAppend(jsonString, this.filePath)
        }

        return this.stateMap
    }

    LoadState() {
        if (this.filePath && !this.stateLoaded) {
            newState := super.LoadState()

            if (FileExist(this.filePath)) {
                jsonString := Trim(FileRead(this.filePath))

                if (jsonString != "") {
                    data := JsonData()
                    jsonObj := data.FromString(&jsonString)

                    if (jsonObj.Has("State")) {
                        for key, value in jsonObj["State"] {
                            newState[key] := value
                        }
                    }
                }
            }

            this.stateMap := newState
            this.stateLoaded := true
        }

        return this.stateMap
    }
}
