deterministic_simulation <- function(initial_state, projection_matrix, simulation_length) {
  pop_size <- numeric(simulation_length + 1)
  state <- as.numeric(initial_state)
  pop_size[1] <- sum(state)

  for (i in 1:simulation_length) {
    state <- as.numeric(projection_matrix %*% state)
    pop_size[i + 1] <- sum(state)
  }
  return(pop_size)
}

stochastic_simulation <- function(
  initial_state,
  growth_matrix,
  reproduction_matrix,
  clutch_distribution,
  simulation_length
) {
  state <- as.integer(initial_state)
  n_stages <- length(state)
  pop_size <- numeric(simulation_length + 1)
  pop_size[1] <- sum(state)

  clutch_values <- 0:(length(clutch_distribution) - 1)
  mean_clutch <- sum(clutch_values * clutch_distribution)

  adult_stage <- which.max(reproduction_matrix[1, ])
  expected_births_per_adult <- reproduction_matrix[1, adult_stage]
  if (mean_clutch > 0) {
    p_reproduce <- expected_births_per_adult / mean_clutch
  } else {
    p_reproduce <- 0
  }
  p_reproduce <- max(0, min(1, p_reproduce))

  for (t in 1:simulation_length) {
    next_state <- integer(n_stages)

    for (stage in 1:n_stages) {
      n_individuals <- state[stage]
      if (n_individuals <= 0) {
        next
      }

      transition_probs <- growth_matrix[, stage]
      survival_prob <- sum(transition_probs)
      death_prob <- max(0, 1 - survival_prob)

      transition_counts <- rmultinom(
        n = 1,
        size = n_individuals,
        prob = c(transition_probs, death_prob)
      )
      next_state <- next_state + as.integer(transition_counts[1:n_stages, 1])
    }

    n_adults <- state[adult_stage]
    if (n_adults > 0 && p_reproduce > 0) {
      n_reproducers <- rbinom(1, size = n_adults, prob = p_reproduce)
      if (n_reproducers > 0) {
        births <- sum(sample(
          clutch_values,
          size = n_reproducers,
          replace = TRUE,
          prob = clutch_distribution
        ))
        next_state[1] <- next_state[1] + births
      }
    }

    state <- next_state
    pop_size[t + 1] <- sum(state)
  }

  return(pop_size)
}
