visiting
visitMemoDescription: aMemoDescription
	(form addText: aMemoDescription label)
		text: (aMemoDescription accessor read: controller);
		whenTextIsAccepted: [ :newValue | aMemoDescription accessor write: newValue to: controller ]