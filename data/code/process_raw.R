library(farff)

small_train = farff::readARFF("data_raw/SmallKitchenAppliances_TRAIN.arff")
small_test = farff::readARFF("data_raw/SmallKitchenAppliances_TEST.arff")

large_train = farff::readARFF("data_raw/LargeKitchenAppliances_TRAIN.arff")
large_test = farff::readARFF("data_raw/LargeKitchenAppliances_TEST.arff")


small = rbind(small_train, small_test)
large = rbind(large_train, large_test)

write.csv(small, file = "data/small_kitchen_appliances.csv", row.names = FALSE)
write.csv(large, file = "data/large_kitchen_appliances.csv", row.names = FALSE)
