library("iml")
library("mlr3")
library("palmerpenguins")


data = penguins
task_peng = TaskClassif$new(id = "Species", backend = data, target = "species")

learner = lrn("classif.rpart")
learner$predict_type = "prob"
learner$train(task_peng)
learner$model

X = penguins[which(names(penguins) != "species")]
model = Predictor$new(learner, data = X, y = penguins$species)
effect = FeatureEffects$new(model)
  
