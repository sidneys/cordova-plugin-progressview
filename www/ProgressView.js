//
//
//  ProgressView.js
//  Cordova ProgressView
//
//  Created by Sidney Bofah on 2014-11-21.
//

var exec = require('cordova/exec');

module.exports = {

    /**
     * Shows a native determinate progress dialog.
     *
     * @param {String} viewLabel - Dialog Title, defaults to 'Please Wait...'
     * @param {String} viewShape - "CIRCLE", "HORIZONTAL"
     * @param {String} isIndefinite - "CIRCLE", "HORIZONTAL"
     * @param {String} viewThemeAndroid -  (Android only) "TRADITIONAL", "DEVICE_DARK", "DEVICE_LIGHT", "HOLO_DARK", "HOLO_LIGHT"
     * @param successCallback
     * @param errorCallback
     * @returns {*}
     */
    show: function (viewLabel, viewShape, isIndefinite, viewThemeAndroid, successCallback, errorCallback) {
        label = viewLabel || "Please Wait...";
        shape =  viewShape || "";
        indefinite = isIndefinite || false;
        theme = viewThemeAndroid || "DEVICE_LIGHT";

        return exec(successCallback, errorCallback, 'ProgressView', 'show', [label, shape, indefinite, theme]);
    },
    

    /**
     * Sets progress percentage via float-based fraction.
     *
     * @param {float} progressPercentage
     * @param successCallback
     * @param errorCallback
     * @returns {*}
     */
    setProgress: function (progressPercentage, successCallback, errorCallback) {
        value = parseFloat(progressPercentage);

        return exec(successCallback, errorCallback, 'ProgressView', 'setProgress', [value]);
    },
   

   /**
    * Updates the text label of an existing progress view, e.g. for feedback to the user.
    *
    * @param {String} viewLabel
    * @param successCallback
    * @param errorCallback
    * @returns {*}
    */
   setLabel: function (viewLabel, successCallback, errorCallback) {
       label = viewLabel || "";

       return exec(successCallback, errorCallback, 'ProgressView', 'setLabel', [label]);
   },


    /**
     * Hides native determinate progress dialog.
     *
     * @param successCallback
     * @param errorCallback
     * @returns {*}
     */
    hide: function (successCallback, errorCallback) {
        return exec(successCallback, errorCallback, 'ProgressView', 'hide', '');
    }
};