 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| include: false
#| cache: false
lgr::get_logger("mlr3oml")$set_threshold("off")
library(mlr3batchmark)
library(batchtools)
library(mlr3oml)

if (!exists("params")) params = list(rebuild_cache = FALSE)

if (params$rebuild_cache) {
  unlink(here::here("book", "openml"), recursive = TRUE)
  dir.create(here::here("book", "openml"))

  collection = ocl(269)
  collection$task_ids

  saveRDS(collection, here::here("book", "openml", "collection_269.rds"))
  tbl = list_oml_tasks(task_id = collection$task_ids, number_instances = c(0, 4000))
  saveRDS(tbl, here::here("book", "openml", "tbl_269.rds"))

  tasks = lapply(tbl$task_id, function(id) tsk("oml", task_id = id))
  saveRDS(tasks, here::here("book", "openml", "tasks_269_subset.rds"))
  
}

options(mlr3oml.cache = here::here("book", "openml", "cache"))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| warning: false
# create logistic regression pipeline
learner_logreg = lrn("classif.log_reg")
learner_logreg = as_learner(
  ppl("robustify", learner = learner_logreg) %>>% learner_logreg)
learner_logreg$id = "logreg"
learner_logreg$fallback = lrn("classif.featureless")

# create random forest pipeline
learner_ranger = lrn("classif.ranger")
learner_ranger = as_learner(
  ppl("robustify", learner = learner_ranger) %>>% learner_ranger)
learner_ranger$id = "ranger"
learner_logreg$fallback = lrn("classif.featureless")

# create full grid design with holdout resampling
design = benchmark_grid(
  tsks(c("german_credit", "sonar", "spam")),
  list(learner_logreg, learner_ranger),
  rsmp("holdout")
)

# run the benchmark
set.seed(123)
bmr = benchmark(design)

# retrieve results
acc = bmr$aggregate(msr("classif.acc"))
acc[, .(task_id, learner_id, classif.acc)]
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
library("mlr3oml")
odata = odt(id = 1590)
odata
 
 
 
 
 
 
odata$license
 
 
 
 
 
odata$data
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
backend = as_data_backend(odata)
backend
 
 
 
 
 
task = as_task_classif(backend, target = "class")
task
 
 
 
task = as_task(odata)
 
 
 
 
 
 
 
 
 
 
otask = otsk(id = 359983)
otask
 
 
 
 
 
otask$data
 
 
 
 
 
 
otask$task_splits
 
 
 
 
 
 
task = as_task(otask)
task
 
 
 
 
 
resampling = as_resampling(otask)
resampling
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| eval: !expr params$rebuild_cache
odatasets = list_oml_data(
  limit = 5,
  number_features = c(1, 4),
  number_instances = c(100, 1000),
  number_classes = 2
)
 
 
 
#| echo: false
path = here::here("book", "openml", "odatasets_list.rds")
if (params$rebuild_cache) {
  saveRDS(odatasets, path)
} else {
  odatasets = readRDS(path)
}
 
 
 
 
 
 
 
odatasets[,
  .(data_id, NumberOfClasses, NumberOfFeatures, NumberOfInstances)]
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| eval: !expr params$rebuild_cache
otask_collection = ocl(id = 99)
 
 
 
#| echo: false
#| output: false

# Collections are not cached (because they can be altered on OpenML).
# This is why we load it from disk
path = here::here("book", "openml", "otask_collection.rds")
if (params$rebuild_cache) {
  saveRDS(otask_collection, path)
} else {
  otask_collection = readRDS(path)
}
 
 
 
 
 
 
otask_collection
 
 
 
 
 
otask_collection$task_ids
 
 
 
 
 
 
 
 
#| eval: !expr params$rebuild_cache
binary_cc18 = list_oml_tasks(
  task_id = otask_collection$task_ids, number_classes = 2)
 
 
 
#| echo: false
#| output: false
path = here::here("book", "openml", "binary_cc18.rds")
if (params$rebuild_cache) {
  saveRDS(binary_cc18, path)
} else {
  binary_cc18 = readRDS(path)
}
 
 
 
 
 
binary_cc18[, .(task_id, name, NumberOfClasses)]
ids = binary_cc18$task_id[1:6]
 
 
 
 
 
 
#| eval: !expr params$rebuild_cache
otasks = lapply(ids, otsk)

tasks = lapply(otasks, as_task)
resamplings = lapply(otasks, as_resampling)

learner_featureless = lrn("classif.featureless", id = "featureless")
learners = list(learner_logreg, learner_ranger, learner_featureless)
 
 
 
#| echo: false
path_resamplings = here::here("book", "openml", "resamplings.rds")
path_tasks = here::here("book", "openml", "tasks.rds")

if (params$rebuild_cache) {
  saveRDS(resamplings, path_resamplings)
  saveRDS(tasks, path_tasks)
} else {
  resamplings = readRDS(path_resamplings)
  tasks = readRDS(path_tasks)
  learners = list(learner_logreg, learner_ranger, lrn("classif.featureless", id = "featureless"))
}
 
 
 
 
 
large_design = benchmark_grid(
  tasks, learners, resamplings, paired = TRUE
)
large_design
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| label: fig-hpc
#| fig-cap: "Illustration of an HPC cluster architecture."
#| fig-align: "center"
#| fig-alt: "A rough sketch of the architecture of an HPC cluster. Ann and Bob both have access to the cluster and can log in to the head node. There, they can submit jobs to the scheduling system, which adds them to its queue and determines when they are run."
#| echo: false
knitr::include_graphics("Figures/hpc.drawio.png")
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
library(batchtools)

