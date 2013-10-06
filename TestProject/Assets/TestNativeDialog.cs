using UnityEngine;
using System.Collections;

public class TestNativeDialog : MonoBehaviour {
	
	NativeDialogPlugin dialog;
	
	void Awake() {
		dialog = NativeDialogPlugin.instance;
		Debug.Log(dialog);
	}

	void OnGUI () {
		if(GUILayout.Button("open panel")) {
			dialog.openPanel((string path) => {
				Debug.Log("open:"+path);
			});
		}
		
		if(GUILayout.Button("save panel")) {
			dialog.savePanel((string path) => {
				Debug.Log("save:"+path);
			});
		}
	}
}
