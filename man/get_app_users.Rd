% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_app_users.R
\name{get_app_users}
\alias{get_app_users}
\title{get_app_users}
\usage{
get_app_users(conn, app_name_ = NULL)
}
\arguments{
\item{conn}{the database connection}

\item{app_name_}{the name of the app or `NULL` to get all app users. Defaults to NULL.}
}
\value{
a data frame of the app users from the polished schema.
}
\description{
get_app_users
}
