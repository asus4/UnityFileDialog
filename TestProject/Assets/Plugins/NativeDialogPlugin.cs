using UnityEngine;
using System;
using System.Collections;
using System.Runtime.InteropServices;


[AddComponentMenu("")] // hide from menu
public class NativeDialogPlugin : MonoBehaviour {

	
#region singleton
	static NativeDialogPlugin _instance;
	
	public static NativeDialogPlugin instance {
		get {
			if(_instance == null) {
				GameObject go = new GameObject(typeof(NativeDialogPlugin).ToString());
				_instance = go.AddComponent<NativeDialogPlugin>();
				DontDestroyOnLoad(_instance);
				Application.runInBackground = true;
			}
			return _instance;
		}
	}
#endregion

#region inner
	enum Mode {
		OPEN,
		SAVE
	}
	public delegate void NativeDialogDelegate (string path);
	
#endregion

	Mode mode;
	
	bool _requesting;
	bool requestiong {
		get {
			return _requesting;
		}
		set {
			_requesting = value;
			this.enabled = value;
		}
	}
	NativeDialogDelegate openDelegate;
	NativeDialogDelegate saveDelegate;

	void Update() {
		if(!_requesting) {
			this.enabled = false;
			return;
		}
		
		if(mode == Mode.OPEN) {
			if(hasOpenResult() > 0) {
				string path = Marshal.PtrToStringAuto (getOpenPath());
				openDelegate(path);
				requestiong = false;
			}			
		}
		else if(mode == Mode.SAVE) {
			if(hasSaveResult() > 0) {
				string path = Marshal.PtrToStringAuto (getSavePath());
				saveDelegate(path);
				requestiong = false;
			}
		}
	}
	
	public void openPanel(NativeDialogDelegate del) {
		if(_requesting) {
			Debug.LogWarning("now requesting");	
			return;
		}
		openDelegate = del;
		nativeOpenPanel();
		mode = Mode.OPEN;
		requestiong = true;
	}
	
	public void savePanel(NativeDialogDelegate del) {
		if(_requesting) {
			Debug.LogWarning("now requesting");	
			return;
		}
		saveDelegate = del;
		nativeSavePanel();
		mode = Mode.SAVE;
		requestiong = true;
	}
	
#region native methods	
	
#if UNITY_EDITOR || UNITY_STANDALONE_OSX
	[DllImport("UnityNativeDialogPlugin")]
	private static extern void nativeSavePanel();
	[DllImport("UnityNativeDialogPlugin")]
	private static extern void nativeOpenPanel();
	[DllImport("UnityNativeDialogPlugin")]
	private static extern uint hasOpenResult();
	[DllImport("UnityNativeDialogPlugin")]
    private static extern uint hasSaveResult();
	[DllImport("UnityNativeDialogPlugin")]
    private static extern IntPtr getOpenPath();
	[DllImport("UnityNativeDialogPlugin")]
    private static extern IntPtr getSavePath();
#else
	private static void nativeSavePanel() {
		Debug.LogError("error");
	}
	private static void nativeOpenPanel() {
		Debug.LogError("error");
	}
#endif

#endregion

}
