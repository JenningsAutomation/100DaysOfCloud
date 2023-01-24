**Add a cover photo like:**

![placeholder image](../020/codedeploy.png)

# Create Application for Pipeline

## Introduction

✍️ Today I create an application for my AWS CodeDeploy to run

## Prerequisite

✍️ You should be familiar with how to navigate around AWS

## Use Case

- You can't have a pipeline with out an application to run

## Cloud Research

- Continuing on with AWS Certified DevOps Engineer Professional 2022 course, by Stephane Maarek


### Step 1 — Create Application

Choose Application from the Deploy menu. Give it a name and choose a compute platform

![Screenshot](step22a_name_platform.png)

### Step 2 — Create Application

![Screenshot](step22c_codedeploysuccess.png)

### Step 3 — Create a IAM service role for Deployment

Choose CodeDeploy
![Screenshot](step24_create_service_role.png)

### Step 4 — Name the role and Accept

![Screenshot](step24a_iam.png)

![Screenshot](step24b_create_role.png)

### Step 5 — Create Deployment Group

![Screenshot](step22_create_codedeploy_app.png)

### Step 6 — Name the Deployment Group

Add service role that you just created.

![Screenshot](step25a_deploygroupdetails1.png)

### Step 7 — Choose In-Place Deployment for now

For now also, just pick Amazon Ec2 instances. Set key value pair of tags, Environment and Development.
Disable load balancing.

![Screenshot](step25a_deploygroupdetails1.png)

### Step 8 — Create Deployment

![Screenshot](step26_createDeployment.png)

### Step 9 — Create S3 Bucket

Enter the following commands in the CLI. Change the name to something else.
![Screenshot](step27_create_s3_bucket.png)

### Step 10 — Push Appsec and projectfolder.png

![Screenshot](step28_push_appspec_and_projectfolder.png)

### Step 11 — Review Details
If everything looks good create deployment
![Screenshot](step29_deployment_details.png

![Screenshot](step30_deployment_successful.png)

### Step 12 — Review Details
Deployment has succeeded. Click view events

![Screenshot](step31_succeeded.png)

![Screenshot](step31a_events.png)

### Step 13 - Verify
Go to your ec2 instance and edit the inbound rules. 
![Screenshot](Step32_edit_inbound.png)

Open the public dns and you should see a functioning web page. Unfortunately, I'll retrace my steps. 

## ☁️ Cloud Outcome

✍️ There are a lot of steps, and if you miss one of them, its not going to work. That said I was mostly successful, but i did not see a rendered page. So something is wrong or missing.

## Next Steps

✍️ I will have to review and retrace my steps. It will be good practice

## Social Proof

✍️ Show that you shared your process on Twitter or LinkedIn

[twitter](https://twitter.com/DemianJennings/status/1617718415896236033)
[linkedin](https://www.linkedin.com/posts/demian-jennings_100daysofcloud-aws-awspipeline-activity-7023484749855772673-YyO6?utm_source=share&utm_medium=member_desktop)
