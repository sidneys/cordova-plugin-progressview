//
// 
//  ProgressView.java
//  Cordova ProgressView
//
//  Created by Sidney Bofah on 2014-11-22.
//

package de.neofonie.cordova.plugin.progressview;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.ProgressDialog;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

public class ProgressView extends CordovaPlugin {

    // private static String LOG_TAG = "CordovaLog";
    private static ProgressDialog progressViewObj = null;

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action The action to execute.
     * @param rawArgs The exec() arguments in JSON form.
     * @param callbackContext The callback context used when calling back into JavaScript.
     * @return Whether the action was valid.
     */
    @Override
    public boolean execute(String action, String rawArgs, CallbackContext callbackContext) {
        /*
         * Don't run any of these if the current activity is finishing in order
         * to avoid android.view.WindowManager$BadTokenException crashing the app.
         */
        if (this.cordova.getActivity().isFinishing()) {
            return true;
        }
        if (action.equals("show")) {
            this.show(rawArgs);
        } else if (action.equals("hide")) {
            this.hide();
        } else if (action.equals("setProgress")) {
            this.setProgress(rawArgs);
        }
        return true;
    }

    /**
     * Init
     */
    private void show(final String rawArgs) {
        final CordovaInterface cordova = this.cordova;
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                if (ProgressView.progressViewObj != null) {
                    ProgressView.progressViewObj.dismiss();
                    ProgressView.progressViewObj = null;
                }
                JSONObject argsObj = null;
                try {
                    argsObj = new JSONObject(rawArgs);
                } catch (JSONException e) {
                    // e.printStackTrace();
                }

                // Theme
                int theme = 5; // ProgressDialog.THEME_DEVICE_DEFAULT_LIGHT
                if (argsObj.has("theme")) {
                    String themeArg = null;
                    try {
                        themeArg = argsObj.getString("theme");
                    } catch (JSONException e) {
                        // e.printStackTrace();
                    }
                    if ("TRADITIONAL".equals(themeArg)) {
                        theme = 1; // ProgressDialog.THEME_TRADITIONAL
                    } else if ("DEVICE_DARK".equals(themeArg)) {
                        theme = 4; // ProgressDialog.THEME_DEVICE_DEFAULT_DARK
                    }
                    if ("HOLO_DARK".equals(themeArg)) {
                        theme = 2; // ProgressDialog.THEME_HOLO_DARK
                    }
                    if ("HOLO_LIGHT".equals(themeArg)) {
                        theme = 3; // ProgressDialog.THEME_HOLO_LIGHT
                    }
                }

                // Type
                int style = ProgressDialog.STYLE_HORIZONTAL;
                if (argsObj.has("type")) {
                    try {
                        if ("CIRCLE".equals(argsObj.getString("type"))) {
                            style = ProgressDialog.STYLE_SPINNER;
                        }
                    } catch (JSONException e) {
                        // e.printStackTrace();
                    }
                }
                // Label
                String label = "";
                if (argsObj.has("label")) {
                    try {
                        label = argsObj.getString("label");
                    } catch (JSONException e) {
                        // e.printStackTrace();
                    }
                }

                ProgressView.progressViewObj = new ProgressDialog(cordova.getActivity(), theme);
                
                ProgressView.progressViewObj.setProgressStyle(style);
                ProgressView.progressViewObj.setTitle("");
                ProgressView.progressViewObj.setMessage(label.replaceAll("^\"|\"$", ""));
                ProgressView.progressViewObj.setCancelable(false);
                ProgressView.progressViewObj.setCanceledOnTouchOutside(false);
                
                ProgressView.progressViewObj.show();
            };
        };
        this.cordova.getActivity().runOnUiThread(runnable);
    }

    /**
     * Hide
     */
    private void hide() {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                ProgressView.progressViewObj.dismiss();
            };
        };
        this.cordova.getActivity().runOnUiThread(runnable);
    }

    /**
     * Set Progress
     * TODO: Add circular progress style (currently limited to bar)
     */
    private void setProgress(final String rawArgs) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                int value = Integer.parseInt(rawArgs);
                ProgressView.progressViewObj.setProgress(value);
            };
        };
        this.cordova.getActivity().runOnUiThread(runnable);
    }

}
