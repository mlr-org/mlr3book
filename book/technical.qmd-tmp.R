 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
library("mlr3learners") # for the ranger learner

learner = lrn("classif.ranger")
learner$param_set$ids(tags = "threads")
 
 
 
 
# use 4 CPUs
set_threads(learner, n = 4)

# auto-detect cores on the local machine
set_threads(learner)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
options(mc.cores = 4)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
# select the multisession backend to use
future::plan("multisession")

# define objects to perform a resampling
task = tsk("spam")
learner = lrn("classif.rpart")
resampling = rsmp("cv", folds = 3)

time = proc.time()[3]
resample(task, learner, resampling)
diff = proc.time()[3] - time
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
library("mlr3tuning")

learner = lrn("classif.rpart",
  minsplit  = to_tune(2, 128, logscale = TRUE)
)

at = auto_tuner(
  method = tnr("random_search"),
  learner = learner,
  resampling = rsmp("cv", folds = 2), # inner CV
  measure = msr("classif.ce"),
  term_evals = 20,
)
 
 
 
resample(
  task = tsk("penguins"),
  learner = at,
  resampling = rsmp("cv", folds = 5) # outer CV
)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
# Runs the outer loop sequentially and the inner loop in parallel
  future::plan(list("sequential", "multisession"))
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
# Runs both loops in parallel
future::plan(list(
  future::tweak("multisession", workers = 2),
  future::tweak("multisession", workers = 4)
))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
task = tsk("penguins")
learner = lrn("classif.debug")
print(learner)
 
 
 
 
 
 
 
 
 
 
learner$param_set
 
 
 
 
 
task = tsk("penguins")
learner$train(task)$predict(task)$confusion
 
 
 
 
 
 
# set probability to signal an error to 1
learner$param_set$values = list(error_train = 1)

learner$train(tsk("iris"))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
task = tsk("penguins")
learner = lrn("classif.debug")

# this learner throws a warning and then stops with an error during train()
learner$param_set$values = list(warning_train = 1, error_train = 1)

# enable encapsulation for train() and predict()
learner$encapsulate = c(train = "evaluate", predict = "evaluate")

learner$train(task)
 
 
 
 
 
learner$log
learner$warnings
learner$errors
 
 
 
 
 
 
 
 
learner$encapsulate = c(train = "callr", predict = "callr")
learner$param_set$values = list(segfault_train = 1)
learner$train(task = task)
learner$errors
 
 
 
 
 
 
 
learner$predict(task)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
task = tsk("penguins")

learner = lrn("classif.debug")
learner$param_set$values = list(error_train = 1)
learner$fallback = lrn("classif.featureless")

learner$train(task)
learner
 
 
 
 
 
 
learner$model
prediction = learner$predict(task)
prediction$score()
 
 
 
 
 
 
 
 
 
learner$param_set$values = list(error_train = 0.3)

bmr = benchmark(benchmark_grid(tsk("penguins"), list(learner, lrn("classif.rpart")), rsmp("cv")))
aggr = bmr$aggregate(conditions = TRUE)
aggr[, .(learner_id, warnings, errors, classif.ce)]
 
 
 
 
 
 
 
 
rr = aggr[learner_id == "classif.debug"]$resample_result[[1L]]
rr$errors
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
task = tsk("penguins")
learner = lrn("classif.debug")

# this hyperparameter sets the ratio of missing predictions
learner$param_set$values = list(predict_missing = 0.5)

# without fallback
p = learner$train(task)$predict(task)
table(p$response, useNA = "always")

# with fallback
learner$fallback = lrn("classif.featureless")
p = learner$train(task)$predict(task)
table(p$response, useNA = "always")
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
task = tsk("penguins")
backend = task$backend
backend$nrow
backend$ncol
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
# load data
requireNamespace("DBI")
requireNamespace("RSQLite")
requireNamespace("nycflights13")
data("flights", package = "nycflights13")
str(flights)

# add column of unique row ids
flights$row_id = 1:nrow(flights)

# create sqlite database in temporary file
path = tempfile("flights", fileext = ".sqlite")
con = DBI::dbConnect(RSQLite::SQLite(), path)
tbl = DBI::dbWriteTable(con, "flights", as.data.frame(flights))
DBI::dbDisconnect(con)

# remove in-memory data
rm(flights)
 
 
 
 
 
# establish connection
con = DBI::dbConnect(RSQLite::SQLite(), path)

# select the "flights" table, enter dplyr
library("dplyr")
library("dbplyr")
tbl = tbl(con, "flights")
 
 
 
 
 
