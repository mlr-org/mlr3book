 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
set.seed(4)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| label: fig-naivetuning
#| fig-cap: In this code example we benchmark three random forest models with 1, 10, and 100 trees respectively, using 3-fold resampling, classification error loss, and tested on the simplified penguin dataset. The plot shows that the models with 10 and 100 trees are better performing across all three folds and 100 trees may be better than 10.
#| fig-alt: Boxplots for each of the three configurations showing classification error over the three folds. The image shows the worst performance in the model with 1 tree and similar performance with 10 and 100 trees.
bmr = benchmark(benchmark_grid(
  tasks = tsk("penguins_simple"),
  learners = list(
    lrn("classif.ranger", num.trees = 1, id = "1 tree"),
    lrn("classif.ranger", num.trees = 10, id = "10 trees"),
    lrn("classif.ranger", num.trees = 100, id = "100 trees")),
  resamplings = rsmp("cv", folds = 3)
))

autoplot(bmr)
 
 
 
 
 
 
 
 
 
 
 
 
 
#| label: fig-optimization-loop
#| fig-cap: Representation of the hyperparameter optimization loop in mlr3tuning. Blue - Hyperparameter optimization loop. Purple - Objects of the tuning instance supplied by the user. Blue-Green - Internally created objects of the tuning instance. Green - Optimization Algorithm.
#| echo: false

knitr::include_graphics("Figures/hpo_loop.png")
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
learner = lrn("classif.svm", type = "C-classification", kernel = "radial")
 
 
 
 
 
as.data.table(learner$param_set)[, list(id, class, lower, upper, nlevels)]
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
learner = lrn("classif.svm",
  cost  = to_tune(1e-5, 1e5),
  gamma = to_tune(1e-5, 1e5),
  type  = "C-classification",
  kernel = "radial"
)
learner
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
resampling = rsmp("cv", folds = 3)

measure = msr("classif.ce")

learner = lrn("classif.svm",
  cost  = to_tune(1e-5, 1e5),
  gamma = to_tune(1e-5, 1e5),
  kernel = "radial",
  type = "C-classification"
)

instance = ti(
  task = tsk("sonar"),
  learner = learner,
  resampling = rsmp("cv", folds = 3),
  measures = msr("classif.ce"),
  terminator = trm("none")
)
instance
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
tuner = tnr("grid_search", resolution = 5, batch_size = 5)
tuner
 
 
 
 
 
 
 
 
 
 
 
 
 
tuner$param_set
 
 
 
 
 
 
 
 
tuner$optimize(instance)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
learner = lrn("classif.svm",
  cost  = to_tune(1e-5, 1e5),
  gamma = to_tune(1e-5, 1e5),
  kernel = "radial",
  type = "C-classification"
)

instance = tune(
  method = tnr("grid_search", resolution = 5, batch_size = 5),
  task = tsk("sonar"),
  learner = learner,
  resampling = rsmp("cv", folds = 3),
  measures = msr("classif.ce")
)

instance$result
 
 
 
 
 
 
 
as.data.table(instance$archive)[, list(cost, gamma, classif.ce)]
 
 
 
 
 
 
 
 
 
as.data.table(instance$archive)[,
  list(timestamp, runtime_learners, errors, warnings)]
 
 
 
 
 
 
 
as.data.table(instance$archive,
  measures = msrs(c("classif.fpr", "classif.fnr")))[,
  list(cost, gamma, classif.ce, classif.fpr, classif.fnr)]
 
 
 
 
 
 
 
 
 
#| label: fig-surface
#| fig-cap: Model performance with different configurations for cost and gamma. Bright yellow regions represent the model performing worse and dark blue performing better. We can see that high `cost` values and `gamma` values around `exp(-5)` achieve the best performance.
#| fig-alt: Heatmap showing model performance during HPO. y-axis is 'gamma' parameter between (-10,10) and x-axis is 'cost' parameter between (-10,10). The heatmap shows squares covering all points on the plot and circular points indicating configurations tried in our optimisation. The top-left quadrant is all yellow indicating poor performance when gamma is high and cost is low. The bottom-right is dark blue indicating good performance when cost is high and gamme is low.
autoplot(instance, type = "surface")
 
 
 
 
 
 
 
 
svm_tuned = lrn("classif.svm", id = "SVM Tuned")
svm_tuned$param_set$values = instance$result_learner_param_vals
 
 
 
 
 
 
svm_tuned$train(tsk("sonar"))
svm_tuned$model
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
learner$encapsulate = c(train = "evaluate", predict = "evaluate")
 
 
 
 
 
 
 
 
 
 
learner$timeout = 30
 
 
 
 
 
 
 
 
 
 
 
 
learner$fallback = lrn("classif.featureless")
 
 
 
 
 
as.data.table(instance$archive)[, list(cost, gamma, classif.ce, errors, warnings)]
 
 
 
 
 
 
 
 
 
 
cost = runif(1000, log(1e-5), log(1e5))
 
 
 
#| echo: false
#| label: fig-logscale
#| fig-cap: Histogram of sampled `cost` values.
#| fig-subcap:
#|   - "`cost` values sampled by the optimization algorithm."
#|   - "`exp(cost)` values seen by the learner."
#| layout-ncol: 2
library(ggplot2)
library(viridisLite)

data = data.frame(cost = cost)
ggplot(data, aes(x = cost)) +
  geom_histogram(
    bins = 15,
    fill = viridis(1, begin = 0.5),
    alpha = 0.8,
    color = "black") +
  theme_minimal()

data = data.frame(cost = exp(cost))
ggplot(data, aes(x = cost)) +
  geom_histogram(
    bins = 15,
    fill = viridis(1, begin = 0.5),
    alpha = 0.8,
    color = "black") +
  theme_minimal()
 
 
 
 
 
