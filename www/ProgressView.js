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
     * @param {String} progressLabel - Dialog Title, defaults to 'Please Wait...'
     * @param {String} progressType - "CIRCLE", "HORIZONTAL"
     * @param {String} progressTheme -  (Android only) "TRADITIONAL", "DEVICE_DARK", "DEVICE_LIGHT", "HOLO_DARK", "HOLO_LIGHT"
     * @param successCallback
     * @param errorCallback
     * @returns {*}
     */
    show: function (progressLabel, progressType, progressTheme, successCallback, errorCallback) {
        label = progressLabel || "Please Wait...";
        type = progressType || "";
        theme = progressTheme || "DEVICE_LIGHT";

        return exec(successCallback, errorCallback, 'ProgressView', 'show', [label, type, theme]);
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