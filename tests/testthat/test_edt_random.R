#Automated testing for EDT
library(psychTestR)
library(testthat)

w_dir <- getwd()

if (substr(w_dir, nchar(w_dir)-13, nchar(w_dir)) != "tests/testthat") { # if file paths ends on "EDT"
  dir_app <- "R/edt"
  print("App Direction")
  print(dir_app)
} else if (substr(w_dir, nchar(w_dir)-13, nchar(w_dir)) != "testthat") { # if file paths ends on "testthat"
  print(getwd())
  dir_app <- paste0(strtrim(w_dir, nchar(w_dir)-14), "R/edt")
  print("App Direction")
  print(dir_app)
}

number_items <- 18 #number of items

app <<- AppTester$new(dir_app)

# ID
app$expect_ui_text("Please enter your ID. Continue")
app$set_inputs(p_id = "abcde")
app$click_next()

# Welcome
app$expect_ui_text("Welcome to the Emotion Discrimination Test You will now hear two different versions of a melody at a time; these will differ in terms of the emotions expressed between performances. Your task is to judge the emotional expression of each version by selecting which of the two melodies you believe to be most representative of the emotion in question. Questions may be repeated, so do not worry about making the same selection twice. Please listen to each sound clip in full before making your decision. If you don’t know the answer, give your best guess. Continue")
app$click_next()


# Main test
q <- 1 # Number of question
for (i in sample(1:2, number_items, replace=TRUE)){
  #app$expect_ui_text(paste("Question", q, "out of", number_items, "Please listen to the following clips and select which one sounds angrier to you. Select 1 for the clip heard before the buzzer, or 2 for the clip heard after the buzzer. <U+25B6> 1 2")) # ??? Wie kann Medium eingebunden werden?
  app$click(i)
  print(paste("answer id =", i))
  q <- q + 1
}

app$expect_ui_text("You have completed the Emotion Discrimination Test. Next")
app$click_next()

if (TRUE) {
  # export Results
  results <- app$get_results() %>% as.list()
  EDT_ability_sem <<- results[["EDT"]][["ability_sem"]]
  EDT_ability <<- results[["EDT"]][["ability"]]

  print(paste("Standard error of measurement of EDT", EDT_ability_sem))
}

app$stop()
