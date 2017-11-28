private
retrieveContextMenuMapping
	^ contextMenuMapping ifNil: [ contextMenuMapping := self contextMenuMapping asDictionary ]