keep = c("row_id", "year", "month", "day", "hour", "minute", "dep_time",
  "arr_time", "carrier", "flight", "air_time", "distance", "arr_delay")
tbl = select(tbl, all_of(keep))
 
 
 
 
 
tbl = filter(tbl, !is.na(arr_delay))
 
 
 
 
 
tbl = filter(tbl, row_id %% 2 == 0)
 
 
 
 
 
tbl = mutate(tbl, carrier = case_when(
  carrier %in% c("OO", "HA", "YV", "F9", "AS", "FL", "VX", "WN") ~ "other",
  TRUE ~ carrier))
 
 
 
 
 
library("mlr3db")
b = as_data_backend(tbl, primary_key = "row_id")
 
 
 
 
 
b$nrow
b$ncol
b$head()
 
 
 
 
 
 
 
 
 
 
 
 
task = as_task_regr(b, id = "flights_sqlite", target = "arr_delay")
learner = lrn("regr.rpart")
measures = mlr_measures$mget(c("regr.mse", "time_train", "time_predict"))
resampling = rsmp("subsampling", repeats = 3, ratio = 0.02)
 
 
 
 
 
 
rr = resample(task, learner, resampling)
print(rr)
rr$aggregate(measures)
 
 
 
 
 
 
rm(tbl)
DBI::dbDisconnect(con)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
path = system.file(file.path("extdata", "spam.parquet"), package = "mlr3db")
 
 
 
 
 
backend = as_duckdb_backend(path)
task = as_task_classif(backend, target = "type")
print(task)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
library("paradox")

ps = ParamSet$new()
ps2 = ps
ps3 = ps$clone(deep = TRUE)
print(ps) # the same for ps2 and ps3
 
 
 
ps$add(ParamLgl$new("a"))
 
 
 
print(ps)  # ps was changed
print(ps2) # contains the same reference as ps
print(ps3) # is a "clone" of the old (empty) ps
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
library("paradox")
parA = ParamLgl$new(id = "A")
parB = ParamInt$new(id = "B", lower = 0, upper = 10, tags = c("tag1", "tag2"))
parC = ParamDbl$new(id = "C", lower = 0, upper = 4, special_vals = list(NULL))
parD = ParamFct$new(id = "D", levels = c("x", "y", "z"), default = "y")
parE = ParamUty$new(id = "E", custom_check = function(x) checkmate::checkFunction(x))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
parB$lower
parA$levels
parE$class
 
 
 
 
 
as.data.table(parA)
 
 
 
 
 
 
 
 
 
parA$test(FALSE)
parA$test("FALSE")
parA$check("FALSE")
 
 
 
 
 
 
 
 
 
 
 
 
ps = ParamSet$new(list(parA, parB))
ps$add(parC)
ps$add(ParamSet$new(list(parD, parE)))
print(ps)
 
 
 
 
 
 
 
 
 
psSmall = ps$clone()
psSmall$subset(c("A", "B", "C"))
print(psSmall)
 
 
 
 
 
 
as.data.table(ps)
 
 
 
 
 
 
 
 
 
ps$check(list(A = TRUE, B = 0, E = identity))
ps$check(list(A = 1))
ps$check(list(Z = 1))
 
 
 
 
 
 
 
 
 
 
ps$values = list(A = TRUE, B = 0)
ps$values$B = 1
print(ps$values)
 
 
 
 
 
ps$values$B = 100
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
ps$add_dep("D", "A", CondEqual$new(FALSE))
ps$add_dep("B", "D", CondAnyOf$new(c("x", "y")))
 
 
 
ps$check(list(A = FALSE, D = "x", B = 1))          # OK: all dependencies met
ps$check(list(A = FALSE, D = "z", B = 1))          # B's dependency is not met
ps$check(list(A = FALSE, B = 1))                   # B's dependency is not met
ps$check(list(A = FALSE, D = "z"))                 # OK: B is absent
ps$check(list(A = TRUE))                           # OK: neither B nor D present
ps$check(list(A = TRUE, D = "x", B = 1))           # D's dependency is not met
ps$check(list(A = TRUE, B = 1))                    # B's dependency is not met
 
 
 
 
 
 
 
 
ps$deps
 
 
 
 
 
 
 
 
 
ps2d = ParamDbl$new("x", lower = 0, upper = 1)$rep(2)
print(ps2d)
 
 
 
ps$add(ps2d)
print(ps)
 
 
 
 
 
 
 
 
 
