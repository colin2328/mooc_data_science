-- Takes 1 second to execute 
-- Created on July 2, 2013
-- @author: Franck for ALFA, MIT lab: franck.dernoncourt@gmail.com
-- Feature 103: difference of number of forum posts
-- 2433 rows

INSERT INTO mock.dropout_feature_values(dropout_feature_id, user_id, dropout_feature_value_week, dropout_feature_value)

SELECT 103, 	
	dropout_feature_values.user_id, 
	dropout_feature_values2.dropout_feature_value_week,
	-- dropout_feature_values.dropout_feature_value,
	-- dropout_feature_values2.dropout_feature_value,
	dropout_feature_values2.dropout_feature_value  / dropout_feature_values.dropout_feature_value
FROM mock.dropout_feature_values AS dropout_feature_values,
	mock.dropout_feature_values AS dropout_feature_values2

WHERE 
	-- same user
	dropout_feature_values.user_id = dropout_feature_values2.user_id
	-- 2 successive weeks
	AND dropout_feature_values.dropout_feature_value_week = dropout_feature_values2.dropout_feature_value_week - 1
	-- we need compute the percentage of change if we had at least 5 posts in the previous week
	AND dropout_feature_values.dropout_feature_value > 5 
	-- we are only interested in feature 3 (forum posts)
	AND dropout_feature_values.dropout_feature_id = 3
	AND dropout_feature_values2.dropout_feature_id = 3
