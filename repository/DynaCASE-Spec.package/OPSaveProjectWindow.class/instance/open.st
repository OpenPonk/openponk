instance creation
open
	projectController project storageFolder ifNotNil: [ ^ self basicSave ].
	self openDialogWithSpec
		okAction: [ self save ];
		cancelAction: [ self cancel ]