reg = makeExperimentRegistry(
  file.dir = NA,
  seed = 1,
  packages = "mlr3verse"
)
 
 
 
 
 
 
reg
 
 
 
 
 
 
 
 
 
 
 
 
#| output: false
batchmark(large_design, reg = reg)
 
 
 
 
 
 
 
 
 
 
 
 
 
reg
 
 
 
 
 
 
 
summarizeExperiments()
 
 
 
 
 
 
 
 
job_table = getJobTable(reg = reg)
job_table = unwrap(job_table)
job_table = job_table[,
  .(job.id, learner_id, task_id, resampling_id, repl)
]

job_table
 
 
 
 
 
 
 
 
 
 
#| output: false
testJob(1, external = TRUE)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| eval: false
slurm_fn = makeClusterFunctionsSlurm(template = "slurm-simple")
 
 
 
#| echo: false
slurm_fn = makeClusterFunctionsInteractive()
slurm_fn$name = "Slurm"
 
 
 
 
 
 
 
 
 
 
#| eval: false
reg$cluster.function = slurm_fn
saveRegistry(reg)
 
 
 
 
 
 
 
 
 
 
 
 
 
chunks = data.table(job.id = job_table$job.id, chunk = rep(1:36, each = 5))
chunks
 
 
 
 
 
#| eval: !expr params$rebuild_cache
submitJobs(
  ids = chunks,
  resources = list(ncpus = 1, walltime = 3600, memory = 8000),
  reg = reg
)
 
 
 
#| include: false
#| eval: !expr params$rebuild_cache
waitForJobs(reg = reg)
 
 
 
 
 
 
 
 
 
 
 
 
 
#| eval: !expr params$rebuild_cache
bmr = reduceResultsBatchmark(reg = reg)
 
 
 
#| include: false
path = here::here("book", "openml", "bmr_large.rds")
if (params$rebuild_cache) {
  saveRDS(bmr, path)
} else {
  bmr = readRDS(path)
}
 
 
 
 
 
bmr
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
#| output: false
reg = makeExperimentRegistry(NA, seed = 1, packages = "mlr3verse")
learner_debug = lrn("classif.debug", error_train = 1)
design = benchmark_grid(tsk("penguins"), learner_debug, rsmp("holdout"))
batchmark(design, reg = reg)
submitJobs(1, reg = reg)
waitForJobs(reg = reg)
 
 
 
 
 
getStatus(reg = reg)
 
 
 
 
 
findErrors(reg = reg)
getErrorMessages(reg = reg)
 
 
 
 
 
#| eval: false
ids = findExperiments(algo.pars = learner_id == "classif.log_reg", reg = reg)
ids = grepLogs(ids, pattern = "did not converge", fixed = TRUE, reg = reg)
submitJobs(ids, reg = reg)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
reg = makeExperimentRegistry(
  file.dir = NA,
  seed = 1,
  packages = "mlr3verse"
)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
#| output: false
for (i in seq_along(tasks)) {
  addProblem(
    name = tasks[[i]]$id,
    data = list(task = tasks[[i]], resampling = resamplings[[i]]),
    fun = function(data, job, ...) data,
    reg = reg
  )
}
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
```{r large_benchmarking-051}
#| cache: false
addAlgorithm(
  "run_learner",
  fun = function(instance, learner, job, ...) {
    resample(instance$task, learner, instance$resampling)
  },
  reg = reg
)

reg$algorithms
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| cache: false
#| output: false
library(data.table)

algorithm_design = list(run_learner = data.table(learner = learners))
print(algorithm_design$run_learner)

addExperiments(algo.designs = algorithm_design)
 
 
 
 
 
reg
 
 
 
 
 
#| label: fig-batchtools-illustration
#| fig-cap: "Illustration the batchtools problem, algorithm, and experiment. "
#| fig-align: "center"
#| fig-alt: "A problem consists of a static data part and applies the problem function to this data part (and potentially problem parameters) to return a problem instance. The algorithm function takes in a problem instance (and potentially algorithm parameters), executes one job and returns its result."
#| echo: false
knitr::include_graphics("Figures/tikz_prob_algo_simple.png")
 
 
 
 
 
 
 
#| eval: !expr params$rebuild_cache
batchtools::submitJobs(reg = reg)
 
 
 
#| include: false
#| eval: !expr params$rebuild_cache
waitForJobs(reg = reg)
 
 
 
 
 
 
 
 
#| eval: !expr params$rebuild_cache
rr = loadResult(1, reg = reg)
rr
 
 
 
 
 
 
 
#| eval: !expr params$rebuild_cache
bmr = reduceResults(c, reg = reg)
 
 
 
#| echo: false
#| output: false
#| cache: false
path = here::here("book", "openml", "bmr.rds")
if (params$rebuild_cache) {
  saveRDS(bmr, path)
} else {
  bmr = readRDS(path)
}
 
 
 
bmr
 
 
 
 
 
 
 
 
 
 
 
 
 
 
library("mlr3benchmark")
bma = as_benchmark_aggr(bmr, measures = msr("classif.acc"))
bma$friedman_posthoc()
 
 
 
 
 
 
autoplot(bma, type = "cd")
