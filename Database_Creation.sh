source ~/.bash_profile

source $commonConfigurationFilePath
dbDecryptPassword=$(java -jar  ${APP_HOME}/encryption_utility/PasswordDecryptor-0.1.jar spring.datasource.password)

mysql  -h$dbIp -P$dbPort -u$dbUsername -p${dbDecryptPassword} $appdbName <<EOFMYSQL

 
CREATE TABLE `duplicate_imei` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `imei` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `imei` (`imei`),
  KEY `imei_2` (`imei`)
);

CREATE TABLE `duplicate_device_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `imei` varchar(20) DEFAULT NULL,
  `imsi` varchar(20) DEFAULT NULL,
  `msisdn` varchar(20) DEFAULT NULL,
  `file_name` varchar(150) DEFAULT NULL,
  `edr_time` timestamp NULL DEFAULT NULL,
  `operator` varchar(20) DEFAULT NULL,
  `expiry_date` timestamp NULL DEFAULT NULL,
  `remark` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `updated_by` varchar(20) DEFAULT NULL,
  `transaction_id` varchar(50) DEFAULT NULL,
  `document_type1` varchar(50) DEFAULT NULL,
  `document_type2` varchar(50) DEFAULT NULL,
  `document_type3` varchar(50) DEFAULT NULL,
  `document_type4` varchar(50) DEFAULT NULL,
  `document_file_name_1` varchar(150) DEFAULT NULL,
  `document_file_name_2` varchar(150) DEFAULT NULL,
  `document_file_name_3` varchar(150) DEFAULT NULL,
  `document_file_name_4` varchar(150) DEFAULT NULL,
  `reminder_status` int DEFAULT '1',
  `success_count` int DEFAULT '0',
  `fail_count` int DEFAULT '0',
  `approve_transaction_id` varchar(50) DEFAULT NULL,
  `approve_remark` varchar(150) DEFAULT NULL,
  `document_path1` varchar(150) DEFAULT NULL,
  `document_path2` varchar(150) DEFAULT NULL,
  `document_path3` varchar(150) DEFAULT NULL,
  `document_path4` varchar(150) DEFAULT NULL,
  `actual_imei` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `redmine_tkt_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `imei_imsi` (`imei`,`imsi`),
  KEY `imei_2` (`imei`),
  KEY `imei_3` (`imei`,`imsi`),
  KEY `expiry_date` (`expiry_date`,`status`)
);

insert into sys_param(tag,value,feature_name) values  ('duplicate_allowed_device_type','Mobile,Laptop', 'duplicate_identify');

insert into sys_param(tag,value,feature_name) values  ('duplicate_notification_sms_start_time','09:00', 'duplicate_identify');

insert into sys_param(tag,value,feature_name)  values  ('duplicate_notification_sms_end_time','18:00', 'duplicate_identify');

insert into sys_param(tag,value,feature_name)  values  ('duplicate_allowed_count','2', 'duplicate_identify');

insert into sys_param(tag,value,feature_name)  values  ('duplicate_window_time_in_sec','60', 'duplicate_identify');

insert into sys_param(tag,value,feature_name)  values  ('duplicate_expiry_days','90', 'duplicate_identify');

insert into sys_param(tag,value,feature_name)  values  ('duplication_send_notification_flag','TRUE', 'duplicate_identify');    


EOFMYSQL
