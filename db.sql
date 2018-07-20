/*
SQLyog 企业版 - MySQL GUI v8.14
MySQL - 5.6.27-log : Database - test
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`test` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `test`;

/*Table structure for table `default` */

CREATE TABLE `default` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL DEFAULT '' COMMENT '用户名',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱',
  `password` char(32) NOT NULL DEFAULT '' COMMENT '密码',
  `salt` char(10) NOT NULL DEFAULT '' COMMENT '密码盐',
  `last_login` int(11) NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `last_ip` char(15) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态，0正常 -1禁用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `default` */

insert  into `default`(`id`,`user_name`,`email`,`password`,`salt`,`last_login`,`last_ip`,`status`) values (1,'admin','admin@example.com','7fef6171469e80d32c0559f88b377245','',0,'',0);

/*Table structure for table `people` */

CREATE TABLE `people` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `frist_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `people` */

insert  into `people`(`id`,`frist_name`,`last_name`,`city`) values (1,'Elvis','Presley',''),(2,'aaaa','aaaaa',''),(3,'aaaa','aaaaa','chaoyang');

/*Table structure for table `task` */

CREATE TABLE `task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服务器资源ID',
  `group_id` int(11) NOT NULL DEFAULT '0' COMMENT '分组ID',
  `task_name` varchar(50) NOT NULL DEFAULT '' COMMENT '任务名称',
  `task_type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '任务类型:1-常驻类型，0-定时类型',
  `description` varchar(200) NOT NULL DEFAULT '' COMMENT '任务描述',
  `cron_spec` varchar(100) NOT NULL DEFAULT '' COMMENT '时间表达式',
  `concurrent` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否只允许一个实例',
  `command` text NOT NULL COMMENT '命令详情',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0停用 1启用',
  `timeout` smallint(6) NOT NULL DEFAULT '0' COMMENT '超时设置',
  `execute_times` int(11) NOT NULL DEFAULT '0' COMMENT '累计执行次数',
  `prev_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上次执行时间',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Data for the table `task` */

insert  into `task`(`id`,`user_id`,`server_id`,`group_id`,`task_name`,`task_type`,`description`,`cron_spec`,`concurrent`,`command`,`status`,`timeout`,`execute_times`,`prev_time`,`create_time`) values (1,1,0,2,'测试任务名称',0,'测试任务说明','0 0/1 11 * *',0,'echo \"hello\\n\" >> /tmp/test_cron1.log',0,0,47,1502941758,1497855526),(10,1,0,2,'businessWork-1',0,'测试任务 5秒一次','*/5 * * * *',0,'php /home/ygw/golang/gopath/src/phpCrontab/test.php',0,800,16213,1531962265,1522750409);

/*Table structure for table `task_group` */

CREATE TABLE `task_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `group_name` varchar(50) NOT NULL DEFAULT '' COMMENT '组名',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `task_group` */

insert  into `task_group`(`id`,`user_id`,`group_name`,`description`,`create_time`) values (1,1,'抓取任务','定时抓取网页',0),(2,1,'测试任务','任务分组测试asfdasf',0),(3,1,'1','1111asfdasf',1531968661);

/*Table structure for table `task_log` */

CREATE TABLE `task_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '任务ID',
  `output` mediumtext NOT NULL COMMENT '任务输出',
  `error` text NOT NULL COMMENT '错误信息',
  `status` tinyint(4) NOT NULL COMMENT '状态',
  `process_time` int(11) NOT NULL DEFAULT '0' COMMENT '消耗时间/毫秒',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_task_id` (`task_id`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `task_log` */

insert  into `task_log`(`id`,`task_id`,`output`,`error`,`status`,`process_time`,`create_time`) values (1,10,'1','',0,12,1531962255),(2,10,'1','',0,12,1531962260),(3,10,'1','',0,11,1531962265);

/*Table structure for table `task_server` */

CREATE TABLE `task_server` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `server_name` varchar(64) NOT NULL DEFAULT '0' COMMENT '服务器名称',
  `server_account` varchar(32) NOT NULL DEFAULT 'root' COMMENT '账户名称',
  `server_ip` varchar(20) NOT NULL DEFAULT '0' COMMENT '服务器IP',
  `port` int(4) unsigned NOT NULL DEFAULT '22' COMMENT '服务器端口',
  `password` varchar(64) NOT NULL DEFAULT '0' COMMENT '服务器密码',
  `private_key_src` varchar(128) NOT NULL DEFAULT '0' COMMENT '私钥文件地址',
  `public_key_src` varchar(128) NOT NULL DEFAULT '0' COMMENT '公钥地址',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '登录类型：0-密码登录，1-私钥登录',
  `detail` varchar(255) NOT NULL DEFAULT '0' COMMENT '备注',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='服务器列表';

/*Data for the table `task_server` */

insert  into `task_server`(`id`,`server_name`,`server_account`,`server_ip`,`port`,`password`,`private_key_src`,`public_key_src`,`type`,`detail`,`create_time`,`update_time`,`status`) values (1,'密钥验证登录服务器','root','172.16.210.157',22,'','/Users/haodaquan/.ssh/pp_rsa','/Users/haodaquan/.ssh/pp_rsa.pub',1,'远程服务器示例',1502862723,1502945893,0),(4,'密码验证服务器','root','172.16.210.157',22,'root','','',0,'这是密码验证服务器',1502945869,1502945869,0);

/*Table structure for table `tital` */

CREATE TABLE `tital` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tital` varchar(255) NOT NULL DEFAULT '',
  `contents` varchar(255) NOT NULL DEFAULT '',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `tag` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `tital` */

/*Table structure for table `user` */

CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `salt` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `last_login` bigint(20) NOT NULL DEFAULT '0',
  `last_ip` varchar(255) NOT NULL DEFAULT '',
  `status` int(11) NOT NULL DEFAULT '0',
  `permission` text,
  `ptest` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `user` */

insert  into `user`(`id`,`user_name`,`password`,`salt`,`email`,`last_login`,`last_ip`,`status`,`permission`,`ptest`) values (1,'admin','0de716a58a5b403d510dc1a5a8b0efb5','AiAh1uvoAf','ttian939@qq.com',1532073187,'10.8.0.63',0,'[\"group.edit\",\"group.list\",\"index.adduser\",\"index.gettime\",\"index.index\",\"index.profile\",\"task.add\",\"task.edit\",\"task.list\"]','{\"group.edit\":1,\"group.list\":1,\"index.adduser\":1,\"index.gettime\":1,\"index.index\":1,\"index.profile\":1,\"task.add\":1,\"task.edit\":1,\"task.list\":1}'),(2,'ttian939','915dc0534a27d4beaf038ac1dbc6ae2a','Ga3iDK6Ctr','ttian939@qq.com',1532073389,'10.8.0.63',0,'[\"group.edit\",\"group.list\",\"index.adduser\",\"index.gettime\",\"index.index\",\"index.profile\",\"task.add\",\"task.edit\",\"task.list\"]','{\"group.edit\":1,\"group.list\":1,\"index.adduser\":1,\"index.gettime\":1,\"index.index\":1,\"index.profile\":1,\"task.add\":1,\"task.edit\":1,\"task.list\":1}');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
