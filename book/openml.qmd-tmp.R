 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#| echo: false
#| output: false
set.seed(1)
options(mlr3oml.cache = "openml/cachedir")

lgr::get_logger("mlr3")$set_threshold(NULL)

if (FALSE) {

}

# Because the OpenML server is occasionally down, we have to use the cached results.
# While the mlr3oml package does support caching, some queries cannot be properly cached (such as listing queries), 
# Because we want the rendering of the book to be stable, we cache them here nonetheless.
# Because we assign it in the namespace, these functions are not only cached in the top-level, but also when 
# they are called internally from other mlr3oml functions, which is what we want.

fns_to_cache = c(
  "list_oml_data",
  "list_oml_tasks"
)

mlr3misc::walk(fns_to_cache, function(fn) mlr3book::assign_cached(fn, "mlr3oml", "opemml"))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
library("mlr3oml")
getwd()
print(1)

odata = odt(43L)
odata
odata$license
odata$qualities["ClassEntropy", value]
 
 
 
 
 
odata$data[1:2, ]
 
 
 
 
 
 
 
backend = as_data_backend(odata)
backend
 
 
 
 
 
 
 
 
 
 
 
 
odatasets = list_oml_data(
  limit = 5, 
  number_features = c(0, 4), 
  number_classes = 2L, 
  number_instances = c(100, 1000)
)

odatasets[, .(data_id, NumberOfFeatures, NumberOfInstances)]
 
 
 
 
 
 
 
 
 
 
otask = otsk(31)
otask
