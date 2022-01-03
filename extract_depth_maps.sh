for image in $1/*.jpg
do
   image_name=$(echo ${image} | cut -d '.' -f 1)
   exiftool -b -MPImage3 "${image_name}.jpg" > "${image_name}_depth.jpg"
done
