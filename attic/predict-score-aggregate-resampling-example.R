# Example output shown for predict-score-aggregate-resampling.drawio.svg

library(mlr3verse)
library(data.table)
set.seed(2)
task = tsk("penguins")
learner = lrn("classif.rpart", predict_type = "response")

# Single prediction set
splits = partition(task)
learner$train(task, row_ids = splits$train)
pred = learner$predict(task, row_ids = splits$test)
pred
pred$score(msr("classif.acc"))

# Resampling
rr = resample(
  task = tsk("penguins"),
  learner = lrn("classif.rpart"),
  resampling = rsmp("cv", folds = 3)
)

rr$predictions()
rr$score(msr("classif.acc"))[, .(iteration, classif.acc)]
rr$aggregate(msr("classif.acc"))

