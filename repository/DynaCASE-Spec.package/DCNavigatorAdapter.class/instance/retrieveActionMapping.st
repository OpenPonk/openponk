private
retrieveActionMapping
	^ actionMapping ifNil: [ actionMapping := self actionMapping asDictionary ]