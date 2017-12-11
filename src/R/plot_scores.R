
require(sf)
require(ggplot2)
require(RColorBrewer)
require(maptools)

map_scores <- function(score_obj,
                       score_var   = score,           
                       scale_label = score_var,         ### character or vector
                       map_title   = 'OHI-Northeast',   ### character or vector
                       rev_col     = FALSE) { 
  ### This function takes a dataframe of scores and applies them to a map of regions.
  ### * 'score_obj' is a data frame with variables rgn_id and one or more score variables.
  ### * score_vars is a vector of column names; tmap will print small
  ###   multiples - one map for each column. Default: "score"
  ### * scale_labels is a vector of scale names; this should either be a single
  ###   name (for all scales) or a vector of same length as score_vars (so each
  ###   map scale gets its own title).  Defaults to the same as score_vars.
  ### * map_titles is similar to scale_labels
  
  poly_land <- ne_states

  poly_rgn <- rgns_simp %>%
    left_join(score_obj, by = 'rgn_id')
  
  score_map <- ggplot(poly_rgn) +
    geom_sf(aes(fill = score_var)) +
    coord_sf(datum = NA) +
    theme_bw() +
    scale_fill_distiller(palette = "RdYlBu", direction = ifelse(rev_col ==T, 1, -1)) +
    labs(title = map_title,
         fill = scale_label)
  
  print(score_map)
  return(invisible(score_map))
  
}