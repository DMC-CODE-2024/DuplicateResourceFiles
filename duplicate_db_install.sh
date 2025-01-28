#!/bin/bash
conf_file=${APP_HOME}/configuration/configuration.properties
typeset -A config # init array

while read line
do
    if echo $line | grep -F = &>/dev/null
    then
        varname=$(echo "$line" | cut -d '=' -f 1)
        config[$varname]=$(echo "$line" | cut -d '=' -f 2-)
    fi
done < $conf_file
dbPassword=$(java -jar  ${APP_HOME}/utility/pass_dypt/pass_dypt.jar spring.datasource.password)
conn="mysql -h${config[dbIp]} -P${config[dbPort]} -u${config[dbUsername]} -p${dbPassword} ${config[appdbName]}"

`${conn} <<EOFMYSQL

INSERT IGNORE INTO sys_param (description, tag, type, value, active, feature_name, remark, user_type, modified_by) VALUES ('Notification send start time', 'duplicate_notification_sms_start_time', 0, '09:00', 1, 'duplicate',  NULL, 'system', 'system');

INSERT IGNORE INTO sys_param (description, tag, type, value, active, feature_name, remark, user_type, modified_by) VALUES ('Notification send end time', 'duplicate_notification_sms_end_time', 0, '18:00', 1, 'duplicate',  NULL, 'system', 'system');

INSERT IGNORE INTO sys_param (description, tag, type, value, active, feature_name, remark, user_type, modified_by) VALUES ('Notification is sent or not', 'duplication_send_notification_flag', 0, 'No', 1, 'duplicate',  NULL, 'system', 'system');

INSERT IGNORE INTO sys_param (description, tag, type, value, active, feature_name, remark, user_type, modified_by) VALUES ('Number of count to detect the duplicate device', 'duplicate_allowed_count', 0, '2', 1, 'duplicate',  NULL, 'system', 'system');

INSERT IGNORE INTO sys_param (description, tag, type, value, active, feature_name, remark, user_type, modified_by) VALUES ('With in the Duration different calls on same IMEI detected for duplicate in seconds', 'duplicate_window_time_in_sec', 0, '30', 1, 'duplicate',  NULL, 'system', 'system');

INSERT IGNORE INTO sys_param (description, tag, type, value, active, feature_name, remark, user_type, modified_by) VALUES ('Number of days if user not provide the documents device black listed', 'duplicate_expiry_days', 0, '120', 1, 'duplicate',  NULL, 'system', 'system');

INSERT IGNORE INTO sys_param (description, tag, type, value, active, feature_name, remark, user_type, modified_by) VALUES ('Comma separated values of device type that uses duplicate process', 'duplicate_allowed_device_type', 0, 'smartphone,featurephone,Mobile', 1, 'duplicate',  NULL, 'system', 'system'); 


INSERT IGNORE INTO eirs_response_param (description, tag, type, value, active, feature_name, remarks, user_type, modified_by, language)
VALUES ('SMS Notification Message sent to the public user when an IMEI is detected as duplicate', 'DuplicateSms', NULL, 'Your <MSISDN> has been marked as Duplicate', 1, 'duplicate', NULL, 'system', 'system', 'en');


INSERT IGNORE INTO eirs_response_param (description, tag, type, value, active, feature_name, remarks, user_type, modified_by, language)
VALUES ('SMS Notification Message sent to the public user when an IMEI is detected as duplicate', 'DuplicateSms', NULL, '', 1, 'duplicate', NULL, 'system', 'system', 'km');

EOFMYSQL`

echo "DB Script Execution Completed"
