library("sleuth")

#paste function
p <- function(., sep='') {
	paste(PUBLIC,.,sep=sep, collapse=sep)
}

# Set up the paths to our kallisto results
PUBLIC <- "~/cse185-final-project-eeelinn/analysis_reads/"

sample_id = c(p("ERR032066_REP1"), p("ERR032066_REP2"), p("ERR032068_REP1"), p("ERR032068_REP2"), p("ERR032071_REP1"), p("ERR032071_REP2"))
kal_dirs = file.path(sample_id)

# load metadata
s2c = read.table(file.path(p("exp_info.txt")), header = TRUE, stringsAsFactors=FALSE)
s2c = dplyr::mutate(s2c, path = kal_dirs)

# create sleuth object
so = sleuth_prep(s2c, extra_bootstrap_summary = TRUE)

# Fit each model and test
so = sleuth_fit(so, ~condition, 'full')
so = sleuth_fit(so, ~1, 'reduced')
so = sleuth_lrt(so, 'reduced', 'full')

# Get output, write results to file
sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)

write.table(sleuth_significant, p("sleuth_results.tab"), sep="\t", quote=FALSE)

#plot a heatmap
plot_sample_heatmap(so, use_filtered = TRUE, color_high = "white", color_low = "dodgerblue", x_axis_angle = 50, annotation_cols = setdiff(colnames(so$s2), "sample"), cluster_bool = TRUE)
