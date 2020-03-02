library("mlr3")
library("mlr3learners")
library("mlr3pipelines")
library("mlr3misc")
data("titanic_train", package = "titanic")
data("titanic_test", package = "titanic")

skimr::skim(titanic_train)
skimr::skim(titanic_test)

data = titanic_train
drop = c("Cabin", "Name", "Ticket", "PassengerId")
data = remove_named(data, drop)
test = remove_named(titanic_test, drop)

data$Embarked = factor(data$Embarked)
test$Embarked = factor(test$Embarked, levels = levels(data$Embarked))
data$Sex = factor(data$Sex)
test$Sex = factor(test$Sex, levels = levels(data$Sex))

median_age = median(data$Age, na.rm = TRUE)
data$Age[is.na(data$Age)] = median_age
test$Age[is.na(test$Age)] = median_age

data$Survived = factor(data$Survived)

task = TaskClassif$new(id = "titanic", data, target = "Survived", positive = "1")
lrn = mlr_learners$get("classif.rpart")


e = Experiment$new(task, lrn)$train()
partykit::plot.party(partykit::as.party(e$model))

e = Experiment$new(task, "classif.log_reg")$train()
summary(e$model)

e = Experiment$new(task, "classif.ranger")$train()
e$model

lrns = mlr_learners$mget(c("classif.featureless", "classif.rpart", "classif.ranger", "classif.log_reg"), predict_type = "prob")
measures = mlr_measures$mget(c("classif.auc", "classif.ce"))

bmr = benchmark(benchmark_grid(task, lrns, "cv"), measures = measures)

e = Experiment$new(task, "classif.ranger")$train()$predict()
e$prediction
e$prediction$confusion
confusion_measures(e$prediction$confusion)

test = test[!is.na(test$Fare), ]
e$predict(newdata = test)
predicted = e$prediction$response
table(predicted)

# - iml fehlt
# - nicht alle variablen / keine feature extraction
# - vorverarbeitung 2x
# - kein tuning
# - vorverarbeitung nicht in resampling
# - vorverarbeitung nicht notwendig fuer alle modelle
