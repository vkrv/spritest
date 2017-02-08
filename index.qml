Item {
	id: app;
	anchors.fill: context;
	property string source;
	source: "res/szombie1w.png";

	Image {
		id: wholeImg;
		fillMode: Image.PreserveAspectFit;
		source: app.source;
		width: Math.min(600, 100% - x - 30);
		height: spriteRect.height;
		y: 20;
		x: spriteRect.width + 50;

		Rectangle {
			anchors.centerIn: parent;
			width: parent.paintedWidth; height: parent.paintedHeight;
			border.width: 1; border.color: "#039BE5";

			Text {
				y: 100% + 5;
				color: "#626262";
				text: "Source height:<b> " + testSprite.paintedHeight + "</b>, width: <b> "
					+ testSprite.paintedWidth + "</b>";
			}

			Rectangle {
				x: (testSprite.currentFrame % testSprite.cols) * width;
				y: Math.floor(testSprite.currentFrame / testSprite.cols) * height;
				width: testSprite.width / testSprite.paintedWidth * 100%;
				height: testSprite.height / testSprite.paintedHeight * 100%;
				border.width: 1; 
				border.color: (testSprite.height > testSprite.paintedHeight) || (testSprite.width > testSprite.paintedWidth) ? "red" : "#4CAF50";
			}
		}
	}

	ResizableBox {
		id: spriteRect;
		y: 20; x: 20;
		color: colorInput.color;
		border.width: 0;
		effects.shadow.y: 1;
		effects.shadow.blur: 20;
		effects.shadow.spread: 1;

		AnimatedSprite {
			id: testSprite;
			property int cols: Math.floor(paintedWidth / width);
			source: app.source;
			width: 100%;
			height: 100%;
		}

		Rectangle {
			width: 100%;
			height: 100%;
			property HoverMixin hover: HoverMixin {}
			color: "#00000044";
			opacity: hover.value;
			Behavior on opacity { Animation { duration: 300; }}

			MaterialButton {
				icon: "remove_circle_outline";
				x: 20; y: 2;
				onClicked: { spriteRect.width--; }
			}

			MaterialButton {
				icon: "add_circle_outline";
				x: 40; y: 2;
				onClicked: { spriteRect.width++; }
			}

			MaterialButton {
				icon: "remove_circle_outline";
				x: 2; y: 20;
				onClicked: { spriteRect.height--; }
			}

			MaterialButton {
				icon: "add_circle_outline";
				x: 2; y: 40;
				onClicked: { spriteRect.height++; }
			}
		}


		Text {
			y: 100% + 4;
			color: "#212121";
			font.pixelSize: 10;
			text: testSprite.width + " x " + testSprite.height;
		}
	}

	Column {
		width: wholeImg.width + wholeImg.x;
		x: 20; y: Math.max(spriteRect.height, wholeImg.height) + 50;
		spacing: 12;

		Text {
			font.pixelSize: 12;
			font.weight: 300;
			color: "#414141";
			text: "Load file or set URL";
		}

		FileInput {
			onValueChanged: {
				var self = this;
				var file    = self.element.dom.files[0];
				var reader  = new FileReader();

				reader.onloadend = function () {
					self.testSprite.stop();
					self.app.source = reader.result;
				}

				if (file)
					reader.readAsDataURL(file);
			}
		}

		Row {
			spacing: 10;

			TextInput {
				id: urlInput;
				height: 32; width: 200;
				font.pixelSize: 16;
				paddings.left: 8;
				Border { width: 1; color: "#AAA"; }
			}

			WebItem {
				width: 80; height: 30;
				radius: 5;
				border.width: 1;
				border.color: "#0288D1";
				color: hover ? border.color : "transparent";
				Behavior on background { Animation { duration: 500; }}
				TextMixin {
					text: "Set URL";
					color: parent.hover ? "white" : "#626262";
					Behavior on color { Animation { duration: 500; }}
				}
				onClicked: { testSprite.stop(); app.source = urlInput.text; }
			}
		}

		InputWrapper {
			property int safeNum: Math.floor(testSprite.paintedWidth / testSprite.width) * Math.floor(testSprite.paintedHeight / testSprite.height);
			text: "Total number of frames "  + (safeNum < testSprite.totalFrames ? '<span style="color:#EE5555;" >(safe number is ' + safeNum + ')</span>' : '<span style="color:#55AA55;">(number is safe)</span>');
			NumberInput {
				id: frames;
				height: 100%; width: 60;
				font.pixelSize: 16;
				onValueChanged: { testSprite.totalFrames = value; if (testSprite.running) testSprite.restart() }
				Border { width: 1; color: "#AAA"; }
				onCompleted: { this.value = 6;}
			}
		}

		InputWrapper { 
			text: "Duration of the animation (" + Math.floor(100000 / testSprite.interval) / 100 + " fps)"; 
			NumberInput {
				id: durationInput;
				height: 100%; width: 60;
				font.pixelSize: 16;
				onValueChanged: { testSprite.duration = value; if (testSprite.running) testSprite.restart() }
				Border { width: 1; color: "#AAA"; }
				onCompleted: { this.value = 600;}
			}
		}

		InputWrapper { text: "Frame width"; NumberInput {
			id: widthInput;
			height: 100%; width: 60;
			value: spriteRect.width;
			font.pixelSize: 16;
			onValueChanged: { spriteRect.width = value; if (testSprite.running) testSprite.restart() }
			Border { width: 1; color: "#AAA"; }
			onCompleted: { this.value = 121;}
		}}

		InputWrapper { text: "Frame height"; NumberInput {
			id: heightInput;
			height: 100%; width: 60;
			value: spriteRect.height;
			font.pixelSize: 16;
			onValueChanged: { spriteRect.height = value; if (testSprite.running) testSprite.restart() }
			Border { width: 1; color: "#AAA"; }
			onCompleted: { this.value = 181;}
		}}

		InputWrapper { text: "Background color"; ColorInput {
			id: colorInput;
			height: 100%; width: 60;
			color: "#FFFFFF";
			Border { width: 1; color: "#AAA"; }
		}}

		Row {
			spacing: 8;
			WebItem {
				width: 80; height: 30;
				radius: 5;
				border.width: 1;
				border.color: testSprite.running ? "#EF6C00" : "#8BC34A";
				color: hover ? border.color : "transparent";
				Behavior on background { Animation { duration: 500; }}
				TextMixin {
					text: testSprite.running ? "Pause" : "Start";
					color: parent.hover ? "white" : "#626262";
					Behavior on color { Animation { duration: 500; }}
				}
				onClicked: { testSprite.running = !testSprite.running; }
			}
			WebItem {
				width: 30; height: 30;
				radius: 16;
				border.width: 1;
				border.color: "#0097A7";
				color: testSprite.repeat ? "#0097A7" : "transparent";
				Behavior on background { Animation { duration: 250; }}
				MaterialIcon {
					anchors.centerIn: parent;
					text: "autorenew";
					color: testSprite.repeat ? "white" : "#0097A7";
					Behavior on color { Animation { duration: 250; }}
				}
				onClicked: { testSprite.repeat = !testSprite.repeat; }
			}
		}

		Row {
			spacing: 5;
			height: 32;
			Text {
				anchors.verticalCenter: parent.verticalCenter;
				font.pixelSize: 20;
				font.weight: 300;
				color: "#626262";
				text: "Current frame ";
			}

			MaterialButton {
				y: 5;
				color: "#00695C";
				icon: 'fast_rewind';
				onClicked: { testSprite.currentFrame = (--testSprite.currentFrame + testSprite.totalFrames ) % testSprite.totalFrames }
			}

			Text {
				anchors.verticalCenter: parent.verticalCenter;
				font.pixelSize: 20;
				font.weight: 300;
				color: "#414141";
				text: testSprite.currentFrame;
			}

			MaterialButton {
				y: 5;
				color: "#00695C";
				icon: "fast_forward";
				onClicked: { testSprite.currentFrame = ++testSprite.currentFrame % testSprite.totalFrames }
			}
		}
	}
}
