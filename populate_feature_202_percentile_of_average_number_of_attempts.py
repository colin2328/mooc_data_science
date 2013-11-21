''' 
Created on Nov 21, 2013
@author: Colin Taylor colin2328@gmail.com
Feature 201- number of forum responses per week (also known as CF1)
Requires that populate_feature_7_number_of_attempts.sql has already been run!
'''

from  scipy.stats import percentileofscore
import MySQLdb as mdb

def main():
	connection=mdb.connect(user="root",passwd="",db="moocdb")
	cursor = connection.cursor()

	connection2=mdb.connect(user="root",passwd="",db="moocdb")
	cursor2 = connection2.cursor()

	sql = '''SELECT user_id, dropout_feature_value_week, dropout_feature_value 
			FROM moocdb.dropout_feature_values
			WHERE dropout_feature_id = 7;
			'''

	cursor.execute(sql)

	week_values = {}
	for [user_id, week, value] in cursor:
		if week in week_values:
			week_values[week].append(value)
		else:
			week_values[week] = [value]


	for [user_id, week, value] in cursor:
		insert_percentile(percentileofscore(week_values[week], value), user_id, week, cursor2, connection2)

	connection.close()
	connection2.close()

def insert_percentile(percentile, user_id, week, cursor, connection):
	sql = '''INSERT INTO moocdb.dropout_feature_values(dropout_feature_id, user_id, dropout_feature_value_week, dropout_feature_value)
	VALUES (202, %s, %s, %s)
	''' % (user_id, week, percentile)
	cursor.execute(sql)
	connection.commit()

if __name__ == "__main__":
	main()