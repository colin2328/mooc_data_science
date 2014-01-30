-- Takes 40 seconds to execute
-- Created on August 23, 2013
-- @author: Franck for ALFA, MIT lab: franck.dernoncourt@gmail.com
-- Feature 18: Total time spent on all resources - wiki only - during the week

INSERT INTO mock.dropout_feature_values(dropout_feature_id, user_id, dropout_feature_value_week, dropout_feature_value)
	
SELECT 18, 	
	users.user_id, 
	FLOOR((UNIX_TIMESTAMP(observed_events.observed_event_timestamp) 
			- UNIX_TIMESTAMP('2012-03-05 12:00:00')) / (3600 * 24 * 7)) AS week,
	SUM(observed_events.observed_event_duration)
FROM mock.users AS users
INNER JOIN mock.observed_events AS observed_events
 ON observed_events.user_id = users.user_id
INNER JOIN mock.resources AS resources
 ON resources.resource_id = observed_events.resource_id
INNER JOIN mock.resource_types AS resource_types
 ON resource_types.resource_type_id = resources.resource_type_id
WHERE users.user_dropout_week IS NOT NULL 
	-- AND users.user_id < 100
	AND resource_types.resource_type_id = 2 -- 2 is wiki
	AND FLOOR((UNIX_TIMESTAMP(observed_events.observed_event_timestamp) 
			- UNIX_TIMESTAMP('2012-03-05 12:00:00')) / (3600 * 24 * 7)) < 16
GROUP BY users.user_id, week
;

 