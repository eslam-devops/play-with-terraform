Terraform AWS S3 + EC2 Web Server Project

Project Overview
This project demonstrates how to use Terraform to provision an AWS infrastructure that hosts a simple website using Amazon S3 and Amazon EC2.

Amazon S3 is used as a storage layer for website files, while Amazon EC2 runs an Apache web server that serves these files. The EC2 instance securely accesses S3 using an IAM Role without storing any AWS credentials on the server.

Architecture
The project follows this architecture:

User accesses the website via HTTP
The request goes to an EC2 instance running Apache
The EC2 instance pulls website files from an S3 bucket using aws s3 sync
The files are served from /var/www/html

Technologies Used
Terraform
AWS EC2
AWS S3
AWS IAM
AWS VPC
Amazon Linux 2
Apache HTTP Server

Project Structure
The project files are organized as follows:

main.tf
variables.tf
outputs.tf
README.md

What This Project Does
Creates a custom VPC with a public subnet
Creates an Internet Gateway and routing for internet access
Launches an EC2 instance with a public IP address
Installs Apache automatically using user_data
Creates an S3 bucket to store website files
Attaches an IAM role to the EC2 instance to allow read access to S3
Syncs website files from S3 to /var/www/html on the EC2 instance

Security
EC2 accesses S3 using an IAM Role (no access keys stored on the server)
Security Group allows SSH and HTTP access (for learning purposes only)
S3 access is restricted to read-only permissions for the EC2 instance

Uploading Website Files to S3
To upload a single file such as index.html to the S3 bucket:

aws s3 cp index.html s3://my-simple-bucket-eslam-123456/my-portfolio/index.html

To upload a full website folder:

aws s3 sync my-portfolio s3://my-simple-bucket-eslam-123456/my-portfolio

Syncing Files from S3 to EC2
On the EC2 instance, run:

sudo aws s3 sync s3://my-simple-bucket-eslam-123456/my-portfolio /var/www/html

If needed, restart Apache:

sudo systemctl restart httpd

Accessing the Website
After deployment, access the website using the EC2 public IP address:

http://<EC2_PUBLIC_IP>

You can retrieve the public IP using Terraform:

terraform output ec2_public_ip

Notes
The S3 bucket name must be globally unique
The EC2 key pair must already exist in the selected AWS region
This project is intended for learning and demonstration purposes
For production environments, consider using HTTPS, CI/CD pipelines, and services such as CloudFront or Application Load Balancers

Destroying the Infrastructure
To remove all AWS resources created by Terraform, run:

terraform destroy

Author
Eslam Zain
DevOps Engineer (Terraform & AWS)

Learning Outcome
This project helps build practical understanding of Infrastructure as Code, secure access between EC2 and S3, AWS networking fundamentals, and real-world Terraform workflows.
