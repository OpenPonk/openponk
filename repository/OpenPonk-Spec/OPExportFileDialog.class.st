"
Coordinates user interaction for exporting textual and model data to a file. Presents a modal save-file dialog with a prefilled sanitized filename and appropriate extension filters, writes the content upon confirmation, and displays a user notification.
"
Class {
	#name : 'OPExportFileDialog',
	#superclass : 'Object',
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'opening' }
OPExportFileDialog class >> exportBlock: aZeroArgBlock defaultFileName: aFileName extensions: aCollectionOfExtensions named: aFilterTitle title: aDialogTitle [
	| dialog |
	dialog := StSaveFilePresenter new
		title: aDialogTitle;
		extensions: aCollectionOfExtensions named: aFilterTitle;
		nameText: aFileName;
		okAction: [ :file |
			| content message |
			content := aZeroArgBlock value.
			file
				ensureDelete;
				writeStreamDo: [ :stream | stream << content asString ].
			message := String streamContents: [ :notificationStream |
				notificationStream << 'Exported to ' << file pathString.
				notificationStream cr; cr.
				notificationStream << 'Click to open location' ].
			(ProvideAnswerNotification signal: message) ifNil: [
				(GrowlMorph openWithLabel: 'Information' translated contents: message)
					vanishDelay: 5 seconds;
					actionBlock: [ file openInOSFileBrowser ] ] ];
		yourself.
	dialog openModal
]