learner = lrn("classif.svm",
  cost  = to_tune(1e-5, 1e5, logscale = TRUE),
  gamma = to_tune(1e-5, 1e5, logscale = TRUE),
  kernel = "radial",
  type = "C-classification"
)

instance = tune(
  method = tnr("grid_search", resolution = 5, batch_size = 5),
  task = tsk("sonar"),
  learner = learner,
  resampling = rsmp("cv", folds = 3),
  measures = msr("classif.ce")
)

instance$result
 
 
 
 
 
instance$result$x_domain
 
 
 
 
 
 
 
 
 
 
as.data.table(mlr_tuning_spaces)
 
 
 
 
 
 
lts("classif.rpart.default")
 
 
 
 
 
instance = ti(
  task = tsk("sonar"),
  learner = lrn("classif.rpart"),
  resampling = rsmp("cv", folds = 3),
  measures = msr("classif.ce"),
  terminator = trm("evals", n_evals = 20),
  search_space = lts("classif.rpart.rbv2")
)
instance
 
 
 
 
 
vals = lts("classif.rpart.default")$values
vals
learner = lrn("classif.rpart")
learner$param_set$set_values(.values = vals)
learner
 
 
 
 
 
lts(lrn("classif.rpart"))
 
 
 
 
 
lts("classif.xgboost.rbv2", nrounds = to_tune(1, 1024))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
learner = lrn("classif.rpart",
  cp = to_tune(1e-04, 1e-1, logscale = TRUE),
  minsplit = to_tune(2, 128, logscale = TRUE),
  maxdepth = to_tune(1, 30)
)

measures = msrs(c("classif.ce", "selected_features"))
 
 
 
 
 
instance = ti(
  task = tsk("spam"),
  learner = learner,
  resampling = rsmp("cv", folds = 3),
  measures = measures,
  terminator = trm("evals", n_evals = 20),
  store_models = TRUE  # required to inspect selected_features
)
instance
 
 
 
 
 
tuner = tnr("random_search", batch_size = 20)
tuner$optimize(instance)
 
 
 
 
 
 
instance$archive$best()[, list(cp, minsplit, maxdepth, classif.ce, selected_features)]
 
 
 
#| label: fig-pareto
#| fig-cap: Pareto front of selected features and classification error. Black dots represent tested configurations, each red dot individually represents a Pareto-optimal configuration and all red dots together represent the Pareto front.
#| fig-alt: Scatter plot with selected_features on x-axis and classif.ce on y-axis. Black dots represent simulated tested configurations of selected_features vs. classif.ce and red dots and a red line along the bottom-left of the plot shows the Pareto front.
#| echo: false
library(ggplot2)
library(viridisLite)

ggplot(instance$archive$best(), aes(x = selected_features, y = classif.ce)) +
  geom_step(
    direction = "vh",
    colour = viridis(1, begin = 0.5),
    linewidth = 1) +
  geom_point(
    shape = 21,
    size = 3,
    fill = viridis(1, begin = 0.33),
    alpha = 0.8,
    stroke = 0.5) +
  geom_point(
    data = as.data.table(instance$archive),
    shape = 21,
    size = 3,
    fill = viridis(1, begin = 0.66),
    alpha = 0.8,
    stroke = 0.5) +
  theme_minimal()
 
 
 
 
 
 
 
 
 
 
 
 
learner = lrn("classif.svm",
  cost  = to_tune(1e-5, 1e5, logscale = TRUE),
  gamma = to_tune(1e-5, 1e5, logscale = TRUE),
  kernel = "radial",
  type = "C-classification"
)

at = auto_tuner(
  method = tnr("grid_search", resolution = 5, batch_size = 5),
  learner = learner,
  resampling = rsmp("cv", folds = 3),
  measure = msr("classif.ce")
)

at
 
 
 
 
 
 
task = tsk("sonar")
split = partition(task)
at$train(task, row_ids = split$train)
at$predict(task, row_ids = split$test)$score()
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| label: fig-nested-resampling
#| fig-cap: An illustration of nested resampling. The green blocks represent 3-fold coss-validation for the outer resampling for model evaluation and the blue and gray blocks represent 4-fold cross-validation for the inner resampling for HPO.
#| fig-alt: The image shows three rows of blocks in light and dark green representing three-fold cross-validation for the outer resampling. Below the dark green blocks are four further rows of blue and gray blocks representing four-fold cross-validation for the inner resampling.
#| echo: false

knitr::include_graphics("Figures/nested_resampling.png")
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
learner = lrn("classif.svm",
  cost  = to_tune(1e-5, 1e5, logscale = TRUE),
  gamma = to_tune(1e-5, 1e5, logscale = TRUE),
  kernel = "radial",
  type = "C-classification"
)

at = auto_tuner(
  method = tnr("grid_search", resolution = 5, batch_size = 5),
  learner = learner,
  resampling = rsmp("cv", folds = 4),
  measure = msr("classif.ce"),
  term_evals = 20,
)

task = tsk("sonar")
outer_resampling = rsmp("cv", folds = 3)

rr = resample(task, at, outer_resampling, store_models = TRUE)

rr
 
 
 
 
 
 
 
 
 
 
 
extract_inner_tuning_results(rr)[,
  list(iteration, cost, gamma, classif.ce)]
extract_inner_tuning_archives(rr)[,
  list(iteration, cost, gamma, classif.ce)]
 
 
 
 
 
 
 
 
 
 
 
 
extract_inner_tuning_results(rr)[,
  list(iteration, cost, gamma, classif.ce)]

rr$score()[,
  list(iteration, classif.ce)]
 
 
 
 
 
 
 
 
 
rr$aggregate()
