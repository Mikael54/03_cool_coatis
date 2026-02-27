# Username: hw2625

# Source the provided demographic functions
demographic_source_candidates <- c("demographic.R", file.path("Code", "demographic.R"))
for (candidate in demographic_source_candidates) {
  if (file.exists(candidate)) {
    source(candidate)
    break
  }
}

require_demographic_functions <- function() {
  required <- c("deterministic_simulation", "stochastic_simulation")
  missing <- required[!vapply(required, exists, logical(1), mode = "function")]
  if (length(missing) > 0) {
    stop(
      paste(
        "Missing required function(s):",
        paste(missing, collapse = ", "),
        "- ensure the official demographic.R is available."
      )
    )
  }
}

require_ggplot2 <- function() {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plotting functions.")
  }
}

demographic_parameters <- function() {
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
  list(
    growth_matrix = growth_matrix,
    reproduction_matrix = reproduction_matrix,
    clutch_distribution = clutch_distribution,
    projection_matrix = reproduction_matrix + growth_matrix
  )
}

submission_data_dir <- function() {
  if (dir.exists("Data")) {
    return("Data")
  }
  if (dir.exists("data")) {
    return("data")
  }
  return(".")
}

# Section One: Stochastic demographic population model

# Q0: Initialisation functions
state_initialise_adult <- function(num_stages, initial_size){
  state <- rep(0, num_stages)
  state[num_stages] <- initial_size
  return(state)
}

state_initialise_spread <- function(num_stages, initial_size){
  state <- rep(floor(initial_size / num_stages), num_stages)
  remainder <- initial_size %% num_stages
  if (remainder > 0) {
    state[1:remainder] <- state[1:remainder] + 1
  }
  return(state)
}

