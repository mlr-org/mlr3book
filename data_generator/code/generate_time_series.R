library(data.table)

ames = data.table(AmesHousing::make_ames())

weight = (ames$Sale_Price - min(ames$Sale_Price)) / (max(ames$Sale_Price) - min(ames$Sale_Price))

data = data.table(
    n_large = round(weight * 3 + 1),
    n_small = round(weight * 6 + 1)
)

small = fread("data/small_kitchen_appliances.csv")
large = fread("data/large_kitchen_appliances.csv")

small[ , target := NULL]
large[ , target := NULL]


series = lapply(1:nrow(data), function(x) {
    colSums(small[sample(.N, data[x]$n_small)]) +
    colSums(large[sample(.N, data[x]$n_large)])
})

series_dt = abs(do.call(rbind, series))

fwrite(series_dt, file = "data/energy_usage.csv")
