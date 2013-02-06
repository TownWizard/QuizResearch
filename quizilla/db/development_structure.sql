CREATE TABLE `affiliate_product_quiz_learning_blurb_bindings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `affiliate_product_id` int(11) DEFAULT NULL,
  `quiz_learning_blurb_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `affiliate_product_quiz_recommendation_bindings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `affiliate_product_id` int(11) DEFAULT NULL,
  `quiz_recommendation_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `affiliate_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `html` text,
  `image` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `catalog_states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `harvester_version` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `gatherer_realtime_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_id` int(11) DEFAULT NULL,
  `new_items_gathered` int(11) DEFAULT NULL,
  `retrieval_method` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `item_phrase_correlations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) DEFAULT NULL,
  `phrase_id` int(11) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `guid` varchar(255) DEFAULT NULL,
  `content` text,
  `source_id` int(11) DEFAULT NULL,
  `staff_pick` tinyint(1) DEFAULT NULL,
  `date_published_by_source` datetime DEFAULT NULL,
  `date_updated_by_source` datetime DEFAULT NULL,
  `acquisition_method` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `phrase_aliases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phrase_alias` varchar(255) DEFAULT NULL,
  `phrase_id` int(11) DEFAULT NULL,
  `display` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `phrases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phrase` varchar(255) DEFAULT NULL,
  `display_phrase` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `quiz_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_question_id` int(11) DEFAULT NULL,
  `answer` varchar(255) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `boost_keywords` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `quiz_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `boost_keywords` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `quiz_instances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_instance_uuid` varchar(255) DEFAULT NULL,
  `quiz_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `quiz_lead_answer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `qi_quiz_instance_quiz_instance` (`quiz_instance_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `quiz_lead_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_lead_question_id` int(11) DEFAULT NULL,
  `quiz_id` int(11) DEFAULT NULL,
  `answer` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `learning_blurb` text,
  `boost_keywords` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `quiz_lead_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `quiz_category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `boost_keywords` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `quiz_learning_blurbs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_answer_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `blurb` text,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `boost_keywords` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `quiz_phases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `boost_keywords` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `quiz_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `quiz_phase_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `boost_keywords` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `quiz_recommendations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `recommendation` text,
  `value_floor` float DEFAULT NULL,
  `value_ceiling` float DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `boost_keywords` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `quizzes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_category_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `boost_keywords` text,
  `quiz_photo_path` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `site_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_site_sessions_on_session_id` (`session_id`),
  KEY `index_site_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `feed_link` varchar(255) DEFAULT NULL,
  `config_identifier` varchar(255) DEFAULT NULL,
  `attempted_at` datetime DEFAULT NULL,
  `successful_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `time_zone` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_quiz_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_answer_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `quiz_instance_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(40) DEFAULT NULL,
  `name_first` varchar(25) DEFAULT '',
  `name_last` varchar(25) DEFAULT '',
  `email` varchar(100) DEFAULT NULL,
  `user_type_id` int(11) DEFAULT NULL,
  `crypted_password` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `remember_token` varchar(40) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `dob_confirmed` tinyint(1) DEFAULT NULL,
  `activation_code` varchar(255) DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_login` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20081006194059');

INSERT INTO schema_migrations (version) VALUES ('20081006195557');

INSERT INTO schema_migrations (version) VALUES ('20081006195829');

INSERT INTO schema_migrations (version) VALUES ('20081006195955');

INSERT INTO schema_migrations (version) VALUES ('20081006211030');

INSERT INTO schema_migrations (version) VALUES ('20081006211326');

INSERT INTO schema_migrations (version) VALUES ('20081006211720');

INSERT INTO schema_migrations (version) VALUES ('20081006212000');

INSERT INTO schema_migrations (version) VALUES ('20081006212039');

INSERT INTO schema_migrations (version) VALUES ('20081006212327');

INSERT INTO schema_migrations (version) VALUES ('20081006212523');

INSERT INTO schema_migrations (version) VALUES ('20081006215955');

INSERT INTO schema_migrations (version) VALUES ('20081007002343');

INSERT INTO schema_migrations (version) VALUES ('20081007194933');

INSERT INTO schema_migrations (version) VALUES ('20081007201115');

INSERT INTO schema_migrations (version) VALUES ('20081007203606');

INSERT INTO schema_migrations (version) VALUES ('20081009224042');

INSERT INTO schema_migrations (version) VALUES ('20081010214906');

INSERT INTO schema_migrations (version) VALUES ('20081012054524');

INSERT INTO schema_migrations (version) VALUES ('20081014014149');

INSERT INTO schema_migrations (version) VALUES ('20081020232753');

INSERT INTO schema_migrations (version) VALUES ('20081023182624');

INSERT INTO schema_migrations (version) VALUES ('20081028233937');

INSERT INTO schema_migrations (version) VALUES ('20081029210420');

INSERT INTO schema_migrations (version) VALUES ('20081114190439');

INSERT INTO schema_migrations (version) VALUES ('20081118053005');

INSERT INTO schema_migrations (version) VALUES ('20081118054001');

INSERT INTO schema_migrations (version) VALUES ('20081118054308');

INSERT INTO schema_migrations (version) VALUES ('20081118054540');

INSERT INTO schema_migrations (version) VALUES ('20081118054816');

INSERT INTO schema_migrations (version) VALUES ('20081121085652');

INSERT INTO schema_migrations (version) VALUES ('20081121093912');

INSERT INTO schema_migrations (version) VALUES ('20081229090113');

INSERT INTO schema_migrations (version) VALUES ('20081230205719');

INSERT INTO schema_migrations (version) VALUES ('20081231212013');

INSERT INTO schema_migrations (version) VALUES ('20090107222805');

INSERT INTO schema_migrations (version) VALUES ('20090116190112');

INSERT INTO schema_migrations (version) VALUES ('20090126001123');

INSERT INTO schema_migrations (version) VALUES ('20090207221603');

INSERT INTO schema_migrations (version) VALUES ('20090214012259');