ps$tags
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
design = generate_design_grid(psSmall, 2)
print(design)
 
 
 
generate_design_grid(psSmall, param_resolutions = c(B = 1, C = 2))
 
 
 
 
 
 
 
 
 
 
pvrand = generate_design_random(ps2d, 500)
pvlhs = generate_design_lhs(ps2d, 500)
 
 
 
#| layout: [[40, 40]]
par(mar=c(4, 4, 2, 1))
plot(pvrand$data, main = "'random' design", xlim = c(0, 1), ylim=c(0, 1))
plot(pvlhs$data, main = "'lhs' design", xlim = c(0, 1), ylim=c(0, 1))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
sampA = Sampler1DCateg$new(parA)
sampA$sample(5)
 
 
 
 
 
 
 
 
 
 
 
 
 
psSmall$add_dep("B", "A", CondEqual$new(TRUE))
sampH = SamplerHierarchical$new(psSmall,
  list(Sampler1DCateg$new(parA),
    Sampler1DUnif$new(parB),
    Sampler1DUnif$new(parC))
)
sampled = sampH$sample(1000)
table(sampled$data[, c("A", "B")], useNA = "ifany")
 
 
 
 
 
 
 
 
 
sampJ = SamplerJointIndep$new(
  list(Sampler1DUnif$new(ParamDbl$new("x", 0, 1)),
    Sampler1DUnif$new(ParamDbl$new("y", 0, 1)))
)
sampJ$sample(5)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
psexp = ParamSet$new(list(ParamDbl$new("par", 0, 1)))
psexp$trafo = function(x, param_set) {
  x$par = -log(x$par)
  x
}
design = generate_design_random(psexp, 2)
print(design)
design$transpose()  # trafo is TRUE
 
 
 
 
 
design$transpose(trafo = FALSE)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
methodPS = ParamSet$new(
  list(
    ParamUty$new("fun",
      custom_check = function(x) checkmate::checkFunction(x, nargs = 1))
  )
)
print(methodPS)
 
 
 
 
 
samplingPS = ParamSet$new(
  list(
    ParamFct$new("fun", c("mean", "median", "min", "max"))
  )
)

samplingPS$trafo = function(x, param_set) {
  # x$fun is a `character(1)`,
  # in particular one of 'mean', 'median', 'min', 'max'.
  # We want to turn it into a function!
  x$fun = get(x$fun, mode = "function")
  x
}
 
 
 
design = generate_design_random(samplingPS, 2)
print(design)
 
 
 
 
 
 
xvals = design$transpose()
print(xvals[[1]])
 
 
 
 
 
methodPS$check(xvals[[1]])
xvals[[1]]$fun(1:10)
 
 
 
 
 
 
 
 
samplingPS2 = ParamSet$new(
  list(
    ParamDbl$new("quantile", 0, 1)
  )
)

samplingPS2$trafo = function(x, param_set) {
  # x$quantile is a `numeric(1)` between 0 and 1.
  # We want to turn it into a function!
  list(fun = function(input) quantile(input, x$quantile))
}
 
 
 
design = generate_design_random(samplingPS2, 2)
print(design)
 
 
 
 
 
 
xvals = design$transpose()
print(xvals[[1]])
methodPS$check(xvals[[1]])
xvals[[1]]$fun(1:10)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
search_space = ps()
print(search_space)
 
 
 
 
 
 
search_space = ps(
  cost = p_dbl(lower = 0.1, upper = 10),
  kernel = p_fct(levels = c("polynomial", "radial"))
)
print(search_space)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
search_space = ps(cost = p_dbl(0.1, 10), kernel = p_fct(c("polynomial", "radial")))
 
 
 
 
 
 
 
 
 
 
 
library("data.table")
rbindlist(generate_design_grid(search_space, 3)$transpose())
 
 
 
 
 
 
 
 
 
search_space = ps(
  cost = p_dbl(-1, 1, trafo = function(x) 10^x),
  kernel = p_fct(c("polynomial", "radial"))
)
rbindlist(generate_design_grid(search_space, 3)$transpose())
 
 
 
 
 
 
 
 
 
search_space = ps(
  cost = p_dbl(-1, 1, trafo = function(x) 10^x),
  kernel = p_fct(c("polynomial", "radial")),
  .extra_trafo = function(x, param_set) {
    if (x$kernel == "polynomial") {
      x$cost = x$cost * 2
    }
    x
  }
)
rbindlist(generate_design_grid(search_space, 3)$transpose())
 
 
 
 
 
 
 
 
 
 
 
