-- Created on Feb 3rd, 2014
-- @author:  Colin Taylor
-- Feature 206: Lab Grade: Number of lab problems correct in a week's problems / number of lab problems in a week
-- Meant to be run in order to run after problem_populate_module_week.sql

INSERT INTO moocdb.dropout_feature_values(dropout_feature_id, user_id, dropout_feature_value_week, dropout_feature_value)

SELECT 206, submissions.user_id, problems.problem_week AS week, COUNT(*) /
	(SELECT COUNT(*)  FROM moocdb.problems AS p2 WHERE p2.problem_type_id = 1 
		AND p2.problem_week = problems.problem_week GROUP BY problem_week) AS pset_grade
FROM moocdb.submissions
INNER JOIN moocdb.problems
	ON submissions.problem_id = problems.problem_id
INNER JOIN moocdb.assessments
	ON assessments.submission_id = submissions.submission_id
INNER JOIN moocdb.users
	ON submissions.user_id = users.user_id
WHERE users.user_dropout_week IS NOT NULL
AND problems.problem_type_id = 3
AND assessments.assessment_grade = 1
GROUP BY submissions.user_id, problems.problem_week
HAVING week < 15
AND week >= 0;