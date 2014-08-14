#' @title Normalize features
#'
#' @description
#' Normalize features by different methods. Internally \code{\link{normalize}} is used.
#' Non numerical features will be left untouched and passed to the result.
#'
#' @param obj [\code{data.frame} | \code{\link{Task}}]\cr
#'   Input data.
#' @param target [\code{character(1)}]\cr
#'   Name of the column(s) specifying the response.
#'   Only used when \code{obj} is a data.frame, otherwise ignored.
#' @param method [\code{character(1)}]\cr
#'   Normalizing method.\cr
#'   Available are:\cr
#'   \dQuote{center}: centering of each feature\cr
#'   \dQuote{scale}: scaling of each feature\cr
#'   \dQuote{standardize}: centering and scaling\cr
#'   \dQuote{range}: Scale the data to a given range.\cr
#' @template arg_exclude
#' @param range [\code{numeric(2)}]\cr
#'   Range the features should be scaled to. Default is \code{c(0,1)}.
#' @return [\code{data.frame} | \code{\link{Task}}]. Same type as \code{obj}.
#' @seealso \code{\link{normalize}}
#' @export

normalizeFeatures = function(obj, target = character(0L), method = "standardize", exclude = character(0L), range = c(0,1)) {
  assertChoice(method, choices = c("range", "standardize", "center", "scale"))
  assertCharacter(target)
  assertCharacter(exclude)
  UseMethod("normalizeFeatures")
}

#' @export
normalizeFeatures.data.frame = function(obj, target = character(0L), method = "standardize", exclude = character(0L), range = c(0,1)) {
  # extract obj to work on
  work.cols = colnames(obj)[sapply(obj, is.numeric)]
  work.cols = setdiff(work.cols, exclude)
  work.cols = setdiff(work.cols, target)
  work.obj = obj[,work.cols]

  work.obj = normalize(x = obj, method = method, range = range)

  # bring back work.obj into obj
  obj[,work.cols] = work.obj
  obj
}

#' @export
normalizeFeatures.Task = function(obj, target = character(0L), method = "standardize", exclude = character(0L), range = c(0,1)) {
  d = normalizeFeatures(obj = getTaskData(obj), target = obj$task.desc$target, method = method, exclude = exclude, range = range)
  changeData(obj, d)
}