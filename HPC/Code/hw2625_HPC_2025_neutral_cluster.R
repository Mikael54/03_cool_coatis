# Clear workspace and graphics device
rm(list = ls())
graphics.off()

# Load all required functions
if (file.exists("hw2625_HPC_2025_main.R")) {
  source("hw2625_HPC_2025_main.R")
} else if (file.exists(file.path("Code", "hw2625_HPC_2025_main.R"))) {
  source(file.path("Code", "hw2625_HPC_2025_main.R"))
} else {
  stop("hw2625_HPC_2025_main.R not found.")
}

# Read array index from cluster
cluster_iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
is_cluster <- !is.na(cluster_iter)
iter <- cluster_iter

# Local fallback for testing outside cluster
if (is.na(iter)) {
  iter <- 1
}

if (iter < 1 || iter > 100) {
  stop("iter must be between 1 and 100.")
}

set.seed(iter)

if (iter <= 25) {
  size <- 500
} else if (iter <= 50) {
  size <- 1000
} else if (iter <= 75) {
  size <- 2500
} else {
  size <- 5000
}

# Replace with your assigned personal value if different.
speciation_rate <- 0.002195
output_filename <- paste0("neutral_sim_", iter, ".rda")

neutral_cluster_run(
  speciation_rate = speciation_rate,
  size = size,
  wall_time = if (is_cluster) 690 else 1,  # 11.5h on cluster, 1 min local test
  interval_rich = 1,
  interval_oct = size / 10,
  burn_in_generations = 8 * size,
  output_file_name = output_filename
)
