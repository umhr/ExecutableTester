package 
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Text;
	import com.bit101.components.TextArea;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author umhr
	 */
	[SWF(width = 465, height = 465, backgroundColor = 0x222222, frameRate = 30)]
	public class Main extends Sprite 
	{
		
		private var _file:File;
		private var _nativeProcess:NativeProcess;
		private var _path:Text;
		private var _arg0:Text;
		private var _arg1:Text;
		private var _arg2:Text;
		private var _arg3:Text;
		private var _textArea:TextArea;
		
		public function Main ()
		{
			init();
		}
		
		private function init():void {
			Style.embedFonts = false;
			Style.fontName = "_等幅";
			Style.fontSize = 13;
			Style.setStyle(Style.DARK);
			new Label(this, 8, 8, "Path:");
			_path = new Text(this, 50, 8, "C:/Windows/System32/notepad.exe");
			_path.width = stage.stageWidth - 8 - _path.x;
			_path.height = 20;
			_path.textField.wordWrap = _path.textField.multiline = false;
			
			new Label(this, 8, 10 + 26 * 1, "Argument[0]:");
			_arg0 = new Text(this, 100, 10 + 26 * 1);
			_arg0.width = stage.stageWidth - 8 - _arg0.x;
			_arg0.height = 20;
			new Label(this, 8, 10 + 26 * 2, "Argument[1]:");
			_arg1 = new Text(this, 100, 10 + 26 * 2);
			_arg1.width = stage.stageWidth - 8 - _arg1.x;
			_arg1.height = 20;
			new Label(this, 8, 10 + 26 * 3, "Argument[2]:");
			_arg2 = new Text(this, 100, 10 + 26 * 3);
			_arg2.width = stage.stageWidth - 8 - _arg2.x;
			_arg2.height = 20;
			new Label(this, 8, 10 + 26 * 4, "Argument[3]:");
			_arg3 = new Text(this, 100, 10 + 26 * 4);
			_arg3.width = stage.stageWidth - 8 - _arg3.x;
			_arg3.height = 20;
			
			
			new PushButton(this, stage.stageWidth - 108, 142, "Execute", onExecute);
			_textArea = new TextArea(this, 8, 180);
			_textArea.width = stage.stageWidth - 16;
			_textArea.height = 465 - _textArea.y - 8;
		}
		
		private function onExecute(e:Event):void {
			if (_file != null) {
				_file.cancel();
				_file = null;
			}
			
			_file = new File(_path.text);
			var text:String = "";
			var arguments:Vector.<String>;
			var nativeProcessStartupInfo:NativeProcessStartupInfo;
			
			text += "NativeProcess.isSupported : " + NativeProcess.isSupported + "\n";
			text += "file.exists : " + _file.exists + "\n";
			if (NativeProcess.isSupported && _file.exists) {
				// 引数（不要なら付けなくても良い）
				arguments = new Vector.<String>();
				if(_arg0.text.length > 0){
					arguments[0] = _arg0.text;
				}
				if(_arg1.text.length > 0){
					arguments[1] = _arg1.text;
				}
				if(_arg2.text.length > 0){
					arguments[2] = _arg2.text;
				}
				if(_arg3.text.length > 0){
					arguments[3] = _arg3.text;
				}
				
				nativeProcessStartupInfo = new NativeProcessStartupInfo();
				if(arguments.length > 0){
					nativeProcessStartupInfo.arguments = arguments;
				}
				nativeProcessStartupInfo.executable = _file;
				
				_nativeProcess = new NativeProcess();
				_nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
				_nativeProcess.start(nativeProcessStartupInfo);
				
				text += "nativeProcess.running : " + _nativeProcess.running;
			}
			
			_textArea.text = text;
			
		}
		
		/**
		 * 標準出力から読む
		 * @param	event
		 */
		private function onOutputData (event:ProgressEvent):void
		{
			_textArea.text += "\n";
			_textArea.text += _nativeProcess.standardOutput.readUTFBytes(_nativeProcess.standardOutput.bytesAvailable);
		}
	}
}