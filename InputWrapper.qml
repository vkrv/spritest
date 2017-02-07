Item {
	property string text;
	height: 32;
	width: decsText.width + 70;

	Text {
		id: decsText;
		x: 70;
		anchors.verticalCenter: parent.verticalCenter;
		font.pixelSize: 20;
		font.weight: 300;
		color: "#626262";
		text: parent.text;
	}
}