//
// 
//  ProgressView.java
//  Cordova ProgressView
//
//  Created by Sidney Bofah on 2014-11-22.
//

package de.neofonie.cordova.plugin.progressview;

import android.app.ProgressDialog;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class ProgressView extends CordovaPlugin {

    //private static String LOG_TAG = "CordovaLog";
    private static ProgressDialog progressViewObj = null;
    private CallbackContext callback = null;

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action          {String}  The action to execute.
     * @param args            {String} The exec() arguments in JSON form.
     * @param callbackContext The callback context used when calling back into JavaScript.
     * @return Whether the action was valid.
     */
    @Override
    public boolean execute(String action, String args, CallbackContext callbackContext) {
        /*
         * Don't run any of these if the current activity is finishing in order
         * to avoid android.view.WindowManager$BadTokenException crashing the app.
         */
        callback = callbackContext;

        if (this.cordova.getActivity().isFinishing()) {
            return true;
        }
        switch (action) {
            case "show":
                this.show(args);
                break;
            case "hide":
                this.hide();
                break;
            case "setProgress":
                this.setProgress(args);
                break;
        }
        return true;
    }


    /**
     * Init
     */
    private void show(final String args) {
        //Log.v(LOG_TAG, rawArgs);
        final CordovaInterface cordova = this.cordova;
        Runnable runnable = new Runnable() {
            @Override
            public void run() {

                // Check State
                if (ProgressView.progressViewObj != null) {
                    PluginResult result = new PluginResult(PluginResult.Status.ERROR, "(Cordova ProgressView) (Show) ERROR: Dialog already showing");
                    result.setKeepCallback(true);
                    callback.sendPluginResult(result);
                    return;
                }

                // Get Arguments
                JSONArray argsObj = null;
                try {
                    argsObj = new JSONArray(args);
                } catch (JSONException e) {
                    // e.printStackTrace();
                }

                // Reset
                ProgressView.progressViewObj = null;

                // Set Text
                String label = "";
                try {
                    if (argsObj.get(0) != null) {
                        try {
                            label = argsObj.getString(0);
                        } catch (JSONException e) {
                            // e.printStackTrace();
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                // Set Type
                int style = ProgressDialog.STYLE_HORIZONTAL;
                try {
                    if (argsObj.get(1) != null) {
                        try {
                            if ("CIRCLE".equals(argsObj.getString(1))) {
                                style = ProgressDialog.STYLE_SPINNER;
                            }
                        } catch (JSONException e) {
                            // e.printStackTrace();
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                // Set Theme
                Integer theme = 5; // ProgressDialog.THEME_DEVICE_DEFAULT_LIGHT
                try {
                    if (argsObj.get(2) != null) {
                        String themeArg = null;
                        try {
                            themeArg = argsObj.getString(0);
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
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                // Show
                ProgressView.progressViewObj = new ProgressDialog(cordova.getActivity(), theme);
                ProgressView.progressViewObj.setProgressStyle(style);
                ProgressView.progressViewObj.setTitle("");
                ProgressView.progressViewObj.setMessage(label.replaceAll("^\"|\"$", ""));
                ProgressView.progressViewObj.setCancelable(false);
                ProgressView.progressViewObj.setCanceledOnTouchOutside(false);
                ProgressView.progressViewObj.show();

                // Callback
                PluginResult result = new PluginResult(PluginResult.Status.OK, "(Cordova ProgressView) (Show) OK");
                result.setKeepCallback(true);
                callback.sendPluginResult(result);
            }

            ;
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

                // Check State
                if (ProgressView.progressViewObj == null) {
                    PluginResult result = new PluginResult(PluginResult.Status.ERROR, "(Cordova ProgressView) (Hide) ERROR: No dialog to hide");
                    result.setKeepCallback(true);
                    callback.sendPluginResult(result);
                    return;
                }

                // Hide
                ProgressView.progressViewObj.dismiss();
                ProgressView.progressViewObj = null;

                // Callback
                PluginResult result = new PluginResult(PluginResult.Status.OK, "(Cordova ProgressView) (Hide) OK");
                result.setKeepCallback(true);
                callback.sendPluginResult(result);
            }
        };
        this.cordova.getActivity().runOnUiThread(runnable);
    }

    /**
     * Set Progress
     * TODO: Add circular progress style (currently limited to bar)
     */
    private void setProgress(final String args) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {

                // Check State
                if (ProgressView.progressViewObj == null) {
                    PluginResult result = new PluginResult(PluginResult.Status.ERROR, "(Cordova ProgressView) (setProgress) ERROR: No dialog to update");
                    result.setKeepCallback(true);
                    callback.sendPluginResult(result);
                    return;
                }

                // Get Arguments
                JSONArray argsObj = null;
                try {
                    argsObj = new JSONArray(args);
                } catch (JSONException e) {
                    // e.printStackTrace();
                }

                // Convert variable number types
                Double doubleValue = 0.0;
                Integer intValue;
                try {
                    doubleValue = argsObj.getDouble(0);
                    doubleValue = doubleValue * 100;
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                intValue = doubleValue.intValue();

                // Set Progress
                ProgressView.progressViewObj.setProgress(intValue);

                // Callback
                PluginResult result = new PluginResult(PluginResult.Status.OK, "(Cordova ProgressView) (Set) OK");
                result.setKeepCallback(true);
                callback.sendPluginResult(result);
            }
        };
        this.cordova.getActivity().runOnUiThread(runnable);
    }

}