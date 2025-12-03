delete_folder <- function(path, folders) {
  for (f in folders) {
    target <- file.path(path, f)
    
    if (dir.exists(target)) {
      unlink(target, recursive = TRUE)
      message("Deleted: ", target)
    } else {
      message("Folder not found: ", target)
    }
  }
}



delete_folder(folder,folders = c("testing3","testing2"))


move_file <- function(source, destination_folder) {
  
  # Create destination folder if missing
  if (!dir.exists(destination_folder)) {
    dir.create(destination_folder, recursive = TRUE)
  }
  
  # Build destination file path
  destination <- file.path(destination_folder, basename(source))
  
  # Move file
  file.rename(source, destination)
}

