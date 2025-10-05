# then inside the container:
terraform init
terraform plan
terraform apply

# Start the interactive Terraform console inside your project:

terraform console


Then just type the variable name:

> var.grafana_endpoint
"http://grafana:3000"

