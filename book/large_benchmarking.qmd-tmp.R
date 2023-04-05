 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| output: false
#| echo: false
#| eval: true
set.seed(1)
options(mlr3oml.cache = here::here("book", "openml", "cache"))
lgr::get_logger("mlr3oml")$set_threshold("off")

library(mlr3batchmark)
library(batchtools)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| warning: false
library(mlr3learners)

lrn_logreg = as_learner(ppl("robustify") %>>%lrn("classif.log_reg"))
lrn_logreg$id = "logreg"
lrn_ranger = as_learner(ppl("robustify") %>>%lrn("classif.ranger"))
lrn_ranger$id = "ranger"

design = benchmark_grid(
  tsks(c("german_credit", "sonar", "breast_cancer")),
  list(lrn_logreg, lrn_ranger),
  rsmp("holdout")
)

print(design)

bmr = benchmark(design)

result = bmr$aggregate(msr("classif.acc"))

result[, .(task_id, learner_id, classif.acc)]
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
library("mlr3oml")
odata = odt(id = 1590)
odata
 
 
 
 
 
 
 
odata$license
head(odata$qualities)
 
 
 
 
 
head(odata$data)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
backend = as_data_backend(odata)
backend
 
 
 
 
 
task = as_task_classif(backend, target = "class")
task
 
 
 
task = as_task(odata)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
otask = otsk(id = 359983)
otask
 
 
 
 
 
otask$data
 
 
 
 
 
 
head(otask$task_splits)
 
 
 
 
 
 
task = as_task(otask)
task
 
 
 
 
 
resampling = as_resampling(otask)
resampling
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| eval: false
odatasets = list_oml_data(
  limit = 5,
  number_features = c(1, 4),
  number_instances = c(100, 1000)
)
 
 
 
#| echo: false
#| output: false
path = here::here("book", "openml", "odatasets_list.rds")
if (!file.exists(path)) {
  odatasets = list_oml_data(
    limit = 5,
    number_features = c(1, 4),
    number_instances = c(100, 1000)
  )
  saveRDS(odatasets, path)
} else {
  odatasets = readRDS(path)
}
 
 
 
 
 
 
 
odatasets[, .(data_id, name, NumberOfFeatures, NumberOfInstances)]
 
 
 
 
 
 
 
 
 
 
 
 
 
#| eval: false
otasks = list_oml_tasks(
  type = "classif",
  number_classes = 2,
  limit = 5
)
 
 
 
#| echo: false
#| output: false

path = here::here("book", "openml", "otasks_list.rds")
if (!file.exists(path)) {
  otasks = list_oml_tasks(
    type = "classif",
    number_classes = 2,
    limit = 5
  )
  saveRDS(otasks, path)
} else {
  otasks = readRDS(path)
}
 
 
 
 
 
 
 
otasks[, .(task_id, task_type, data_id, name, NumberOfClasses)]
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| echo: false
#| output: false

# Collections are not cached (because they can be altered on OpenML).
# This is why we load it from disk
otask_collection = readRDS(here::here("book", "openml", "otask_collection.rds"))
 
 
 
 
 
 
#| eval: false
otask_collection = ocl(id = 99)
 
 
 
otask_collection
 
 
 
 
 
otask_collection$task_ids
 
 
 
 
 
 
 
 
 
#| eval: false
binary_cc18 = list_oml_tasks(task_id = otask_collection$task_ids)
 
 
 
#| echo: false
#| output: false
path = here::here("book", "openml", "binary_cc18.rds")
if (!file.exists(path)) {
  binary_cc18 = list_oml_tasks(task_id = otask_collection$task_ids)
  saveRDS(binary_cc18, path)
} else {
  binary_cc18 = readRDS(path)
}
 
 
 
 
 
head(binary_cc18[, .(task_id, name, NumberOfClasses)])

binary_ids = binary_cc18[NumberOfClasses > 2, task_id]

head(binary_ids)
ids = binary_ids[1:6]
 
 
 
 
 
 
 
 
 
#| eval: false
otasks = lapply(binary_ids, otsk)

tasks = lapply(otasks, as_task)
resamplings = lapply(otasks, as_resampling)
learners = list(lrn_logreg, lrn_ranger)
 
 
 
#| echo: false
learners = list(lrn_logreg, lrn_ranger)
if (file.exists(file.path(here::here(), "book", "openml", "resamplings.rds"))) {
  resamplings = readRDS(file.path(here::here(), "book", "openml", "resamplings.rds"))
} else {
  resamplings = mlr3misc::map(ids, function(id) rsmp("oml", task_id = id))
  saveRDS(resamplings, file.path(here::here(), "book", "openml", "resamplings.rds"))
}

if (file.exists(file.path(here::here(), "book", "openml", "tasks.rds"))) {
  tasks = readRDS(file.path(here::here(), "book", "openml", "tasks.rds"))
} else {
  tasks = mlr3misc::map(ids, function(id) tsk("oml", task_id = id))
  saveRDS(tasks, file.path(here::here(), "book", "openml", "tasks.rds"))
}
 
 
 
 
 
 
 
 
large_design = benchmark_grid_oml(tasks, learners, resamplings)
large_design
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| label: fig-hpc
#| fig-cap: "Illustration of a HPC cluster architecture."
#| fig-align: "center"
#| fig-alt: "A rough sketch of the architecture of a HPC cluster. Ann and Bob both have access to the cluster and can log in to the head node. There, they can submit jobs to the scheduling system, which adds them to its queue and determines when they are run."
#| echo: false
knitr::include_graphics("Figures/hpc.drawio.png")
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
large_design
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
library(batchtools)

