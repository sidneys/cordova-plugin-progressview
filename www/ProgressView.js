/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */

var exec = require('cordova/exec');

module.exports = {

    /**
     * Shows a native determinate progress dialog.
     *
     * @param {String} progressLabel - Dialog Title, defaults to 'Please Wait...'
     * @param {String} progressType - "CIRCLE", "HORIZONTAL"
     * @param {String} progressTheme -  (Android) "TRADITIONAL", "DEVICE_DARK", "DEVICE_LIGHT", "HOLO_DARK", "HOLO_LIGHT"
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
     * @returns {*}
     */
    setProgress: function (progressPercentage, successCallback, errorCallback) {
        value = parseFloat(progressPercentage);

        return exec(successCallback, errorCallback, 'ProgressView', 'setProgress', [value]);
    },

    /**
     * Hides native determinate progress dialog.
     *
     * @returns {*}
     */
    hide: function (successCallback, errorCallback) {
        return exec(successCallback, errorCallback, 'ProgressView', 'hide', '');
    }
};
});