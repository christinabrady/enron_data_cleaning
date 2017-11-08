### enron data exploration
options(stringsAsFactors = FALSE)
setwd("~/Documents/codebase/enron")
library(readr)
library(stringr)

flpath <- "~/Documents/data_files/maildir"  ### I keep my data and my code separately, so I always create a path to my data

### explore the file structure and what's here

user_folders <- list.files(flpath)
email_folders <- unlist(lapply(user_folders, function(uf) list.files(sprintf("%s/%s", flpath, uf))))
dup_folders <- table(email_folders)
head(sort(dup_folders, decreasing = TRUE))

### how many emails are in each inbox?
nEmails <- function(folder, filepath){
  unlist(lapply(user_folders, function(uf){
    n <- list.files(sprintf("%s/%s/%s", filepath, uf, folder))
    return(length(n))
  }))
}

inboxes <- nEmails("inbox", flpath)
boxplot(inboxes)
sent_items <- nEmails("sent_items", flpath)
boxplot(sent_items)
plot(inboxes, sent_items, xlab = "Email Recieved", ylab = "Email Sent")
### what's wrong with this picture? Does it include ALL email sent and/or received?

### let's see how many message ids there are
mids <- unlist(lapply(user_folders, function(uf){
  more_user_folders <- list.files(sprintf("%s/%s", flpath, uf), full.names = TRUE)
  unlist(lapply(more_user_folders, function(muf){
    emails <- list.files(muf, full.names = TRUE, pattern = "\\.")
    unlist(lapply(emails, function(em){
      tmp <- read_lines(em)
      id_line <- grep("Message-ID", tmp, value = TRUE)
      start_indy <- str_locate(id_line, "<")
      end_indy <- str_locate(id_line, ">")
      return(substr(id_line, start_indy[, 1] + 1, end_indy[, 1] - 1))
    }))
  }))
}))
sprintf("There are %s files with Message IDs and %s Message IDs", length(mids), length(unique(mids)))
duplicate_emails <- mids[duplicated(mids)]

read_lines(sprintf("%s/%s/%s/%s", flpath, user_folders[[1]], "inbox", "1."))

### Network ###
### use the folders to identify who people receive email from
email_from <- lapply(user_folders, function(uf){
  flnames <- list.files(sprintf("%s/%s/inbox", flpath, uf), full.names = TRUE)
  unlist(lapply(flnames, function(fn){
    txt <- read_lines(fn)
    from_line <- grep("From:", txt)
    ### with regular expressions:
    ### some letters or numbers, a dot (0 or more times)
    # str_extract("[a-zA-Z0-9]+\\.{1,0}")

    ### string split
    strsplit(txt[from_line[1]], " ")[[1]][2]
  }))
})
### throws an error because it finds a folder, show how to add a pattern to list.files
email_from <- lapply(user_folders, function(uf){
    flnames <- list.files(sprintf("%s/%s/inbox", flpath, uf), full.names = TRUE, pattern = "\\.")
    unlist(lapply(flnames, function(fn){
      txt <- read_lines(fn)
      from_line <- grep("From:", txt)
      ### with regular expressions:
      ### some letters or numbers, a dot (0 or more times)
      # str_extract("[a-zA-Z0-9]+\\.{1,0}")

      ### string split
      strsplit(txt[from_line[1]], " ")[[1]][2]
  }))
})
### inspect it
email_from[[1]]
### not terribly helpful because we can't match the folder name to an email...
### lets see if we can create an mapping of folder name to email address

email_to <- lapply(user_folders, function(uf){
    flnames <- list.files(sprintf("%s/%s/inbox", flpath, uf), full.names = TRUE, pattern = "\\.")
    unlist(lapply(flnames, function(fn){
      txt <- read_lines(fn)
      from_line <- grep("To", txt)
      ### with regular expressions:
      ### some letters or numbers, a dot (0 or more times)
      # str_extract("[a-zA-Z0-9]+\\.{1,0}")

      ### string split
      strsplit(txt[from_line[1]], " ")[[1]][2]
  }))
})

### same email in different ways. What should we do with that?
# 1. choose the most frequently used one?
# 2. choose one and rewrite all other instances?
# 3. use all of them?
# 4. use the folder name to identify relevant email address

email_map <- lapply(1:length(user_folders), function(i){
    flnames <- list.files(sprintf("%s/%s/inbox", flpath, user_folders[i]), full.names = TRUE, pattern = "\\.")
    to_addys <- unlist(lapply(flnames, function(fn){
        txt <- read_lines(fn)
        to_line <- grep("To", txt)
        ### with regular expressions:
        ### some letters or numbers, a dot (0 or more times)
        # str_extract("[a-zA-Z0-9]+\\.{1,0}")

        ### string split
        strsplit(txt[to_line[1]], " ")[[1]][2]
      }))
      last_name <- strsplit(user_folders[i], "-")[[1]][1]
      first_initial <- strsplit(user_folders[i], "-")[[1]][2]
      return(unique(grep(sprintf("%s.*%s@enron.com", first_initial, last_name), to_addys, value = TRUE)))
      ## matches first initial + any character 0 or more times + last name @enron.com
})
addys_per_person <- unlist(lapply(email_map, length))
barplot(addys_per_person)
email_map[[100]]

## take the commas out
email_map <- lapply(1:length(user_folders), function(i){
    flnames <- list.files(sprintf("%s/%s/inbox", flpath, user_folders[i]), full.names = TRUE, pattern = "\\.")
    to_addys <- unlist(lapply(flnames, function(fn){
        txt <- read_lines(fn)
        to_line <- grep("To", txt)
        ### with regular expressions:
        ### some letters or numbers, a dot (0 or more times)
        # str_extract("[a-zA-Z0-9]+\\.{1,0}")

        ### string split
        tmp <- strsplit(txt[to_line[1]], " ")[[1]][2]
        gsub(",", "", tmp)
      }))
      last_name <- strsplit(user_folders[i], "-")[[1]][1]
      first_initial <- strsplit(user_folders[i], "-")[[1]][2]
      return(unique(grep(sprintf("%s.*%s@enron.com", first_initial, last_name), to_addys, value = TRUE)))
})
addys_per_person <- unlist(lapply(email_map, length))
barplot(addys_per_person)
email_map[[100]]


###
