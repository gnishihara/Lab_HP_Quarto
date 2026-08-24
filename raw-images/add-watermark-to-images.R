# Install the package if you do not have it: install.packages("magick")
library(magick)

# Define directories relative to the project root
raw_dir <- here::here("raw-images")
out_dir <- here::here("assets/images")

# Create the output directory if it doesn't exist
if (!dir.exists(out_dir)) {
  dir.create(out_dir)
}

# Find all JPEG and PNG files in the raw-images folder
image_files <- list.files(
  raw_dir,
  pattern = "\\.(jpg|jpeg)$",
  ignore.case = TRUE,
  full.names = TRUE
)

# Process each image
for (file_path in image_files) {
  # 1. Read the original image
  img <- image_read(file_path)

  # 2. Resize the image (e.g., scale to a maximum width of 800 pixels)
  # The geometry "800x" automatically adjusts the height to maintain the aspect ratio
  img_resized <- image_scale(img, "800x")

  # 3. Add the watermark
  img_watermarked <- image_annotate(
    img_resized,
    text = "© Nagasaki University Laboratory of Aquatic Plant Ecology",
    size = 20,
    color = "rgba(255,255,255,0.5)",
    gravity = "southeast", # Places it in the bottom right corner
    location = "+10+10"
  ) # 10px padding from the edges

  # 4. Save the processed image to the official images/ folder
  # Extract just the file name to use for the output
  file_name <- tolower(basename(file_path))
  out_path <- file.path(out_dir, file_name)

  image_write(img_watermarked, path = out_path)

  cat("Processed and saved:", file_name, "\n")
}