reg = makeExperimentRegistry(file.dir = NA, seed = 1)
 
 
 
 
 
 
reg
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
for (i in seq_along(tasks)) {
  addProblem(
    name = tasks[[i]]$id,
    data = list(task = tasks[[i]], resampling = resamplings[[i]]),
    fun = function(data, iteration, ...) {
      list(
        task = data$task,
        resampling = data$resampling,
        iteration = iteration
      )
    },
    reg = reg
  )
}
 
 
 
 
 
 
 
 
 
 
 
 
reg$problems
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
addAlgorithm(
  "run_learner",
  fun = function(instance, learner, ...) {
    library("mlr3verse")
    resampling = instance$resampling
    task = instance$task
    iteration = instance$iteration

    train_ids = resampling$train_set(iteration)
    test_ids = resampling$test_set(iteration)

    learner$train(task, row_ids = train_ids)
    prediction = learner$predict(task, row_ids = test_ids)

    list(state = learner$state, prediction = prediction)
  },
  reg = reg
)

reg$algorithms
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
addExperiments(
  prob.designs = setNames(lapply(reg$problems, function(i) data.table(iteration = 1:10)), reg$problems),
  algo.designs = list(run_learner = data.table(learner = list(lrn_logreg, lrn_ranger))),
  reg = reg
)
 
 
 
 
 
 
 
reg
 
 
 
 
 
 
summarizeExperiments()
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
job_table = getJobTable(reg = reg)


job_table[1:2, c("job.id", "algorithm", "algo.pars", "problem", "prob.pars")]
 
 
 
 
 
#| label: fig-batchtools-illustration
#| fig-cap: "Illustration of batchtools problem, algorithm, and experiment"
#| fig-align: "center"
#| fig-alt: "A problem consists of a static data part and applies the problem function to this data part (and potentially problem parameters) to return a problem instance. The algorithm function takes in a problem instance (and potentially algorithm parameters), executes one job and returns its result."
#| echo: false
knitr::include_graphics("Figures/tikz_prob_algo_simple.png")
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| eval: false
slurm_fn = makeClusterFunctionsSlurm(template = "slurm-simple")
 
 
 
#| echo: false
slurm_fn = makeClusterFunctionsInteractive()
slurm_fn$name = "Slurm"
 
 
 
 
 
#| eval: false
reg$cluster.function = slurm_fn
saveRegistry()
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
logreg_ids = findExperiments(algo.pars = (learner$id == "logreg"))
head(logreg_ids)
 
 
 
#| output: false
testJob(logreg_ids$job.id[[1L]], external = TRUE)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
head(job_table$job.id)
 
 
 
 
 
 
chunks = data.table(job.id = 1:120, chunk = rep(1:6, each = 20))
head(chunks)
 
 
 
 
 
#| eval: false
submitJobs(
  ids = chunks,
  resources = list(ncpus = 1, walltime = 3600, memory = 8000),
  reg = reg
)
 
 
 
 
 
 
 
 
 
 
 
 
#| echo: false
#| output: false
#| cache: false
if (!file.exists(here::here("book", "openml", "results.rds"))) {
  submitJobs(reg = reg)
  waitForJobs(reg = reg)
  results = lapply(job_table$job.id, function(i) loadResult(i, reg = reg))
  saveRDS(results, here::here("book", "openml", "results.rds"))
} else {
  results = readRDS(here::here("book", "openml", "results.rds"))
}
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| eval: false
results = lapply(job_table$job.id, function(i) loadResult(i, reg = reg))
 
 
 
names(results[[1L]])
results[[1L]]$prediction
 
 
 
 
 
 
 
 
 
 
 
 
reg1 = makeExperimentRegistry(NA, seed = 1)
 
 
 
 
 
#| output: false
batchmark(large_design)
 
 
 
 
 
 
 
reg1
 
 
 
 
 
 
 
#| echo: false
if (file.exists(here::here("book", "openml", "bmr_large.rds"))) {
  bmr = readRDS(here::here("book", "openml", "bmr_large.rds"))
} else {
  bmr = benchmark(large_design)
  saveRDS(bmr, here::here("book", "openml", "bmr_large.rds"))
}
 
 
 
 
 
#| eval: false
bmr = reduceBatchmarkResult()
 
 
 
 
 
bmr
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
reg2 = makeExperimentRegistry(NA, seed = 1)

lrn_debug = lrn("classif.debug", error_train = 1)

design = benchmark_grid(tsk("penguins"), lrn_debug, rsmp("holdout"))


batchmark(design)

submitJobs()
 
 
 
 
getStatus()
 
 
 
 
 
findErrors()
getErrorMessages()
 
 
 
tail(getLog(id = 1))
 
 
 
 
 
grepLogs(pattern = "debug", ignore.case = TRUE)
 
 
 
 
 
 
 
 
 
 
 
 
autoplot(bmr)
 
 
 
 
 
 
library("mlr3benchmark")



 
 
 
 
 
 
 
 
 
library(mlr3benchmark)
bma = as.BenchmarkAggr(bmr, measures = msr("classif.acc"))
bma$friedman_posthoc()
 
 
 
autoplot(bma, type = "cd")
