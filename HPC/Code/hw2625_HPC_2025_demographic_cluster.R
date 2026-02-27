# Clear workspace and graphics device
rm(list = ls())
graphics.off()

# Load required simulation functions
if (file.exists("demographic.R")) {
  source("demographic.R")
} else if (file.exists(file.path("Code", "demographic.R"))) {
  source(file.path("Code", "demographic.R"))
} else {
  stop("demographic.R not found.")
}

# Read array index from cluster
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Local fallback for testing outside cluster
if (is.na(iter)) {
  iter <- 1
}

if (iter < 1 || iter > 100) {
  stop("iter must be between 1 and 100.")
}

set.seed(iter)

state_initialise_adult <- function(num_stages, initial_size) {
  state <- rep(0, num_stages)
  state[num_stages] <- initial_size
  state
}

state_initialise_spread <- function(num_stages, initial_size) {
  state <- rep(floor(initial_size / num_stages), num_stages)
  remainder <- initial_size %% num_stages
  if (remainder > 0) {
    state[1:remainder] <- state[1:remainder] + 1
  }
  state
}

growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0,
                          0.5, 0.4, 0.0, 0.0,
                          0.0, 0.4, 0.7, 0.0,
                          0.0, 0.0, 0.25, 0.4),
                        nrow = 4, ncol = 4, byrow = TRUE)
reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6,
                                0.0, 0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0, 0.0),
                              nrow = 4, ncol = 4, byrow = TRUE)
clutch_distribution <- c(0.06, 0.08, 0.13, 0.15, 0.16, 0.18, 0.15, 0.06, 0.03)

if (iter <= 25) {
  state <- state_initialise_adult(4, 100)
} else if (iter <= 50) {
  state <- state_initialise_adult(4, 10)
} else if (iter <= 75) {
  state <- state_initialise_spread(4, 100)
} else {
  state <- state_initialise_spread(4, 10)
}

results <- vector("list", length = 150)
for (run_i in seq_len(150)) {
  results[[run_i]] <- stochastic_simulation(
    initial_state = state,
    growth_matrix = growth_matrix,
    reproduction_matrix = reproduction_matrix,
    clutch_distribution = clutch_distribution,
    simulation_length = 120
  )
}

output_file <- paste0("demographic_sim_", iter, ".rda")
save(results, file = output_file)
