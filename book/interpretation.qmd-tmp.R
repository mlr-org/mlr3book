 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
data("penguins", package = "palmerpenguins")
str(penguins)
 
 
 
 
 
library("mlr3")
library("mlr3learners")
set.seed(1)
 
 
 
penguins = na.omit(penguins)
task_peng = as_task_classif(penguins, target = "species")
 
 
 
 
 
 
learner = lrn("classif.ranger")
learner$predict_type = "prob"
learner$train(task_peng)
learner$model
x = penguins[which(names(penguins) != "species")]
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
library("iml")

model = Predictor$new(learner, data = x, y = penguins$species)

num_features = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g", "year")
effect = FeatureEffects$new(model)
plot(effect, features = num_features)
 
 
 
 
 
 
 
 
 
 
 
 
x = penguins[which(names(penguins) != "species")]
model = Predictor$new(learner, data = penguins, y = "species")
x.interest = data.frame(penguins[1, ])
shapley = Shapley$new(model, x.interest = x.interest)
plot(shapley)
 
 
 
 
 
 
 
 
effect = FeatureImp$new(model, loss = "ce")
effect$plot(features = num_features)
 
 
 
 
 
 
 
 
 
 
 
train_set = sample(task_peng$nrow, 0.8 * task_peng$nrow)
test_set = setdiff(seq_len(task_peng$nrow), train_set)
learner$train(task_peng, row_ids = train_set)
prediction = learner$predict(task_peng, row_ids = test_set)
 
 
 
 
 
# plot on training
model = Predictor$new(learner, data = penguins[train_set, ], y = "species")
effect = FeatureImp$new(model, loss = "ce")
plot_train = plot(effect, features = num_features)

# plot on test data
model = Predictor$new(learner, data = penguins[test_set, ], y = "species")
effect = FeatureImp$new(model, loss = "ce")
plot_test = plot(effect, features = num_features)

# combine into single plot
library("patchwork")
plot_train + plot_test
 
 
 
 
 
 
model = Predictor$new(learner, data = penguins[train_set, ], y = "species")
effect = FeatureEffects$new(model)
plot(effect, features = num_features)
 
 
 
model = Predictor$new(learner, data = penguins[test_set, ], y = "species")
effect = FeatureEffects$new(model)
plot(effect, features = num_features)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| label: fig-dalex-fig-plot-01
knitr::include_graphics("Figures/DALEX_ema_process.png")
 
 
 
 
 
 
 
library("DALEX")
library("DALEXtra")

ranger_exp = DALEX::explain(learner,
  data = penguins[test_set, ],
  y = penguins[test_set, "species"],
  label = "Ranger Penguins",
  colorize = FALSE)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
perf_penguin = model_performance(ranger_exp)
perf_penguin

library("ggplot2")
old_theme = set_theme_dalex("ema")
plot(perf_penguin)
 
 
 
 
 
 
 
 
 
 
 
ranger_effect = model_parts(ranger_exp)
head(ranger_effect)

plot(ranger_effect, show_boxplots = FALSE)
 
 
 
 
 
 
 
 
 
 
 
ranger_profiles = model_profile(ranger_exp)
ranger_profiles

plot(ranger_profiles) +
  theme(legend.position = "top") +
  ggtitle("Partial Dependence for Penguins","")
 
 
 
 
 
 
 
 
 
 
 
steve = penguins[1,]
steve
 
 
 
 
 
 
 
 
 
predict(ranger_exp, steve)
 
 
 
 
 
 
 
 
 
ranger_attributions = predict_parts(ranger_exp, new_observation = steve)
plot(ranger_attributions) + ggtitle("Break Down for Steve")
 
 
 
 
 
 
 
 
 
 
 
ranger_shap = predict_parts(ranger_exp, new_observation = steve,
             type = "shap")
plot(ranger_shap, show_boxplots = FALSE) +
             ggtitle("Shapley values for Steve", "")
 
 
 
 
 
 
 
 
 
 
 
 
 
ranger_ceteris = predict_profile(ranger_exp, steve)
plot(ranger_ceteris) + ggtitle("Ceteris paribus for Steve", " ")
