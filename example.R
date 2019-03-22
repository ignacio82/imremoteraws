# IMS3::set.enviroment() # A personal package that sets my S3 credentials
library(aws.ec2)
library(aws.s3)
IMSecrets::AWS()  # Personal package that setup the enviromental variables for aws

# save to bucket
put_object("./example.Rmd", bucket = "ignacios-test-bucket", object = "example.Rmd") # Saves the markdown to my S3 bucket

# start AWS vm
my_vm <- run_instances(image = "ami-05f39d58b5ff0d8e2", # My remoter ami
                       type = "t2.medium",
                       sgroup = "sg-073bb39404d5b2c8a") # A security group that only allows remoter connections

vm_status <- instance_status(my_vm)

while (is.null(vm_status$item$instanceStatus$status) | vm_status$item$instanceStatus$status !="ok") {
  message(glue::glue("Instance is {vm_status$item$instanceStatus$status}."))
  Sys.sleep(20)
  vm_status <- instance_status(my_vm)
  if(vm_status$item$instanceStatus$status =="ok") message("The instance is ready.")
}

# Run job 

remoter::batch(addr = get_instance_public_ip(my_vm)[[1]], 
               port = IMSecrets::IMremoter()$port, 
               password = IMSecrets::IMremoter()$password, 
               file = "script.R") 

# Download the results

aws.s3::s3sync(bucket = "ignacios-test-bucket", direction = "download") 

# Terminate the instance

terminate_instances(my_vm)

