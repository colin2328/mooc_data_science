'''
Created on March 17, 2013
@author: Colin Taylor
'''
import numpy as np
import pylab as pl
import argparse
import time


from sklearn import linear_model
from sklearn.metrics import roc_curve, auc

import create_distributions 


def run_regression(in_file, lead, lag):
	start_time = time.time()
	intermediate_file = "out.csv"

	create_distributions.create_features(intermediate_file, in_file, lead, lag)
	print "ran create distribution in", time.time() - start_time, "seconds"
	start_time = time.time()

	data = np.genfromtxt(intermediate_file, delimiter = ',')
	X = data[:,1:-1]
	Y = data[:,-1]

	print "loaded data in", time.time() - start_time, "seconds"
	start_time = time.time()

	logreg = linear_model.LogisticRegression(C=1e5)
	logreg.fit(X, Y)
	predicted_probs = logreg.predict_proba(X)

	no_dropout_index = logreg.classes_.tolist().index(1)

	fpr, tpr, thresholds = roc_curve(Y, predicted_probs[:, no_dropout_index],  pos_label=1)
	roc_auc = auc(fpr, tpr)

	print "ran regression in", time.time() - start_time, "seconds"

	print("Area under the ROC curve : %f" % roc_auc)

	# Plot ROC curve
	pl.clf()
	pl.plot(fpr, tpr, label='ROC curve (area = %0.3f)' % roc_auc)
	pl.plot([0, 1], [0, 1], 'k--')
	pl.xlim([0.0, 1.0])
	pl.ylim([0.0, 1.0])
	pl.xlabel('False Positive Rate')
	pl.ylabel('True Positive Rate')
	pl.title('ROC- lead = % lag = %' % lead, lag)
	pl.legend(loc="lower right")
	pl.show()


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Create feature csv with given lead and lag.')
	parser.add_argument('--in_file',type=str, default="features.csv") # input csv
	parser.add_argument('--lead',type=int, default=1)  # number of weeks ahead to predict
	parser.add_argument('--lag',type=int, default=1)  # number of weeks of features to use
	args = parser.parse_args()

	run_regression(args.in_file, args.lead, args.lag)