library(mlr3verse)
library(data.table)
library(matrixStats)

ames = data.table(AmesHousing::make_ames())

ts = fread("data/energy_usage.csv")


ts[, `:=`(MIN = rowMins(as.matrix(.SD), na.rm=T),
          MAX = rowMaxs(as.matrix(.SD), na.rm=T),
          AVG = rowMeans(.SD, na.rm=T),
          SUM = rowSums(.SD, na.rm=T))]

ames_ext = cbind(ames, ts[, .(MIN, MAX, AVG, SUM)])

t1 = TaskRegr$new(ames, id = "ames", target = "Sale_Price")
t2 = TaskRegr$new(ames_ext, id = "ames_with_ts_feats", target = "Sale_Price")

r = rsmp("cv")
r$instantiate(t1)

grid = benchmark_grid(list(t1, t2), lrn("regr.ranger"), r)

res = benchmark(grid)

print(res$aggregate(msr("regr.mae")))


learner = lrn("regr.ranger", importance = "permutation")
learner$train(t2)

print(learner$importance())
