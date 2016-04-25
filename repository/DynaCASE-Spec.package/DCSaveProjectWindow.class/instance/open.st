instance creation
open
	projectController project storageFolder ifNotNil: [ ^ self save ].
	self openDialogWithSpec
		okAction: [ self save ];
		cancelAction: [ self cancel ]