search_space = ps(
  class.weights = p_dbl(0.1, 0.9, trafo = function(x) c(spam = x, nonspam = 1 - x))
)
generate_design_grid(search_space, 3)$transpose()
 
 
 
 
 
 
 
 
 
 
 
 
 
search_space = ps(
  cost = p_fct(c(0.1, 3, 10)),
  kernel = p_fct(c("polynomial", "radial"))
)
rbindlist(generate_design_grid(search_space, 3)$transpose())
 
 
 
 
search_space = ps(
  cost = p_fct(c("0.1", "3", "10"),
    trafo = function(x) list(`0.1` = 0.1, `3` = 3, `10` = 10)[[x]]),
  kernel = p_fct(c("polynomial", "radial"))
)
rbindlist(generate_design_grid(search_space, 3)$transpose())
 
 
 
 
 
 
 
search_space = ps(
  cost = p_fct(c(0.1, 3, 10)),
  kernel = p_fct(c("polynomial", "radial"))
)
typeof(search_space$params$cost$levels)
 
 
 
 
 
 
 
 
 
 
search_space = ps(
  class.weights = p_fct(
    list(
      candidate_a = c(spam = 0.5, nonspam = 0.5),
      candidate_b = c(spam = 0.3, nonspam = 0.7)
    )
  )
)
generate_design_grid(search_space)$transpose()
 
 
 
 
 
 
 
 
 
 
 
search_space = ps(
  cost = p_dbl(-1, 1, trafo = function(x) 10^x),
  kernel = p_fct(c("polynomial", "radial")),
  degree = p_int(1, 3, depends = kernel == "polynomial")
)
rbindlist(generate_design_grid(search_space, 3)$transpose(), fill = TRUE)
 
 
 
 
 
 
 
 
 
 
 
 
learner = lrn("classif.svm")
learner$param_set$values$kernel = "polynomial" # for example
learner$param_set$values$degree = to_tune(lower = 1, upper = 3)

print(learner$param_set$search_space())

rbindlist(generate_design_grid(
  learner$param_set$search_space(), 3)$transpose()
)
 
 
 
 
 
 
learner$param_set$values$shrinking = to_tune()

print(learner$param_set$search_space())

rbindlist(generate_design_grid(
  learner$param_set$search_space(), 3)$transpose()
)
 
 
 
 
 
 
 
 
 
 
 
 
learner$param_set$values$type = "C-classification" # needs to be set because of a bug in paradox
learner$param_set$values$cost = to_tune(c(val1 = 0.3, val2 = 0.7))
learner$param_set$values$shrinking = to_tune(p_lgl(depends = cost == "val2"))

print(learner$param_set$search_space())

rbindlist(generate_design_grid(learner$param_set$search_space(), 3)$transpose(), fill = TRUE)
 
 
 
 
 
 
 
learner$param_set$values$cost = NULL
learner$param_set$values$shrinking = NULL
learner$param_set$values$kernel = to_tune(c("polynomial", "radial"))

print(learner$param_set$search_space())

rbindlist(generate_design_grid(learner$param_set$search_space(), 3)$transpose(), fill = TRUE)
 
 
 
 
 
 
 
 
learner$param_set$values$class.weights = to_tune(
  ps(spam = p_dbl(0.1, 0.9), nonspam = p_dbl(0.1, 0.9),
    .extra_trafo = function(x, param_set) list(c(spam = x$spam, nonspam = x$nonspam))
))
head(generate_design_grid(learner$param_set$search_space(), 3)$transpose(), 3)
 
 
 
 
 
 
 
 
 
 
 
 
requireNamespace("lgr")

logger = lgr::get_logger("mlr3")
logger$set_threshold("<level>")
 
 
 
 
 
 
getOption("lgr.log_levels")
 
 
 
 
 
lgr::get_logger("mlr3")$set_threshold("debug")
 
 
 
 
 
lgr::get_logger("mlr3")$set_threshold("warn")
 
 
 
 
 
 
 
 
 
lgr::get_logger("mlr3")$set_threshold("warn")
lgr::get_logger("bbotk")$set_threshold("info")
 
 
 
 
 
 
 
 
tf = tempfile("mlr3log_", fileext = ".json")

# get the logger as R6 object
logger = lgr::get_logger("mlr")

# add Json appender
logger$add_appender(lgr::AppenderJson$new(tf), name = "json")

# signal a warning
logger$warn("this is a warning from mlr3")

# print the contents of the file
cat(readLines(tf))

# remove the appender again
logger$remove_appender("json")
 
