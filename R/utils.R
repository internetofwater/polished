#' remove_query_string
#'
#' Remove the entire query string
#'
#' @param session the Shiny session
#'
#' @importFrom shiny updateQueryString getDefaultReactiveDomain
#'
remove_query_string <- function(session = shiny::getDefaultReactiveDomain()) {

  shiny::updateQueryString(
    session$clientData$url_pathname,
    mode = "replace",
    session = session
  )
}

# Remove the jwt from the query string
#' @importFrom shiny updateQueryString getQueryString getDefaultReactiveDomain
remove_query_jwt <- function(session = getDefaultReactiveDomain()) {
  query <- shiny::getQueryString(session = session)
  query$jwt <- NULL
  if (length(query) == 0) {
    remove_query_string(session = session)
  } else {
    query <- paste(names(query), query, sep = "=", collapse="&")
    shiny::updateQueryString(
      queryString = paste0("?", query),
      mode = "replace",
      session = session
    )
  }
}

#' get_cookie
#'
#' Get a cookie value by name from a cookie string
#'
#' @param cookie_string the cookie string
#' @param name the name of the cookie
#'
#' @importFrom dplyr filter pull %>%
#' @importFrom tidyr separate
#' @importFrom tibble tibble
#'
#' @export
#'
#' @examples
#' cookies <- "cookie_name=cookie-value; cookie_name_2=cookie-value-2; cookie_name_3=cookie-with=sign"
#'
#' get_cookie(cookies, "cookie_name")
#' get_cookie(cookies, "cookie_name_2")
#' get_cookie(cookies, "cookie_name_3")
#'
get_cookie <- function(cookie_string, name) {

  cookies <- strsplit(cookie_string , split = "; ", fixed = TRUE)

  tibble::tibble(cookie = unlist(cookies)) %>%
    tidyr::separate(.data$cookie, into = c("key", "value"), sep = "=", extra = "merge") %>%
    dplyr::filter(.data$key == name) %>%
    dplyr::pull("value")
}


#' convert_timestamp
#'
#' convert a Javascript JSON UTC date to a time in R.  We generally convert
#' Firestore timestamps to JSON UTC dates before we send them to R.
#'
#' @param timestamp the JSON UTC date(s)
#' @param tz the timezone to convert the returned datetime to
#'
#' @importFrom lubridate with_tz
#'
#' @return the R POSIX.ct datetime(s)
#'
#'
#' @export
#'
#' @examples
#'
#' json_times <- "2019-07-17T21:10:48.245Z"
#'
#' convert_timestamp(json_times)
#'
convert_timestamp <- function(timestamp, tz = "America/New_York") {

  out <- as.POSIXct(timestamp, format="%Y-%m-%dT%H:%M:%S", tz = "UTC")

  lubridate::with_tz(out, tzone = tz)
}
