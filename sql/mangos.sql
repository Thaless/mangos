-- MySQL dump 10.11
--
-- Host: localhost    Database: mangos
-- ------------------------------------------------------
-- Server version	5.0.56-nt

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `db_version`
--

DROP TABLE IF EXISTS `db_version`;
CREATE TABLE `db_version` (
  `version` varchar(120) default NULL,
  `creature_ai_version` varchar(120) default NULL,
  `cache_id` int(10) default '0',
  `required_8498_01_mangos_spell_proc_event` bit(1) default NULL
  `required_8499_01_mangos_spell_elixir` bit(1) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Used DB version notes';

--
-- Dumping data for table `db_version`
--

LOCK TABLES `db_version` WRITE;
/*!40000 ALTER TABLE `db_version` DISABLE KEYS */;
INSERT INTO `db_version` VALUES
('Mangos default database.','Creature EventAI not provided.',0,NULL);
/*!40000 ALTER TABLE `db_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `achievement_criteria_data`
--

DROP TABLE IF EXISTS `achievement_criteria_data`;
CREATE TABLE `achievement_criteria_data` (
  `criteria_id` mediumint(8) NOT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `value1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `value2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`criteria_id`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Achievment system';

--
-- Dumping data for table `achievement_criteria_data`
--

LOCK TABLES `achievement_criteria_data` WRITE;
/*!40000 ALTER TABLE `achievement_criteria_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `achievement_criteria_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `achievement_reward`
--

DROP TABLE IF EXISTS `achievement_reward`;
CREATE TABLE `achievement_reward` (
  `entry` mediumint(8) unsigned NOT NULL default '0',
  `title_A` mediumint(8) unsigned NOT NULL default '0',
  `title_H` mediumint(8) unsigned NOT NULL default '0',
  `item` mediumint(8) unsigned NOT NULL default '0',
  `sender` mediumint(8) unsigned NOT NULL default '0',
  `subject` varchar(255) default NULL,
  `text` text,
  PRIMARY KEY  (`entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Achievment system';

--
-- Dumping data for table `achievement_reward`
--

LOCK TABLES `achievement_reward` WRITE;
/*!40000 ALTER TABLE `achievement_reward` DISABLE KEYS */;
/*!40000 ALTER TABLE `achievement_reward` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `areatrigger_involvedrelation`
--

DROP TABLE IF EXISTS `areatrigger_involvedrelation`;
CREATE TABLE `areatrigger_involvedrelation` (
  `id` mediumint(8) unsigned NOT NULL default '0' COMMENT 'Identifier',
  `quest` mediumint(8) unsigned NOT NULL default '0' COMMENT 'Quest Identifier',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Trigger System';

--
-- Dumping data for table `areatrigger_involvedrelation`
--

LOCK TABLES `areatrigger_involvedrelation` WRITE;
/*!40000 ALTER TABLE `areatrigger_involvedrelation` DISABLE KEYS */;
/*!40000 ALTER TABLE `areatrigger_involvedrelation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `areatrigger_scripts`
--

DROP TABLE IF EXISTS `areatrigger_scripts`;
CREATE TABLE `areatrigger_scripts` (
    `entry` MEDIUMINT( 8 ) NOT NULL ,
    `ScriptName` CHAR( 64 ) NOT NULL ,
    PRIMARY KEY ( `entry` )
) ENGINE = MYISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `areatrigger_scripts`
--

LOCK TABLES `areatrigger_scripts` WRITE;
/*!40000 ALTER TABLE `areatrigger_scripts` DISABLE KEYS */;
/*!40000 ALTER TABLE `areatrigger_scripts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `areatrigger_tavern`
--

DROP TABLE IF EXISTS `areatrigger_tavern`;
CREATE TABLE `areatrigger_tavern` (
  `id` mediumint(8) unsigned NOT NULL default '0' COMMENT 'Identifier',
  `name` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Trigger System';

--
-- Dumping data for table `areatrigger_tavern`
--

LOCK TABLES `areatrigger_tavern` WRITE;
/*!40000 ALTER TABLE `areatrigger_tavern` DISABLE KEYS */;
/*!40000 ALTER TABLE `areatrigger_tavern` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `areatrigger_teleport`
--

DROP TABLE IF EXISTS `areatrigger_teleport`;
CREATE TABLE `areatrigger_teleport` (
  `id` mediumint(8) unsigned NOT NULL default '0' COMMENT 'Identifier',
  `name` text,
  `required_level` tinyint(3) unsigned NOT NULL default '0',
  `required_item` mediumint(8) unsigned NOT NULL default '0',
  `required_item2` mediumint(8) unsigned NOT NULL default '0',
  `heroic_key` mediumint(8) unsigned NOT NULL default '0',
  `heroic_key2` mediumint(8) unsigned NOT NULL default '0',
  `required_quest_done` int(11) unsigned NOT NULL default '0',
  `required_quest_done_heroic` int(11) unsigned NOT NULL default '0',
  `required_failed_text` text,
  `target_map` smallint(5) unsigned NOT NULL default '0',
  `target_position_x` float NOT NULL default '0',
  `target_position_y` float NOT NULL default '0',
  `target_position_z` float NOT NULL default '0',
  `target_orientation` float NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Trigger System';

--
-- Dumping data for table `areatrigger_teleport`
--

LOCK TABLES `areatrigger_teleport` WRITE;
/*!40000 ALTER TABLE `areatrigger_teleport` DISABLE KEYS */;
/*!40000 ALTER TABLE `areatrigger_teleport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battleground_template`
--

DROP TABLE IF EXISTS `battleground_template`;
CREATE TABLE `battleground_template` (
  `id` mediumint(8) unsigned NOT NULL,
  `MinPlayersPerTeam` smallint(5) unsigned NOT NULL default '0',
  `MaxPlayersPerTeam` smallint(5) unsigned NOT NULL default '0',
  `MinLvl` tinyint(3) unsigned NOT NULL default '0',
  `MaxLvl` tinyint(3) unsigned NOT NULL default '0',
  `AllianceStartLoc` mediumint(8) unsigned NOT NULL,
  `AllianceStartO` float NOT NULL,
  `HordeStartLoc` mediumint(8) unsigned NOT NULL,
  `HordeStartO` float NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `battleground_template`
--

LOCK TABLES `battleground_template` WRITE;
/*!40000 ALTER TABLE `battleground_template` DISABLE KEYS */;
INSERT INTO `battleground_template` VALUES
(1,0,0,0,0,611,2.72532,610,2.27452),
(2,0,0,0,0,769,3.14159,770,3.14159),
(4,0,2,10,70,929,0,936,3.14159),
(3,0,0,0,0,890,3.40156,889,0.263892),
(5,0,2,10,70,939,0,940,3.14159),
(6,0,2,10,70,0,0,0,0),
(7,0,0,0,0,1103,3.40156,1104,0.263892),
(8,0,2,10,70,1258,0,1259,3.14159),
(9,0,0,0,0,1367,0,1368,0),
(10,5,5,10,80,1362,0,1363,0),
(11,5,5,10,80,1364,0,1365,0);
/*!40000 ALTER TABLE `battleground_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlemaster_entry`
--

DROP TABLE IF EXISTS `battlemaster_entry`;
CREATE TABLE `battlemaster_entry` (
  `entry` mediumint(8) unsigned NOT NULL default '0' COMMENT 'Entry of a creature',
  `bg_template` mediumint(8) unsigned NOT NULL default '0' COMMENT 'Battleground template id',
  PRIMARY KEY  (`entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `battlemaster_entry`
--

LOCK TABLES `battlemaster_entry` WRITE;
/*!40000 ALTER TABLE `battlemaster_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `battlemaster_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `command`
--

DROP TABLE IF EXISTS `command`;
CREATE TABLE `command` (
  `name` varchar(50) NOT NULL default '',
  `security` tinyint(3) unsigned NOT NULL default '0',
  `help` longtext,
  PRIMARY KEY  (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Chat System';

--
-- Dumping data for table `command`
--

LOCK TABLES `command` WRITE;
/*!40000 ALTER TABLE `command` DISABLE KEYS */;
INSERT INTO `command` VALUES
('account',0,'Syntax: .account\r\n\r\nDisplay the access level of your account.'),
('account create',4,'Syntax: .account create $account $password\r\n\r\nCreate account and set password to it.'),
('account delete',4,'Syntax: .account delete $account\r\n\r\nDelete account with all characters.'),
('account lock',0,'Syntax: .account lock [on|off]\r\n\r\nAllow login from account only from current used IP or remove this requirement.'),
('account onlinelist',4,'Syntax: .account onlinelist\r\n\r\nShow list of online accounts.'),
('account password',0,'Syntax: .account password $old_password $new_password $new_password\r\n\r\nChange your account password.'),
('account set addon',3,'Syntax: .account set addon [$account] #addon\r\n\r\nSet user (possible targeted) expansion addon level allowed. Addon values: 0 - normal, 1 - tbc, 2 - wotlk.'),
('account set gmlevel',4,'Syntax: .account set gmlevel [$account] #level\r\n\r\nSet the security level for targeted player (can''t be used at self) or for account $name to a level of #level.\r\n\r\n#level may range from 0 to 3.'),
('account set password',4,'Syntax: .account set password $account $password $password\r\n\r\nSet password for account.'),
('additem',3,'Syntax: .additem #itemid/[#itemname]/#shift-click-item-link #itemcount\r\n\r\nAdds the specified number of items of id #itemid (or exact (!) name $itemname in brackets, or link created by shift-click at item in inventory or recipe) to your or selected character inventory. If #itemcount is omitted, only one item will be added.\r\n.'),
('additemset',3,'Syntax: .additemset #itemsetid\r\n\r\nAdd items from itemset of id #itemsetid to your or selected character inventory. Will add by one example each item from itemset.'),
('announce',1,'Syntax: .announce $MessageToBroadcast\r\n\r\nSend a global message to all players online in chat log.'),
('aura',3,'Syntax: .aura #spellid\r\n\r\nAdd the aura from spell #spellid to the selected Unit.'),
('ban account',3,'Syntax: .ban account $Name $bantime $reason\r\nBan account kick player.\r\n$bantime: negative value leads to permban, otherwise use a timestring like \"4d20h3s\".'),
('ban character',3,'Syntax: .ban character $Name $bantime $reason\r\nBan account and kick player.\r\n$bantime: negative value leads to permban, otherwise use a timestring like \"4d20h3s\".'),
('ban ip',3,'Syntax: .ban ip $Ip $bantime $reason\r\nBan IP.\r\n$bantime: negative value leads to permban, otherwise use a timestring like \"4d20h3s\".'),
('baninfo account',3,'Syntax: .baninfo account $accountid\r\nWatch full information about a specific ban.'),
('baninfo character',3,'Syntax: .baninfo character $charactername \r\nWatch full information about a specific ban.'),
('baninfo ip',3,'Syntax: .baninfo ip $ip\r\nWatch full information about a specific ban.'),
('bank',3,'Syntax: .bank\r\n\r\nShow your bank inventory.'),
('banlist 