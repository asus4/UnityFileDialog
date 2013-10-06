using UnityEngine;
using System.Collections;

public class TestNativeDialog : MonoBehaviour {
	
	NativeDialogPlugin dialog;
	
	void Awake() {
		dialog = NativeDialogPlugin.instance;
		Debug.Log(dialog);
	}

	void OnGUI () {
		if(GUILayout.Button("open panel", GUILayout.MinHeight(50), GUILayout.MinWidth(100))) {
			dialog.openPanel((string path) => {
				Debug.Log("open:"+path);
			});
		}
		
		if(GUILayout.Button("save panel", GUILayout.MinHeight(50), GUILayout.MinWidth(100))) {
			dialog.savePanel((string path) => {
				Debug.Log("save:"+path);
			});
		}
	}
}
