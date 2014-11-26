#' Locate the position of the first occurence of a pattern in a string.
#'
#' Vectorised over \code{string} and \code{pattern}, shorter is recycled to
#' same length as longest.
#'
#' @inheritParams str_detect
#' @return integer matrix.  First column gives start postion of match, and
#'   second column gives end position.
#' @keywords character
#' @seealso
#'   \code{\link{regexpr}} which this function wraps
#'
#'   \code{\link{str_extract}} for a convenient way of extracting matches
#
#'   \code{\link{str_locate_all}} to locate position of all matches
#'
#' @export
#' @examples
#' fruit <- c("apple", "banana", "pear", "pinapple")
#' str_locate(fruit, "$")
#' str_locate(fruit, "a")
#' str_locate(fruit, "e")
#' str_locate(fruit, c("a", "b", "p", "p"))
str_locate <- function(string, pattern) {
  switch(type(pattern),
    fixed = stri_locate_first_fixed(string, pattern),
    regex = stri_locate_first_regex(string, pattern, attr(pattern, "options")),
    coll  = stri_locate_first_coll(string, pattern, attr(pattern, "options"))
  )
}

#' Locate the position of all occurences of a pattern in a string.
#'
#' Vectorised over \code{string} and \code{pattern}, shorter is recycled to
#' same length as longest.
#'
#' If the match is of length 0, (e.g. from a special match like \code{$})
#' end will be one character less than start.
#'
#' @inheritParams str_detect
#' @keywords character
#' @return list of integer matrices.  First column gives start postion of
#'   match, and second column gives end position.
#' @seealso
#'  \code{\link{regexpr}} which this function wraps
#'
#'  \code{\link{str_extract}} for a convenient way of extracting matches
#'
#'  \code{\link{str_locate}} to locate position of first match
#'
#' @export
#' @examples
#' fruit <- c("apple", "banana", "pear", "pineapple")
#' str_locate_all(fruit, "a")
#' str_locate_all(fruit, "e")
#' str_locate_all(fruit, c("a", "b", "p", "p"))
#'
#' # Find location of every character
#' str_locate_all(fruit, "")
str_locate_all <- function(string, pattern) {
  switch(type(pattern),
    empty = stri_locate_boundaries(string, stri_opts_brkiter("character")),
    fixed = stri_locate_all_fixed(string, pattern),
    regex = stri_locate_all_regex(string, pattern, attr(pattern, "options")),
    coll  = stri_locate_all_coll(string, pattern, attr(pattern, "options"))
  )
}


#' Switch location of matches to location of non-matches.
#'
#' Invert a matrix of match locations to match the opposite of what was
#' previously matched.
#'
#' @param loc matrix of match locations, as from \code{\link{str_locate_all}}
#' @return numeric match giving locations of non-matches
#' @export
#' @examples
#' numbers <- "1 and 2 and 4 and 456"
#' num_loc <- str_locate_all(numbers, "[0-9]+")[[1]]
#' str_sub(numbers, num_loc[, "start"], num_loc[, "end"])
#'
#' text_loc <- invert_match(num_loc)
#' str_sub(numbers, text_loc[, "start"], text_loc[, "end"])
invert_match <- function(loc) {
  cbind(
    start = c(0L, loc[, "end"] + 1L),
    end = c(loc[, "start"] - 1L, -1L)
  )
}