# Q1: Deterministic simulation
question_1 <- function(){
  require_ggplot2()
  require_demographic_functions()
  params <- demographic_parameters()
  
  # Initial conditions
  state_adult <- state_initialise_adult(4, 100)
  state_spread <- state_initialise_spread(4, 100)
  
  # Run simulations
  sim_adult <- deterministic_simulation(state_adult, params$projection_matrix, 24)
  sim_spread <- deterministic_simulation(state_spread, params$projection_matrix, 24)
  
  # Plotting
  time_steps <- 0:24
  df <- data.frame(
    Time = rep(time_steps, 2),
    Population = c(sim_adult, sim_spread),
    Condition = rep(c("Adults", "Spread"), each=25)
  )
  
  p <- ggplot2::ggplot(df, ggplot2::aes(x = Time, y = Population, color = Condition)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::labs(
      title = "Deterministic Population Size Through Time",
      x = "Time Step (months)",
      y = "Total Population Size",
      color = "Initial condition"
    ) +
    ggplot2::theme_minimal()
  
  ggplot2::ggsave("question_1.png", p, width = 8, height = 5, dpi = 300)
  
  return("Spreading individuals across life stages creates a faster initial increase because some individuals are already in stages that transition quickly into highly reproductive stages. Eventually, both trajectories are governed by the same projection matrix, so the long-term growth pattern becomes similar, but early transient dynamics differ due to the starting age structure.")
}

# Q2: Stochastic simulation
question_2 <- function(){
  require_ggplot2()
  require_demographic_functions()
  params <- demographic_parameters()
  
  state_adult <- state_initialise_adult(4, 100)
  state_spread <- state_initialise_spread(4, 100)
  
  sim_adult <- stochastic_simulation(
    state_adult,
    params$growth_matrix,
    params$reproduction_matrix,
    params$clutch_distribution,
    24
  )
  sim_spread <- stochastic_simulation(
    state_spread,
    params$growth_matrix,
    params$reproduction_matrix,
    params$clutch_distribution,
    24
  )
  
  # Plotting
  time_steps <- 0:24
  df <- data.frame(
    Time = rep(time_steps, 2),
    Population = c(sim_adult, sim_spread),
    Condition = rep(c("Adults", "Spread"), each=25)
  )
  
  p <- ggplot2::ggplot(df, ggplot2::aes(x = Time, y = Population, color = Condition)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::labs(
      title = "Stochastic Population Size Through Time",
      x = "Time Step (months)",
      y = "Total Population Size",
      color = "Initial condition"
    ) +
    ggplot2::theme_minimal()
  
  ggplot2::ggsave("question_2.png", p, width = 8, height = 5, dpi = 300)
  
  return("Compared with the deterministic model, these trajectories are much less smooth because birth and death outcomes are random at each time step. The deterministic model tracks expected values, while the stochastic model includes demographic noise that creates irregular fluctuations, especially when population size is lower.")
}

# Q5: Analyze extinction
question_5 <- function(){
  require_ggplot2()
  extinction_counts <- numeric(4)
  total_sims <- numeric(4)
  
  # Loop through all 100 job files
  for (iter in 1:100) {
    filename <- file.path(submission_data_dir(), paste0("demographic_sim_", iter, ".rda"))
    
    # Only process if file exists (allows local testing with partial data)
    if (file.exists(filename)) {
      run_data <- new.env(parent = emptyenv())
      load(filename, envir = run_data)
      if (!exists("results", envir = run_data)) {
        next
      }
      results <- get("results", envir = run_data)
      
      # Determine condition based on iter
      if (iter <= 25) condition <- 1
      else if (iter <= 50) condition <- 2
      else if (iter <= 75) condition <- 3
      else condition <- 4
      
      total_sims[condition] <- total_sims[condition] + length(results)
      
      # Check for extinction in each simulation (final population size == 0)
      for (sim in results) {
        if (tail(sim, 1) == 0) {
          extinction_counts[condition] <- extinction_counts[condition] + 1
        }
      }
    }
  }
  
  # Calculate proportions (handle division by zero if no files found)
  proportions <- extinction_counts / total_sims
  proportions[is.nan(proportions)] <- 0
  
  conditions <- c("Large Adult", "Small Adult", "Large Spread", "Small Spread")
  
  df <- data.frame(Condition = conditions, ExtinctionRate = proportions, stringsAsFactors = FALSE)
  
  p <- ggplot2::ggplot(df, ggplot2::aes(x = Condition, y = ExtinctionRate)) +
    ggplot2::geom_col(fill = "#2C7FB8") +
    ggplot2::labs(
      title = "Proportion of Extinctions by Initial Condition",
      x = "Initial condition",
      y = "Proportion of simulations ending in extinction"
    ) +
    ggplot2::theme_minimal()
  
  ggplot2::ggsave("question_5.png", p, width = 8, height = 5, dpi = 300)
  
  return("The small initial populations are most likely to go extinct, especially the small spread and small adult cases. This happens because demographic stochasticity has a stronger effect when population size is low, so random runs of poor survival or reproduction are harder to buffer.")
}

# Q6: Deviation from deterministic
question_6 <- function(){
  require_ggplot2()
  require_demographic_functions()
  params <- demographic_parameters()
  
  # Calculate deterministic trends
  state_large_spread <- state_initialise_spread(4, 100)
  state_small_spread <- state_initialise_spread(4, 10)
  det_large <- deterministic_simulation(state_large_spread, params$projection_matrix, 120)
  det_small <- deterministic_simulation(state_small_spread, params$projection_matrix, 120)
  
  # Function to calculate mean stochastic trend for a condition range
  get_mean_stochastic <- function(start_iter, end_iter) {
    sum_trend <- numeric(121) # Length is 120 steps + 1 initial
    count <- 0
    
    for (iter in start_iter:end_iter) {
      filename <- file.path(submission_data_dir(), paste0("demographic_sim_", iter, ".rda"))
      if (file.exists(filename)) {
        run_data <- new.env(parent = emptyenv())
        load(filename, envir = run_data)
        if (!exists("results", envir = run_data)) {
          next
        }
        results <- get("results", envir = run_data)
        for (sim in results) {
          # Ensure sim length matches (handle potential extinctions or length mismatch if any)
          if(length(sim) == 121) {
            sum_trend <- sum_trend + sim
            count <- count + 1
          }
        }
      }
    }
    if (count == 0) return(rep(NA, 121))
    return(sum_trend / count)
  }
  
  # Get stochastic means for Large Spread (51-75) and Small Spread (76-100)
  stoch_large <- get_mean_stochastic(51, 75)
  stoch_small <- get_mean_stochastic(76, 100)
  
  # Calculate deviations (Stochastic / Deterministic)
  # Handle division by zero if deterministic goes to 0 (unlikely here but good practice)
  dev_large <- stoch_large / ifelse(det_large == 0, NA_real_, det_large)
  dev_small <- stoch_small / ifelse(det_small == 0, NA_real_, det_small)
  
  # Prepare data for plotting
  time_steps <- 0:120
  df <- data.frame(
    Time = rep(time_steps, 2),
    Deviation = c(dev_large, dev_small),
    Condition = rep(c("Large Spread", "Small Spread"), each=121)
  )
  
  # Remove NAs if files were missing
  df <- na.omit(df)
  
  if(nrow(df) > 0) {
    p <- ggplot2::ggplot(df, ggplot2::aes(x = Time, y = Deviation, color = Condition)) +
      ggplot2::geom_line(linewidth = 0.9) +
      ggplot2::geom_hline(yintercept = 1, linetype = "dashed", color = "black") +
      ggplot2::facet_wrap(~Condition, ncol = 1) +
      ggplot2::labs(
        title = "Deviation of Mean Stochastic Trend from Deterministic Trend",
        x = "Time Step (months)",
        y = "Stochastic Mean / Deterministic Population"
      ) +
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.position = "none")
    
    ggplot2::ggsave("question_6.png", p, width = 8, height = 7, dpi = 300)
  }
  
  return("The deterministic approximation is more appropriate for the large spread initial condition. With larger populations, random birth and death noise averages out more strongly, so the mean stochastic trajectory stays closer to the deterministic expectation.")
}

# Section Two: Individual-based ecological neutral theory simulation

# Q7: Species richness
species_richness <- function(community){
  return(length(unique(community)))
}

# Q8: Init max
init_community_max <- function(size){
  return(seq(1, size))
}

# Q9: Init min
init_community_min <- function(size){
  return(rep(1, size))
}

# Q10: Choose two
choose_two <- function(max_value){
  return(sample(1:max_value, 2, replace=FALSE))
}

# Q11: Neutral step
neutral_step <- function(community){
  indices <- choose_two(length(community))
  die_idx <- indices[1]
  reproduce_idx <- indices[2]
  community[die_idx] <- community[reproduce_idx]
  return(community)
}

# Q12: Neutral generation
neutral_generation <- function(community){
  raw_steps <- length(community) / 2
  if (raw_steps %% 1 == 0) {
    steps <- as.integer(raw_steps)
  } else if (runif(1) < 0.5) {
    steps <- floor(raw_steps)
  } else {
    steps <- ceiling(raw_steps)
  }
  for (i in 1:steps){
    community <- neutral_step(community)
  }
  return(community)
}

# Q13: Neutral time series
neutral_time_series <- function(community, duration){
  richness <- numeric(duration + 1)
  richness[1] <- species_richness(community)
  for (i in 1:duration){
    community <- neutral_generation(community)
    richness[i+1] <- species_richness(community)
  }
  return(richness)
}

# Q14: Plot time series
question_14 <- function(){
  require_ggplot2()
  comm <- init_community_max(100)
  ts <- neutral_time_series(comm, 200)
  
  df <- data.frame(Generation=0:200, Richness=ts)
  p <- ggplot2::ggplot(df, ggplot2::aes(x = Generation, y = Richness)) +
    ggplot2::geom_line(linewidth = 1, color = "#1B7837") +
    ggplot2::labs(
      title = "Neutral Model (No Speciation): Species Richness Through Time",
      x = "Generation",
      y = "Species Richness"
    ) +
    ggplot2::theme_minimal()
  
  ggplot2::ggsave("question_14.png", p, width = 8, height = 5, dpi = 300)
  return("What state will the system always converge to...: It converges to monodominance (1 species) because without speciation, random drift eventually eliminates all diversity.")
}

# Q15: Neutral step with speciation
neutral_step_speciation <- function(community, speciation_rate){
  indices <- choose_two(length(community))
  die_idx <- indices[1]
  reproduce_idx <- indices[2]
  
  if (runif(1) < speciation_rate){
    # Speciation: new unique species
    new_species <- max(community) + 1
    while(new_species %in% community) new_species <- new_species + 1
    community[die_idx] <- new_species
  } else {
    # Reproduction
    community[die_idx] <- community[reproduce_idx]
  }
  return(community)
}

# Q16: Neutral generation with speciation
neutral_generation_speciation <- function(community, speciation_rate){
  raw_steps <- length(community) / 2
  if (raw_steps %% 1 == 0) {
    steps <- as.integer(raw_steps)
  } else if (runif(1) < 0.5) {
    steps <- floor(raw_steps)
  } else {
    steps <- ceiling(raw_steps)
  }
  for (i in 1:steps){
    community <- neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}

# Q17: Time series with speciation
neutral_time_series_speciation <- function(community, duration, speciation_rate){
  richness <- numeric(duration + 1)
  richness[1] <- species_richness(community)
  for (i in 1:duration){
    community <- neutral_generation_speciation(community, speciation_rate)
    richness[i+1] <- species_richness(community)
  }
  return(richness)
}

# Q18: Plot speciation effect
question_18 <- function(){
  require_ggplot2()
  comm_max <- init_community_max(100)
  comm_min <- init_community_min(100)
  ts_max <- neutral_time_series_speciation(comm_max, duration = 200, speciation_rate = 0.1)
  ts_min <- neutral_time_series_speciation(comm_min, duration = 200, speciation_rate = 0.1)
  
  df <- data.frame(
    Generation = rep(0:200, 2),
    Richness = c(ts_max, ts_min),
    Initial = rep(c("Max", "Min"), each=201)
  )
  
  p <- ggplot2::ggplot(df, ggplot2::aes(x = Generation, y = Richness, color = Initial)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::labs(
      title = "Neutral Model with Speciation",
      x = "Generation",
      y = "Species Richness",
      color = "Initial condition"
    ) +
    ggplot2::theme_minimal()
  
  ggplot2::ggsave("question_18.png", p, width = 8, height = 5, dpi = 300)
  return("Explain what you found...: Both initial conditions converge towards a dynamic equilibrium of species richness determined by the balance between speciation and extinction (drift).")
}

# Q19: Species abundance
species_abundance <- function(community){
  counts <- as.numeric(table(community))
  return(sort(counts, decreasing=TRUE))
}

# Q20: Octaves
octaves <- function(abundance_vector){
  # Bin abundances into octaves: 1, 2-3, 4-7, 8-15, etc.
  # Log2 bins: floor(log2(n))
  # 1 -> 0 -> bin 1
  # 2 -> 1 -> bin 2
  # 3 -> 1 -> bin 2
  # 4 -> 2 -> bin 3
  return(tabulate(floor(log2(abundance_vector)) + 1))
}

# Q21: Sum vectors
sum_vect <- function(x, y){
  len <- max(length(x), length(y))
  if (length(x) < len) x <- c(x, rep(0, len - length(x)))
  if (length(y) < len) y <- c(y, rep(0, len - length(y)))
  return(x + y)
}

# Q22: Octave plots
question_22 <- function(){
  speciation_rate <- 0.1
  size <- 100
  burn_in <- 200
  duration <- 2000
  record_interval <- 20
  
  # Function to run simulation and collect mean octaves
  run_and_record <- function(init_func) {
    community <- init_func(size)
    
    # Burn-in
    for(i in 1:burn_in) {
      community <- neutral_generation_speciation(community, speciation_rate)
    }
    
    total_octaves <- octaves(species_abundance(community))
    count <- 1
    
    # Recording phase
    for(i in 1:duration) {
      community <- neutral_generation_speciation(community, speciation_rate)
      if(i %% record_interval == 0) {
        oct <- octaves(species_abundance(community))
        total_octaves <- sum_vect(total_octaves, oct)
        count <- count + 1
      }
    }
    return(total_octaves / count)
  }
  
  mean_oct_max <- run_and_record(init_community_max)
  mean_oct_min <- run_and_record(init_community_min)
  
  # Plotting (two-panel base R graph)
  png("question_22.png", width=800, height=400)
  par(mfrow=c(1,2))
  barplot(mean_oct_max, main="Initial: Max Diversity", xlab="Octave", ylab="Mean Count")
  barplot(mean_oct_min, main="Initial: Min Diversity", xlab="Octave", ylab="Mean Count")
  dev.off()
  
  return("Does the initial condition matter?: No, after the burn-in period, the system reaches a dynamic equilibrium where the species abundance distribution is independent of the starting state.")
}

# Q23: Cluster run function
neutral_cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name){
  
  community <- init_community_min(size)
  time_series <- numeric()
  abundance_list <- list()
  
  start_time <- proc.time()[3]
  generation <- 0
  
  while(TRUE){
    # Check time limit (convert minutes to seconds)
    elapsed <- (proc.time()[3] - start_time) / 60
    if (elapsed >= wall_time) break
    
    community <- neutral_generation_speciation(community, speciation_rate)
    generation <- generation + 1
    
    # Burn-in phase
    if (generation <= burn_in_generations){
      if (generation %% interval_rich == 0){
        time_series <- c(time_series, species_richness(community))
      }
    }
    
    # Recording phase
    if (generation %% interval_oct == 0){
      abundance_list[[length(abundance_list) + 1]] <- octaves(species_abundance(community))
    }
  }
  
  total_time <- (proc.time()[3] - start_time) / 60
  save(time_series, abundance_list, community, total_time, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, file=output_file_name)
}

# Q26: Process results
process_neutral_cluster_results <- function(){
  combined_results <- list()
  sizes <- c(500, 1000, 2500, 5000)
  
  # Loop through each size category
  for (i in 1:4) {
    size <- sizes[i]
    # Determine iter range for this size
    start_iter <- (i - 1) * 25 + 1
    end_iter <- i * 25
    
    total_octaves <- numeric()
    count <- 0
    
    for (iter in start_iter:end_iter) {
      filename <- file.path(submission_data_dir(), paste0("neutral_sim_", iter, ".rda"))
      if (file.exists(filename)) {
        run_data <- new.env(parent = emptyenv())
        load(filename, envir = run_data)

        if (exists("abundance_list", envir = run_data) &&
            exists("interval_oct", envir = run_data) &&
            exists("burn_in_generations", envir = run_data)) {
          abundance_list <- get("abundance_list", envir = run_data)
          interval_oct <- get("interval_oct", envir = run_data)
          burn_in_generations <- get("burn_in_generations", envir = run_data)

          # Record k corresponds to generation k * interval_oct.
          # Keep only post-burn-in abundance data.
          post_burn_in_idx <- which((seq_along(abundance_list) * interval_oct) > burn_in_generations)

          for (idx in post_burn_in_idx) {
            total_octaves <- sum_vect(total_octaves, abundance_list[[idx]])
            count <- count + 1
          }
        }
      }
    }
    
    # Calculate mean
    if (count > 0) {
      combined_results[[i]] <- total_octaves / count
    } else {
      combined_results[[i]] <- numeric()
    }
  }
  
  summary_file <- file.path(submission_data_dir(), "neutral_cluster_summary.rda")
  save(combined_results, file = summary_file)
  return(combined_results)
}

plot_neutral_cluster_results <- function(){
  summary_file <- file.path(submission_data_dir(), "neutral_cluster_summary.rda")
  if(file.exists(summary_file)) {
    load(summary_file)
    
    png("plot_neutral_cluster_results.png", width=1000, height=800)
    par(mfrow=c(2,2))
    sizes <- c(500, 1000, 2500, 5000)
    
    for (i in 1:4) {
      if (length(combined_results[[i]]) > 0) {
        barplot(combined_results[[i]], 
                main=paste("Community Size =", sizes[i]),
                xlab="Octave Class", 
                ylab="Mean Species Count",
                names.arg=1:length(combined_results[[i]]))
      } else {
        plot.new()
        text(0.5, 0.5, "No Data")
      }
    }
    dev.off()
    names(combined_results) <- c("size_500", "size_1000", "size_2500", "size_5000")
    return(combined_results)
  } else {
    stop("Data/neutral_cluster_summary.rda not found. Run process_neutral_cluster_results first.")
  }
}

# Challenge Questions

.demographic_condition_label <- function(iter) {
  if (iter <= 25) {
    return("large adult")
  }
  if (iter <= 50) {
    return("small adult")
  }
  if (iter <= 75) {
    return("large mixed")
  }
  return("small mixed")
}

.neutral_size_from_iter <- function(iter) {
  if (iter <= 25) {
    return(500)
  }
  if (iter <= 50) {
    return(1000)
  }
  if (iter <= 75) {
    return(2500)
  }
  return(5000)
}

Challenge_A <- function() {
  require_ggplot2()

  df_list <- vector("list", 100 * 150)
  df_idx <- 1
  simulation_counter <- 1

  for (iter in 1:100) {
    file_name <- file.path(submission_data_dir(), paste0("demographic_sim_", iter, ".rda"))
    if (!file.exists(file_name)) {
      next
    }

    run_data <- new.env(parent = emptyenv())
    load(file_name, envir = run_data)
    if (!exists("results", envir = run_data)) {
      next
    }

    results <- get("results", envir = run_data)
    condition_label <- .demographic_condition_label(iter)

    for (sim_i in seq_along(results)) {
      population_vector <- as.numeric(results[[sim_i]])
      time_vector <- 0:(length(population_vector) - 1)
      df_list[[df_idx]] <- data.frame(
        simulation_number = simulation_counter,
        initial_condition = condition_label,
        initial_state = condition_label,
        time_step = time_vector,
        population_size = population_vector,
        stringsAsFactors = FALSE
      )
      df_idx <- df_idx + 1
      simulation_counter <- simulation_counter + 1
    }
  }

  if (df_idx == 1) {
    stop("No Data/demographic_sim_*.rda files were found.")
  }

  population_size_df <- do.call(rbind, df_list[seq_len(df_idx - 1)])

  p <- ggplot2::ggplot(
    population_size_df,
    ggplot2::aes(
      x = time_step,
      y = population_size,
      group = simulation_number,
      colour = initial_state
    )
  ) +
    ggplot2::geom_line(alpha = 0.1, linewidth = 0.25) +
    ggplot2::labs(
      title = "Challenge A: All Stochastic Population Time Series",
      x = "Time Step",
      y = "Population Size",
      colour = "Initial condition"
    ) +
    ggplot2::theme_minimal()

  ggplot2::ggsave("Challenge_A.png", p, width = 10, height = 6, dpi = 300)
  return(population_size_df)
}

Challenge_B <- function() {
  require_ggplot2()

  speciation_rate <- 0.1
  size <- 100
  duration <- 2200
  n_repeats <- 80
  alpha <- 0.028

  run_replicates <- function(init_fun) {
    out <- matrix(NA_real_, nrow = n_repeats, ncol = duration + 1)
    for (rep_i in seq_len(n_repeats)) {
      community <- init_fun(size)
      out[rep_i, ] <- neutral_time_series_speciation(
        community = community,
        duration = duration,
        speciation_rate = speciation_rate
      )
    }
    out
  }

  summarise_richness <- function(mat, condition_label) {
    richness_mean <- colMeans(mat)
    richness_sd <- apply(mat, 2, stats::sd)
    t_mult <- stats::qt(1 - alpha / 2, df = nrow(mat) - 1)
    se <- richness_sd / sqrt(nrow(mat))
    data.frame(
      time_step = 0:duration,
      mean_richness = richness_mean,
      lower = richness_mean - t_mult * se,
      upper = richness_mean + t_mult * se,
      condition = condition_label,
      stringsAsFactors = FALSE
    )
  }

  estimate_equilibrium <- function(mean_max, mean_min) {
    n <- length(mean_max)
    window <- min(100, n)
    start_generation <- 200
    start_idx <- min(start_generation + 1, n - window + 1)
    final_target_max <- mean(tail(mean_max, window))
    final_target_min <- mean(tail(mean_min, window))
    tol_max <- max(0.5, 0.05 * final_target_max)
    tol_min <- max(0.5, 0.05 * final_target_min)

    if (start_idx > (n - window + 1)) {
      return(NA_integer_)
    }

    for (idx in start_idx:(n - window + 1)) {
      rng <- idx:(idx + window - 1)
      if (
        all(abs(mean_max[rng] - final_target_max) <= tol_max) &&
        all(abs(mean_min[rng] - final_target_min) <= tol_min)
      ) {
        return(idx - 1)
      }
    }
    return(NA_integer_)
  }

  richness_max <- run_replicates(init_community_max)
  richness_min <- run_replicates(init_community_min)

  summary_max <- summarise_richness(richness_max, "maximum initial richness")
  summary_min <- summarise_richness(richness_min, "minimum initial richness")
  summary_df <- rbind(summary_max, summary_min)

  p <- ggplot2::ggplot(summary_df, ggplot2::aes(x = time_step, y = mean_richness, colour = condition, fill = condition)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lower, ymax = upper), alpha = 0.2, colour = NA) +
    ggplot2::geom_line(linewidth = 0.9) +
    ggplot2::labs(
      title = "Challenge B: Mean Species Richness with 97.2% Confidence Interval",
      x = "Generation",
      y = "Species Richness",
      colour = "Initial condition",
      fill = "Initial condition"
    ) +
    ggplot2::theme_minimal()

  ggplot2::ggsave("Challenge_B.png", p, width = 10, height = 6, dpi = 300)

  eq_generation <- estimate_equilibrium(summary_max$mean_richness, summary_min$mean_richness)
  if (is.na(eq_generation)) {
    return("Based on these repeat simulations, dynamic equilibrium was not clearly reached within the simulated time horizon.")
  }
  return(paste("Based on the mean trajectories and their stabilization, the system reaches dynamic equilibrium at approximately generation", eq_generation, "."))
}

Challenge_C <- function() {
  require_ggplot2()

  speciation_rate <- 0.1
  size <- 100
  duration <- 400
  n_repeats <- 30
  initial_richness_values <- sort(unique(c(1, seq(10, 100, by = 10), 25, 50, 75)))

  random_initial_community <- function(size, richness) {
    sample.int(richness, size = size, replace = TRUE)
  }

  all_series <- vector("list", length(initial_richness_values))
  list_idx <- 1

  for (k in initial_richness_values) {
    richness_mat <- matrix(NA_real_, nrow = n_repeats, ncol = duration + 1)
    for (rep_i in seq_len(n_repeats)) {
      community <- random_initial_community(size = size, richness = k)
      richness_mat[rep_i, ] <- neutral_time_series_speciation(
        community = community,
        duration = duration,
        speciation_rate = speciation_rate
      )
    }

    all_series[[list_idx]] <- data.frame(
      generation = 0:duration,
      mean_richness = colMeans(richness_mat),
      initial_richness = k,
      stringsAsFactors = FALSE
    )
    list_idx <- list_idx + 1
  }

  challenge_c_df <- do.call(rbind, all_series)

  p <- ggplot2::ggplot(
    challenge_c_df,
    ggplot2::aes(
      x = generation,
      y = mean_richness,
      group = initial_richness,
      colour = initial_richness
    )
  ) +
    ggplot2::geom_line(alpha = 0.9, linewidth = 0.7) +
    ggplot2::scale_colour_gradient(low = "#2C7BB6", high = "#D7191C") +
    ggplot2::labs(
      title = "Challenge C: Averaged Richness Time Series Across Initial Richness Values",
      x = "Generation",
      y = "Mean Species Richness",
      colour = "Initial\nrichness"
    ) +
    ggplot2::theme_minimal()

  ggplot2::ggsave("Challenge_C.png", p, width = 10, height = 6, dpi = 300)
  return(challenge_c_df)
}

Challenge_D <- function() {
  require_ggplot2()

  rows <- vector("list", 100)
  row_idx <- 1

  for (iter in 1:100) {
    file_name <- file.path(submission_data_dir(), paste0("neutral_sim_", iter, ".rda"))
    if (!file.exists(file_name)) {
      next
    }

    run_data <- new.env(parent = emptyenv())
    load(file_name, envir = run_data)
    if (!exists("time_series", envir = run_data)) {
      next
    }

    interval_rich <- 1
    if (exists("interval_rich", envir = run_data)) {
      interval_rich <- get("interval_rich", envir = run_data)
    }
    ts <- as.numeric(get("time_series", envir = run_data))
    if (length(ts) == 0) {
      next
    }

    rows[[row_idx]] <- data.frame(
      size = .neutral_size_from_iter(iter),
      generation = seq_along(ts) * interval_rich,
      richness = ts,
      run_id = iter,
      stringsAsFactors = FALSE
    )
    row_idx <- row_idx + 1
  }

  if (row_idx == 1) {
    stop("No Data/neutral_sim_*.rda files with time_series were found.")
  }

  richness_df <- do.call(rbind, rows[seq_len(row_idx - 1)])
  summary_df <- stats::aggregate(richness ~ size + generation, data = richness_df, FUN = mean)

  estimate_burnin <- function(generation, mean_richness) {
    n <- length(mean_richness)
    window <- min(50, n)
    final_window <- min(100, n)
    final_target <- mean(tail(mean_richness, final_window))
    tolerance <- max(0.5, 0.03 * final_target)

    if (window > n) {
      return(max(generation))
    }

    for (idx in 1:(n - window + 1)) {
      rng <- idx:(idx + window - 1)
      if (all(abs(mean_richness[rng] - final_target) <= tolerance)) {
        return(generation[idx])
      }
    }
    return(max(generation))
  }

  burnin_rows <- vector("list", length(unique(summary_df$size)))
  burn_idx <- 1
  for (size_value in sort(unique(summary_df$size))) {
    sub <- summary_df[summary_df$size == size_value, ]
    sub <- sub[order(sub$generation), ]
    burnin_rows[[burn_idx]] <- data.frame(
      size = size_value,
      recommended_burnin = estimate_burnin(sub$generation, sub$richness),
      stringsAsFactors = FALSE
    )
    burn_idx <- burn_idx + 1
  }
  burnin_df <- do.call(rbind, burnin_rows)

  p <- ggplot2::ggplot(summary_df, ggplot2::aes(x = generation, y = richness)) +
    ggplot2::geom_line(colour = "#2C7FB8", linewidth = 0.8) +
    ggplot2::geom_vline(
      data = burnin_df,
      ggplot2::aes(xintercept = recommended_burnin),
      linetype = "dashed",
      colour = "#D95F0E",
      linewidth = 0.7,
      inherit.aes = FALSE
    ) +
    ggplot2::facet_wrap(~size, scales = "free_x", ncol = 2) +
    ggplot2::labs(
      title = "Challenge D: Mean Burn-in Richness Trajectory by Community Size",
      x = "Generation",
      y = "Mean Species Richness"
    ) +
    ggplot2::theme_minimal()

  ggplot2::ggsave("Challenge_D.png", p, width = 10, height = 7, dpi = 300)

  burnin_text <- paste(paste0("size ", burnin_df$size, ": ~", burnin_df$recommended_burnin, " generations"), collapse = "; ")
  return(paste("Estimated burn-in requirements from the mean trajectories are:", burnin_text))
}

Challenge_E <- function() {
  require_ggplot2()

  infer_speciation_rate <- function(default_value = 0.002195) {
    for (iter in 1:100) {
      file_name <- file.path(submission_data_dir(), paste0("neutral_sim_", iter, ".rda"))
      if (!file.exists(file_name)) {
        next
      }
      run_data <- new.env(parent = emptyenv())
      load(file_name, envir = run_data)
      if (exists("speciation_rate", envir = run_data)) {
        return(as.numeric(get("speciation_rate", envir = run_data)))
      }
    }
    return(default_value)
  }

  coalescence_abundance <- function(size, speciation_rate) {
    lineages <- rep(1L, size)
    abundances <- integer(0)
    n_lineages <- size
    theta <- speciation_rate * ((size - 1) / (1 - speciation_rate))

    while (n_lineages > 1) {
      j <- sample.int(n_lineages, 1)
      rand_num <- runif(1)

      if (rand_num < (theta / (theta + n_lineages - 1))) {
        abundances <- c(abundances, lineages[j])
      } else {
        i <- sample.int(n_lineages - 1, 1)
        if (i >= j) {
          i <- i + 1
        }
        lineages[i] <- lineages[i] + lineages[j]
      }

      lineages <- lineages[-j]
      n_lineages <- n_lineages - 1
    }

    abundances <- c(abundances, lineages[1])
    abundances
  }

  cluster_means <- process_neutral_cluster_results()
  sizes <- c(500, 1000, 2500, 5000)
  speciation_rate <- infer_speciation_rate()
  n_repeats <- 25

  start_time <- proc.time()[3]
  coalescence_means <- vector("list", length(sizes))
  for (i in seq_along(sizes)) {
    octave_sum <- numeric()
    for (rep_i in seq_len(n_repeats)) {
      abundances <- coalescence_abundance(sizes[i], speciation_rate)
      octave_vector <- octaves(sort(abundances, decreasing = TRUE))
      octave_sum <- sum_vect(octave_sum, octave_vector)
    }
    coalescence_means[[i]] <- octave_sum / n_repeats
  }
  coalescence_cpu_hours <- (proc.time()[3] - start_time) / 3600

  total_cluster_minutes <- 0
  cluster_files_used <- 0
  for (iter in 1:100) {
    file_name <- file.path(submission_data_dir(), paste0("neutral_sim_", iter, ".rda"))
    if (!file.exists(file_name)) {
      next
    }
    run_data <- new.env(parent = emptyenv())
    load(file_name, envir = run_data)
    if (exists("total_time", envir = run_data)) {
      total_cluster_minutes <- total_cluster_minutes + as.numeric(get("total_time", envir = run_data))
      cluster_files_used <- cluster_files_used + 1
    }
  }
  cluster_cpu_hours <- total_cluster_minutes / 60

  compare_rows <- list()
  cmp_idx <- 1
  rmse_values <- numeric(length(sizes))

  for (i in seq_along(sizes)) {
    cluster_vec <- cluster_means[[i]]
    coal_vec <- coalescence_means[[i]]
    max_len <- max(length(cluster_vec), length(coal_vec))
    if (max_len == 0) {
      rmse_values[i] <- NA_real_
      next
    }

    cluster_pad <- c(cluster_vec, rep(0, max_len - length(cluster_vec)))
    coal_pad <- c(coal_vec, rep(0, max_len - length(coal_vec)))
    rmse_values[i] <- sqrt(mean((cluster_pad - coal_pad)^2))

    compare_rows[[cmp_idx]] <- data.frame(
      size = sizes[i],
      octave = seq_len(max_len),
      mean_count = cluster_pad,
      method = "cluster",
      stringsAsFactors = FALSE
    )
    cmp_idx <- cmp_idx + 1

    compare_rows[[cmp_idx]] <- data.frame(
      size = sizes[i],
      octave = seq_len(max_len),
      mean_count = coal_pad,
      method = "coalescence",
      stringsAsFactors = FALSE
    )
    cmp_idx <- cmp_idx + 1
  }

  compare_df <- do.call(rbind, compare_rows)

  p <- ggplot2::ggplot(compare_df, ggplot2::aes(x = octave, y = mean_count, fill = method)) +
    ggplot2::geom_col(position = "dodge") +
    ggplot2::facet_wrap(~size, scales = "free_y", ncol = 2) +
    ggplot2::labs(
      title = "Challenge E: Cluster vs Coalescence Mean Octave Distributions",
      x = "Octave Class",
      y = "Mean Species Count",
      fill = "Method"
    ) +
    ggplot2::theme_minimal()

  ggplot2::ggsave("Challenge_E.png", p, width = 10, height = 7, dpi = 300)

  mean_rmse <- mean(rmse_values, na.rm = TRUE)
  return(
    paste(
      "Coalescence used approximately", round(coalescence_cpu_hours, 3), "CPU hours for the equivalent replicate set.",
      "The cluster outputs indicate approximately", round(cluster_cpu_hours, 3), "CPU hours across", cluster_files_used, "jobs.",
      "Agreement between methods is good when octave RMSE is small; here the mean RMSE was", round(mean_rmse, 3), ".",
      "Coalescence is faster because it works backwards through lineage-merging events instead of simulating every forward-time birth and death event."
    )
  )
}
