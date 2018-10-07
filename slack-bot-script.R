# Packages ----------------------------------------------------------------
#install.packages(c('plumber','magrittr','ggplot2','urltools','datasets'))
library(plumber)
library(magrittr)
library(ggplot2)
# library(data.table)

d <- datasets::airquality
d$date = paste0('1973-', sprintf("%02d",d$Month), '-', sprintf('%02d', d$Day))
print(dim(d))


# Filter ------------------------------------------------------------------
#* Parse the incoming request and route it to the appropriate endpoint
#* @filter route-endpoint
function(req, text = "") {
  # Identify endpoint
  split_text <- urltools::url_decode(text) %>%
    strsplit(" ") %>%
    unlist()
  
  if (length(split_text) >= 1) {
    endpoint <- split_text[[1]]
    
    # Modify request with updated endpoint
    req$PATH_INFO <- paste0("/", endpoint)
    
    # Modify request with remaining commands from text
    req$ARGS <- split_text[-1] %>% 
      paste0(collapse = " ")
  }
  
  # Forward request 
  forward()
}


# Logger ------------------------------------------------------------------
#* Log information about the incoming request
#* @filter logger
function(req){
  cat(as.character(Sys.time()), "-", 
      req$REQUEST_METHOD, req$PATH_INFO, "-", 
      req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n"
  )
  
  # Forward request
  forward()
}


# Return message ----------------------------------------------------------
#* Return a message containing status details about the customer
#* @serializer unboxedJSON
#* @post /status
function(req, res) {
  # Check req$ARGS and match to customer - if no customer match is found, return an error
  if (!req$ARGS %in% d$date) {
    #res$status <- 400
    return(
      list(
        response_type = "ephemeral",
        text = paste0('cannot find data for date: ', req$ARGS, '. Data is available between ')
      )
    )
  }
  
  d_day <- subset(d, d$date == req$ARGS)
  
  if (dim(d_day)[1] > 1) {d_day <- d_day[1,]}
  
  # Build response
  list(
    # response type - ephemeral indicates the response will only be seen by the
    # user who invoked the slash command as opposed to the entire channel
    response_type = "ephemeral",
    # attachments is expected to be an array, hence the list within a list
    attachments = list(
      list(
        color = 1,
        title =    paste0("Status update for date: ", d_day$date),
        fallback = paste0("Status update for date: ", d_day$date),
        ## History plot
        #image_url = paste0("localhost:5762/plot/history/", customer_id),
        ## Fields provide a way of communicating semi-tabular data in Slack
        fields = list(
          list(
            title = "Ozone",
            value = d_day$Ozone,
            short = TRUE
          ),
          list(
            title = "Solar Radiation",
            value = d_day$Solar.R,
            short = TRUE
          ),
          list(
            title = "Wind",
            value = d_day$Wind,
            short = TRUE
          ),
          list(
            title = "Temperature",
            value = d_day$Temp,
            short = TRUE
          )
        )
      )
    )
  )
}
