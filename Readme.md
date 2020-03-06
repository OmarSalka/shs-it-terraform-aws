# Terraform Instructions

## About the architecture

This terraform file deploys the following services:

- VPC (& its networking components - igw, route table, subnet, NACL)
- S3
- API Gateway
- 2 lambdas
- CodeCommit
- DynamoDB

## The code

There are 3 pieces of code:

- Lambda function: Using Python Boto3 - (Terraform file: shs-it-api.py)

  - This function gets triggered when the front-end makes an API call. It takes the data it receives from the API call and populates the proper DynamoDB table
  - The function gets auto-updated upon "terraform apply" if changes were made to this file.

- Lambda function: Using Python Boto3 - (Terraform file: codecommit-lambda-trigger.py)

  - This function gets triggered when code is being pushed to the master branch in the codecommit repository.
  - The function gets auto-updated upon "terraform apply" if changes were made to this file.

- Code Commit repository: (Terraform folder: front-end):
  - This is the react front end
  - Can push changes to the front end folder to our codecommit repository so it can be automatically sent to the appropriate S3 static web hosting bucket

## How to execute the terraform code

1. clone the code from the git repo to your local machine
2. under _shs-it-api_ folder add a new file and name it **terraform.tfvars**
3. In terraform.tfvars add the following variables and give them values:
   - AWS_ACCESS_KEY = ""
   - AWS_SECRET_KEY = ""
   - AWS_REGION = ""
   - S3_BUCKET_NAME = ""
   - ACCOUNT_ID = ""
   - CODECOMMIT_REPO = ""
   - BRANCH = ""
4. in your integrated terminal (if you're using an IDE like VS Code) or on your native computer terminal, cd to **shs-it-api** folder
5. run **terraform init**
6. then Run **terraform plan -out filename_of_your_choice**
7. Run **terraform apply "filename_of_your_choice"**
8. You will see _api-gateway-invoke-url_ as an output variable. Copy that url and head over to _front-end/src/App.js_ replace the url that exists inside the _handleSubmit_ function and add **/shs-it/api** to the end of the url
9. Navigate to the _front-end_ folder on your terminal and run **npm run build**
10. Head over to the build folder on your terminal, intialize a git repository by running **git init**
11. run **git add .** and **git commit -m 'commit message of your choice'**
12. copy the value of clone_url_http under the terraform outputs printed on your terminal
13. run **git add remote origin value_of_clone_url_http**
14. if you were promted to enter HTTPS Git credentials for AWS CodeCommit. You can do this by going to one of your existing users or newly created one. Click on the _Security credentials_ tab and scroll to _HTTPS Git credentials for AWS CodeCommit_ click \*Generate Credentials and use them to access the codecommit repo.
15. after that run **git push -u origin master**
    _Congrats, your react-build files have been uploaded to codecommit._

- Now everytime you make a change you have to run the string of commands, in order:
  - **cd front-end**
  - **npm run build**
  - **cd build**
  - **git init**
  - **git add .**
  - **git commit -m 'message'**
  - **git add remote origin value_of_clone_url_http**
    **git push -u origin master**

### You might be wondering why you have to repeat the above steps. The reason is S3 prefers the index file to be on the first level after the bucket name. In addition, terraform does not support sending folders. It can only upload objects one at a time.

Code commit is connected to an AWS lambda function that gets triggered everytime someone pushes changes to the codeCommit repository. This lambda function takes those files and copies them to the S3 bucket that's hosting the react-web-app. **Make sure the bucket name you choose is unique**

16. Finally copy the website_endpoint from the terraform outputs and open it in your browser.

## Congratulations! You have now run a serverless app on AWS with lambda functions that get updated automatically every time you run the **terraform apply "filename_of_your_choice"** command. We also have an S3 bucket that hosts our react-build files. The objects in this bucket get auto-updated when codeCommit detects a "push" to the relevant codeCommit repo
